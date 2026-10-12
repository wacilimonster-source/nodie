import 'package:drift/drift.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/database/tables.dart';

part 'daos.g.dart';

@DriftAccessor(
  tables: [
    Medications,
    Schedules,
    IntakeEvents,
    ProductIngredients,
    Nutrients,
    ProductPresets,
    ProductPresetIngredients,
  ],
)
class AppDao extends DatabaseAccessor<AppDatabase> with _$AppDaoMixin {
  AppDao(super.db);

  // ==================== Medications ====================

  Stream<List<MedicationRow>> watchAllMeds() =>
      (select(medications)
            ..where((t) => t.isDeleted.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  Future<List<MedicationRow>> getAllMeds() =>
      (select(medications)..where((t) => t.isDeleted.equals(false))).get();

  Future<MedicationRow?> getMed(String id) async =>
      (select(medications)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertMed(MedicationRow row) =>
      into(medications).insertOnConflictUpdate(row);

  Future<void> deleteMed(String id) async {
    final now = DateTime.now();
    await (update(medications)..where((t) => t.id.equals(id))).write(
      MedicationsCompanion(
        isDeleted: const Value(true),
        isActive: const Value(false),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> setMedActive(String id, bool active) =>
      (update(medications)..where((t) => t.id.equals(id))).write(
        MedicationsCompanion(
          isActive: Value(active),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> updateStock(String id, double remaining) =>
      (update(medications)..where((t) => t.id.equals(id))).write(
        MedicationsCompanion(
          stockRemaining: Value(remaining),
          updatedAt: Value(DateTime.now()),
        ),
      );

  // ==================== Schedules ====================

  Stream<List<ScheduleRow>> watchActiveSchedules() =>
      (select(schedules)..where((t) => t.isActive.equals(true))).watch();

  Stream<List<ScheduleRow>> watchAllSchedules() =>
      (select(schedules)..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).watch();

  /// 全部激活计划（事件生成用）
  Future<List<ScheduleRow>> getActiveSchedulesAll() =>
      (select(schedules)..where((t) => t.isActive.equals(true))).get();

  /// 全部计划（含已结束，通知重排取单位用）
  Future<List<ScheduleRow>> allSchedules() => select(schedules).get();

  Future<List<ScheduleRow>> getActiveSchedulesForMed(String medId) =>
      (select(schedules)
            ..where((t) => t.medicationId.equals(medId) & t.isActive.equals(true)))
          .get();

  Stream<List<ScheduleRow>> watchSchedulesForMed(String medId) =>
      (select(schedules)..where((t) => t.medicationId.equals(medId)))
          .watch();

  Future<void> upsertSchedule(ScheduleRow row) =>
      into(schedules).insertOnConflictUpdate(row);

  Future<void> setScheduleEnded(String scheduleId) async {
    await (update(schedules)..where((t) => t.id.equals(scheduleId)))
        .write(const SchedulesCompanion(isActive: Value(false)));
  }

  /// 结束某药的全部计划（编辑/删除时保留历史事件）
  Future<void> endSchedulesForMed(String medId) async {
    await (update(schedules)..where((t) => t.medicationId.equals(medId)))
        .write(const SchedulesCompanion(isActive: Value(false)));
  }

  // ==================== IntakeEvents ====================

  Stream<List<IntakeEventRow>> watchEventsOn(String planDate) =>
      (select(intakeEvents)..where((t) => t.planDate.equals(planDate))).watch();

  Stream<List<IntakeEventRow>> watchEventsBetween(String from, String to) =>
      (select(intakeEvents)
            ..where((t) => t.planDate.isBiggerOrEqualValue(from) & t.planDate.isSmallerOrEqualValue(to))
            ..orderBy([(t) => OrderingTerm.asc(t.planDate), (t) => OrderingTerm.asc(t.planTime)]))
          .watch();

  Future<List<IntakeEventRow>> eventsOn(String planDate) =>
      (select(intakeEvents)..where((t) => t.planDate.equals(planDate))).get();

  Future<IntakeEventRow?> findEvent(String scheduleId, String planDate, String planTime) =>
      (select(intakeEvents)
            ..where((t) =>
                t.scheduleId.equals(scheduleId) &
                t.planDate.equals(planDate) &
                t.planTime.equals(planTime)))
          .getSingleOrNull();

  /// 全量 pending（漏服判定用，单机数据量小）
  Future<List<IntakeEventRow>> pendingEvents() =>
      (select(intakeEvents)..where((t) => t.status.equals('pending'))).get();

  Future<List<IntakeEventRow>> eventsInRange(String from, String to) =>
      (select(intakeEvents)
            ..where((t) => t.planDate.isBiggerOrEqualValue(from) & t.planDate.isSmallerOrEqualValue(to)))
          .get();

  Future<void> insertEvents(List<IntakeEventsCompanion> rows) async {
    await batch((b) {
      b.insertAll(intakeEvents, rows, mode: InsertMode.insertOrIgnore);
    });
  }

  Future<void> insertEventCompanion(IntakeEventsCompanion row) =>
      into(intakeEvents).insert(row, mode: InsertMode.insertOrIgnore);

  Future<IntakeEventRow?> eventById(String id) =>
      (select(intakeEvents)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> setEventNote(String id, String note) =>
      (update(intakeEvents)..where((t) => t.id.equals(id))).write(
        IntakeEventsCompanion(note: Value(note), updatedAt: Value(DateTime.now())),
      );

  Future<void> updateEventStatus(
    String id,
    String status, {
    int? actualAt,
    double? actualDose,
  }) async {
    await (update(intakeEvents)..where((t) => t.id.equals(id))).write(
      IntakeEventsCompanion(
        status: Value(status),
        actualAt: Value(actualAt),
        actualDose: Value(actualDose),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 补记/改判（历史日期用）
  Future<void> fixEvent(String id, String status, {int? actualAt, double? actualDose}) async {
    await (update(intakeEvents)..where((t) => t.id.equals(id))).write(
      IntakeEventsCompanion(
        status: Value(status),
        actualAt: Value(actualAt),
        actualDose: Value(actualDose),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteEvent(String id) =>
      (delete(intakeEvents)..where((t) => t.id.equals(id))).go();

  // ==================== ProductIngredients ====================

  Stream<List<ProductIngredientRow>> watchIngredients() => select(productIngredients).watch();

  Future<List<ProductIngredientRow>> ingredientsForMed(String medId) =>
      (select(productIngredients)..where((t) => t.medicationId.equals(medId))).get();

  Future<void> upsertIngredient(ProductIngredientRow row) =>
      into(productIngredients).insertOnConflictUpdate(row);

  Future<void> deleteIngredientsForMed(String medId) =>
      (delete(productIngredients)..where((t) => t.medicationId.equals(medId))).go();

  Future<void> deleteIngredient(String id) =>
      (delete(productIngredients)..where((t) => t.id.equals(id))).go();

  // ==================== Nutrients ====================

  Future<List<NutrientRow>> allNutrients() => select(nutrients).get();

  Future<NutrientRow?> nutrientByCode(String code) =>
      (select(nutrients)..where((t) => t.code.equals(code))).getSingleOrNull();

  /// 清空全部业务数据（保留营养字典）
  Future<void> clearAll() async {
    await transaction(() async {
      await delete(intakeEvents).go();
      await delete(productIngredients).go();
      await delete(schedules).go();
      await delete(medications).go();
    });
  }

  // ==================== 配方模板 ProductPresets ====================

  Stream<List<ProductPresetRow>> watchPresets() =>
      (select(productPresets)
            ..orderBy([
              (t) => OrderingTerm.desc(t.isFavorite),
              (t) => OrderingTerm.asc(t.category),
              (t) => OrderingTerm.asc(t.id),
            ]))
          .watch();

  Future<ProductPresetRow?> presetById(String id) =>
      (select(productPresets)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<ProductPresetIngredientRow>> presetIngredients(String presetId) =>
      (select(productPresetIngredients)..where((t) => t.presetId.equals(presetId))).get();

  Stream<List<ProductPresetIngredientRow>> watchPresetIngredients() =>
      select(productPresetIngredients).watch();

  Future<void> upsertPreset(ProductPresetRow row) =>
      into(productPresets).insertOnConflictUpdate(row);

  Future<void> replacePresetIngredients(
    String presetId,
    List<ProductPresetIngredientRow> rows,
  ) async {
    await transaction(() async {
      await (delete(productPresetIngredients)..where((t) => t.presetId.equals(presetId))).go();
      await batch((b) {
        b.insertAll(productPresetIngredients, rows, mode: InsertMode.insertOrReplace);
      });
    });
  }

  Future<void> deletePreset(String id) async {
    await transaction(() async {
      await (delete(productPresetIngredients)..where((t) => t.presetId.equals(id))).go();
      await (delete(productPresets)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> setPresetFavorite(String id, bool favorite) =>
      (update(productPresets)..where((t) => t.id.equals(id)))
          .write(ProductPresetsCompanion(isFavorite: Value(favorite)));

  // ==================== 用户自定义成分 ====================

  Future<void> upsertCustomNutrient(NutrientRow row) =>
      into(nutrients).insertOnConflictUpdate(row);
}
