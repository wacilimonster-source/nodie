import 'dart:math' as math;

import 'package:cyjl/core/date_utils.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/core/id.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/domain/plan_slot.dart';

/// 事件生成器：活跃计划 × 日期区间 → pending 事件（幂等、可补生成）
class EventGenerator {
  EventGenerator(this.dao);

  final AppDao dao;

  /// 生成 [today, today + daysAhead-1] 的计划事件。
  /// 规则：计划时刻早于「计划创建时刻」的事件不生成（避免新建计划当日回溯出漏服）。
  Future<int> run({int daysAhead = 7, DateTime? now}) async {
    final schedules = await dao.getActiveSchedulesAll();
    if (schedules.isEmpty) return 0;

    final ref = now ?? DateTime.now();
    final today = DateTime(ref.year, ref.month, ref.day);
    final inserts = <IntakeEventsCompanion>[];

    for (final s in schedules) {
      final med = await dao.getMed(s.medicationId);
      if (med == null || !med.isActive) continue;
      if (s.endDate != null && today.isAfter(s.endDate!)) continue;

      final slots = decodeSlots(s.times);
      for (var i = 0; i < daysAhead; i++) {
        final date = today.add(Duration(days: i));
        if (!matchesSchedule(
          freqType: s.freqType,
          weekdaysJson: s.weekdays,
          intervalDays: s.intervalDays,
          cycleOn: s.cycleOn,
          cycleOff: s.cycleOff,
          startDate: s.startDate,
          target: date,
        )) {
          continue;
        }
        for (final slot in slots) {
          final planAt = combine(ymd(date), slot.time);
          if (planAt.isBefore(s.createdAt)) continue;
          final existing = await dao.findEvent(s.id, ymd(date), slot.time);
          if (existing != null) continue;
          inserts.add(
            IntakeEventsCompanion.insert(
              id: newId(),
              medicationId: s.medicationId,
              scheduleId: s.id,
              planDate: ymd(date),
              planTime: slot.time,
              planDose: slot.dose,
              status: EventStatus.pending.code,
              createdAt: ref,
              updatedAt: ref,
            ),
          );
        }
      }
    }
    if (inserts.isNotEmpty) {
      await dao.insertEvents(inserts);
    }
    return inserts.length;
  }

  /// 清理失效的「未来 pending」事件：
  /// 药已暂停/删除、或其计划已结束（编辑时旧计划会被置为 inactive）。
  /// 历史（已过去）事件一律保留。
  Future<int> pruneStale({DateTime? now}) async {
    final ref = now ?? DateTime.now();
    final meds = {for (final m in await dao.getAllMeds()) m.id: m};
    final schedules = {for (final s in await dao.allSchedules()) s.id: s};
    final pending = await dao.pendingEvents();
    var removed = 0;
    for (final e in pending) {
      final planAt = combine(e.planDate, e.planTime);
      if (planAt.isBefore(ref)) continue;
      final med = meds[e.medicationId];
      final sch = schedules[e.scheduleId];
      final stale = med == null ||
          !med.isActive ||
          sch == null ||
          !sch.isActive ||
          sch.medicationId != e.medicationId;
      if (stale) {
        await dao.deleteEvent(e.id);
        removed++;
      }
    }
    return removed;
  }
}

/// 漏服判定：pending 且计划时刻 < now - confirmWindow → missed
class MissedMarker {
  MissedMarker(this.dao);

  final AppDao dao;

  Future<int> run({int confirmWindowHours = 4, DateTime? now}) async {
    final pending = await dao.pendingEvents();
    final threshold = (now ?? DateTime.now()).subtract(Duration(hours: confirmWindowHours));
    var count = 0;
    for (final e in pending) {
      final planAt = combine(e.planDate, e.planTime);
      if (planAt.isBefore(threshold)) {
        await dao.updateEventStatus(e.id, EventStatus.missed.code);
        count++;
      }
    }
    return count;
  }
}

/// 植物养成：连续“当日全部确认且无漏服”的天数
class PlantService {
  PlantService(this.dao);

  final AppDao dao;

  /// 从 today 往前回溯，计算连续打卡天数
  Future<int> currentStreak({DateTime? today}) async {
    final now = today ?? DateTime.now();
    final events = await dao.eventsInRange(
      ymd(now.subtract(const Duration(days: 365))),
      ymd(now),
    );
    final byDay = <String, List<IntakeEventRow>>{};
    for (final e in events) {
      byDay.putIfAbsent(e.planDate, () => []).add(e);
    }
    var streak = 0;
    for (var i = 0; i < 365; i++) {
      final date = now.subtract(Duration(days: i));
      final dayEvents = byDay[ymd(date)] ?? const <IntakeEventRow>[];
      if (dayEvents.isEmpty) continue; // 无计划日不中断也不计数
      final hasMiss = dayEvents.any((e) => e.status == EventStatus.missed.code);
      if (hasMiss) break;
      final allConfirmed = dayEvents.every((e) => e.status != EventStatus.pending.code);
      if (allConfirmed) {
        streak++;
      } else if (i == 0) {
        continue; // 今天进行中，不中断
      } else {
        break;
      }
    }
    return streak;
  }

  PlantStage stage(int streak) => PlantStage.forStreak(streak);
}

/// 库存：扣减 / 回补 / 低库存判定
class StockService {
  StockService(this.dao);

  final AppDao dao;

  Future<void> deductOnTaken(MedicationRow med, double dose) async {
    if (!med.stockEnabled || med.stockRemaining == null) return;
    await dao.updateStock(med.id, math.max(0, med.stockRemaining! - dose));
  }

  Future<void> restoreOnUndo(MedicationRow med, double dose) async {
    if (!med.stockEnabled || med.stockRemaining == null) return;
    await dao.updateStock(med.id, med.stockRemaining! + dose);
  }

  Future<void> adjust(MedicationRow med, double delta) async {
    if (med.stockRemaining == null) return;
    await dao.updateStock(med.id, math.max(0, med.stockRemaining! + delta));
  }

  /// 预计还能吃几天（按每日总剂量折算）；未启用库存返回 null
  int? remainingDays(MedicationRow med, double dailyDose) {
    if (!med.stockEnabled || med.stockRemaining == null || dailyDose <= 0) return null;
    return (med.stockRemaining! / dailyDose).floor();
  }

  bool isLow(MedicationRow med, double dailyDose) {
    final days = remainingDays(med, dailyDose);
    return days != null && days <= med.lowStockDays;
  }
}

/// 营养汇总：当日 taken 事件 × 成分含量 → 营养素摄入列表
class NutritionService {
  NutritionService(this.dao);

  final AppDao dao;

  Future<List<NutrientIntake>> summarizeDay(
    String planDate, {
    required bool femaleProfile,
  }) async {
    final events = await dao.eventsOn(planDate);
    final taken = events.where((e) => e.status == EventStatus.taken.code).toList();
    if (taken.isEmpty) return const [];

    // 营养素字典
    final nutrients = {for (final n in await dao.allNutrients()) n.code: n};

    // medId → 当日累计服用剂量
    final doseByMed = <String, double>{};
    for (final e in taken) {
      final dose = e.actualDose ?? e.planDose;
      doseByMed[e.medicationId] = (doseByMed[e.medicationId] ?? 0) + dose;
    }

    // medId → 成分
    final ingredientsByMed = <String, List<ProductIngredientRow>>{};
    for (final medId in doseByMed.keys) {
      ingredientsByMed[medId] = await dao.ingredientsForMed(medId);
    }

    // 汇总
    final map = <String, _Acc>{};
    for (final entry in doseByMed.entries) {
      final med = await dao.getMed(entry.key);
      if (med == null) continue;
      for (final ing in ingredientsByMed[entry.key] ?? const <ProductIngredientRow>[]) {
        final acc = map.putIfAbsent(ing.nutrientCode, () => _Acc());
        acc.amount += ing.amountPerUnit * entry.value;
        acc.sources.add(NutrientSource(
          name: med.name,
          emoji: med.emoji,
          amount: ing.amountPerUnit * entry.value,
        ));
      }
    }

    final result = map.entries
        .where((e) => nutrients.containsKey(e.key))
        .map((e) => NutrientIntake(
              nutrient: nutrients[e.key]!,
              amount: _round1(e.value.amount),
              sources: e.value.sources,
            ))
        .toList();

    result.sort((a, b) => _catOrder(a.nutrient.category).compareTo(_catOrder(b.nutrient.category)));
    return result;
  }
}

int _catOrder(String c) {
  switch (c) {
    case 'vitamin':
      return 0;
    case 'mineral':
      return 1;
    case 'fatty_acid':
      return 2;
    default:
      return 3;
  }
}

double _round1(double v) => (v * 10).round() / 10;

class _Acc {
  double amount = 0;
  final List<NutrientSource> sources = [];
}
