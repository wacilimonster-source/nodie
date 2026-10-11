import 'package:cyjl/core/date_utils.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/core/id.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/domain/plan_slot.dart';

/// 新增/编辑药品的草稿（向导收集）
class MedDraft {
  const MedDraft({
    this.id,
    required this.name,
    required this.type,
    required this.form,
    required this.color,
    required this.emoji,
    this.instruction,
    this.note,
    this.stockEnabled = false,
    this.stock,
    this.lowStockDays = 7,
    required this.freq,
    this.weekdays = const [],
    this.intervalDays = 3,
    this.cycleOn = 5,
    this.cycleOff = 2,
    required this.slots,
    required this.unit,
    required this.startDate,
    this.endDate,
    this.ingredients = const [],
  });

  final String? id;
  final String name;
  final MedType type;
  final String form;
  final String color;
  final String emoji;
  final String? instruction;
  final String? note;
  final bool stockEnabled;
  final double? stock;
  final int lowStockDays;
  final FreqType freq;
  final List<int> weekdays;
  final int intervalDays;
  final int cycleOn;
  final int cycleOff;
  final List<PlanSlot> slots;
  final String unit;
  final DateTime startDate;
  final DateTime? endDate;
  final List<IngredientDraft> ingredients;
}

class MedicationRepository {
  MedicationRepository(this.dao);

  final AppDao dao;

  /// 每日总剂量（低库存天数折算用）
  double dailyDoseOf(List<PlanSlot> slots, FreqType freq) {
    if (freq == FreqType.asNeeded) return 1;
    return slots.fold<double>(0, (sum, s) => sum + s.dose);
  }

  /// 新建（事务：药 + 计划 + 成分）
  Future<String> create(MedDraft draft) async {
    final now = DateTime.now();
    final medId = newId();
    await dao.transaction(() async {
      await dao.upsertMed(MedicationRow(
        id: medId,
        name: draft.name,
        type: draft.type.code,
        form: draft.form,
        color: draft.color,
        emoji: draft.emoji,
        instruction: draft.instruction,
        note: draft.note,
        stockEnabled: draft.stockEnabled,
        stockRemaining: draft.stockEnabled ? draft.stock : null,
        lowStockDays: draft.lowStockDays,
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ));

      await dao.upsertSchedule(ScheduleRow(
        id: newId(),
        medicationId: medId,
        freqType: draft.freq.code,
        weekdays: draft.freq == FreqType.weekly ? encodeWeekdays(draft.weekdays) : null,
        intervalDays: draft.freq == FreqType.everyNDays ? draft.intervalDays : null,
        cycleOn: draft.freq == FreqType.cycle ? draft.cycleOn : null,
        cycleOff: draft.freq == FreqType.cycle ? draft.cycleOff : null,
        times: encodeSlots(draft.slots),
        unit: draft.unit,
        startDate: draft.startDate,
        endDate: draft.endDate,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      await _replaceIngredients(medId, draft.ingredients, now);
    });
    return medId;
  }

  /// 编辑（保留历史事件：结束旧计划，写新计划）
  Future<void> update(MedDraft draft) async {
    final id = draft.id!;
    final now = DateTime.now();
    final existing = await dao.getMed(id);
    if (existing == null) return;

    await dao.transaction(() async {
      await dao.upsertMed(MedicationRow(
        id: id,
        name: draft.name,
        type: draft.type.code,
        form: draft.form,
        color: draft.color,
        emoji: draft.emoji,
        instruction: draft.instruction,
        note: draft.note,
        stockEnabled: draft.stockEnabled,
        stockRemaining: draft.stockEnabled ? draft.stock : null,
        lowStockDays: draft.lowStockDays,
        isActive: existing.isActive,
        isDeleted: false,
        createdAt: existing.createdAt,
        updatedAt: now,
      ));

      // 结束旧计划 → 新建计划（历史事件不受影响）
      await dao.endSchedulesForMed(id);
      await dao.upsertSchedule(ScheduleRow(
        id: newId(),
        medicationId: id,
        freqType: draft.freq.code,
        weekdays:
            draft.freq == FreqType.weekly ? encodeWeekdays(draft.weekdays) : null,
        intervalDays:
            draft.freq == FreqType.everyNDays ? draft.intervalDays : null,
        cycleOn: draft.freq == FreqType.cycle ? draft.cycleOn : null,
        cycleOff: draft.freq == FreqType.cycle ? draft.cycleOff : null,
        times: encodeSlots(draft.slots),
        unit: draft.unit,
        startDate: draft.startDate,
        endDate: draft.endDate,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      await _replaceIngredients(id, draft.ingredients, now);
    });
  }

  Future<void> _replaceIngredients(String medId, List<IngredientDraft> list, DateTime now) async {
    await dao.deleteIngredientsForMed(medId);
    for (final i in list) {
      await dao.upsertIngredient(ProductIngredientRow(
        id: newId(),
        medicationId: medId,
        nutrientCode: i.nutrientCode,
        amountPerUnit: i.amountPerUnit,
        createdAt: now,
      ));
    }
  }

  Future<void> addIngredient(String medId, IngredientDraft draft) async {
    await dao.upsertIngredient(ProductIngredientRow(
      id: newId(),
      medicationId: medId,
      nutrientCode: draft.nutrientCode,
      amountPerUnit: draft.amountPerUnit,
      createdAt: DateTime.now(),
    ));
  }

  Future<void> removeIngredient(String ingredientId) => dao.deleteIngredient(ingredientId);

  Future<void> setActive(String medId, bool active) => dao.setMedActive(medId, active);

  Future<void> softDelete(String medId) async {
    await dao.endSchedulesForMed(medId);
    await dao.deleteMed(medId);
  }
}
