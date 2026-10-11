import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/data/repositories/event_repository.dart';
import 'package:cyjl/data/repositories/medication_repository.dart';
import 'package:cyjl/data/repositories/settings_repository.dart';
import 'package:cyjl/domain/plan_slot.dart';
import 'package:cyjl/domain/services.dart';
import 'package:cyjl/notifications/notification_service.dart';

// ==================== 基础设施 ====================

final dbProvider = Provider<AppDatabase>((ref) => AppDatabase.connect());

final daoProvider = Provider<AppDao>((ref) => AppDao(ref.watch(dbProvider)));

final settingsRepoProvider = Provider<SettingsRepository>((ref) => SettingsRepository());

final stockServiceProvider = Provider<StockService>((ref) => StockService(ref.watch(daoProvider)));

final eventGeneratorProvider =
    Provider<EventGenerator>((ref) => EventGenerator(ref.watch(daoProvider)));

final missedMarkerProvider =
    Provider<MissedMarker>((ref) => MissedMarker(ref.watch(daoProvider)));

final plantServiceProvider =
    Provider<PlantService>((ref) => PlantService(ref.watch(daoProvider)));

final nutritionServiceProvider =
    Provider<NutritionService>((ref) => NutritionService(ref.watch(daoProvider)));

final medicationRepoProvider =
    Provider<MedicationRepository>((ref) => MedicationRepository(ref.watch(daoProvider)));

final eventRepoProvider = Provider<EventRepository>(
    (ref) => EventRepository(ref.watch(daoProvider), ref.watch(stockServiceProvider)));

// ==================== 数据流 ====================

final medsProvider = StreamProvider<List<MedicationRow>>(
  (ref) => ref.watch(daoProvider).watchAllMeds(),
);

final schedulesProvider = StreamProvider<List<ScheduleRow>>(
  (ref) => ref.watch(daoProvider).watchAllSchedules(),
);

final ingredientsProvider = StreamProvider<List<ProductIngredientRow>>(
  (ref) => ref.watch(daoProvider).watchIngredients(),
);

final nutrientsProvider = FutureProvider<List<NutrientRow>>(
  (ref) => ref.watch(daoProvider).allNutrients(),
);

final todayKeyProvider = Provider<String>((ref) {
  final d = DateTime.now();
  return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
});

final todayEventsProvider = StreamProvider<List<IntakeEventRow>>(
  (ref) => ref.watch(daoProvider).watchEventsOn(ref.watch(todayKeyProvider)),
);

/// 今日待办 + 药品信息合并视图
class DoseItem {
  const DoseItem({required this.event, required this.med, required this.unit});

  final IntakeEventRow event;
  final MedicationRow med;
  final String unit;

  bool get overdue =>
      event.status == EventStatus.pending.code && _isPast(event.planTime);

  bool _isPast(String planTime) {
    final now = DateTime.now();
    final cur = now.hour * 60 + now.minute;
    final parts = planTime.split(':');
    final at = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    return at < cur;
  }
}

final doseItemsProvider = Provider<AsyncValue<List<DoseItem>>>((ref) {
  final meds = ref.watch(medsProvider);
  final events = ref.watch(todayEventsProvider);
  final schedules = ref.watch(schedulesProvider);
  if (meds.isLoading || events.isLoading) return const AsyncValue.loading();
  if (meds.hasError) return AsyncValue.error(meds.error!, meds.stackTrace ?? StackTrace.current);
  if (events.hasError) {
    return AsyncValue.error(events.error!, events.stackTrace ?? StackTrace.current);
  }
  final medMap = {for (final m in meds.value!) m.id: m};
  final unitMap = {for (final s in schedules.valueOrNull ?? const <ScheduleRow>[]) s.id: s.unit};
  final items = events.value!
      .where((e) => medMap.containsKey(e.medicationId))
      .map((e) => DoseItem(
            event: e,
            med: medMap[e.medicationId]!,
            unit: unitMap[e.scheduleId] ?? '片',
          ))
      .toList();
  items.sort((a, b) => a.event.planTime.compareTo(b.event.planTime));
  return AsyncValue.data(items);
});

/// 日期区间事件（记录页）
class DateRangeKey {
  const DateRangeKey(this.from, this.to);

  final String from;
  final String to;

  @override
  bool operator ==(Object other) =>
      other is DateRangeKey && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);
}

final eventsRangeProvider =
    StreamProvider.family<List<IntakeEventRow>, DateRangeKey>(
  (ref, key) => ref.watch(daoProvider).watchEventsBetween(key.from, key.to),
);

/// 某药的全部计划（详情页）
final medSchedulesProvider =
    Provider.family<AsyncValue<List<ScheduleRow>>, String>((ref, medId) {
  return ref.watch(schedulesProvider).whenData(
        (all) => all.where((s) => s.medicationId == medId).toList(),
      );
});

/// 某药的成分（详情页）
final medIngredientsProvider =
    Provider.family<AsyncValue<List<ProductIngredientRow>>, String>((ref, medId) {
  return ref.watch(ingredientsProvider).whenData(
        (all) => all.where((i) => i.medicationId == medId).toList(),
      );
});

/// 某药的每日剂量（折算库存天数用）
double dailyDoseFor(List<ScheduleRow> schedules) {
  final active = schedules.where((s) => s.isActive).toList();
  if (active.isEmpty) return 1;
  double total = 0;
  for (final s in active) {
    for (final slot in decodeSlots(s.times)) {
      total += slot.dose;
    }
  }
  return total == 0 ? 1 : total;
}

// ==================== 营养汇总 ====================

class NutritionSummary {
  const NutritionSummary({required this.items, required this.femaleProfile});

  final List<NutrientIntake> items;
  final bool femaleProfile;

  int get totalCount => items.length;
  int get reachedCount => items.where((i) => i.reached(femaleProfile)).length;
}

final nutritionSummaryProvider = FutureProvider<NutritionSummary>((ref) async {
  final profile = ref.watch(settingsProvider).profile;
  final date = ref.watch(todayKeyProvider);
  final items = await ref.watch(nutritionServiceProvider).summarizeDay(
        date,
        femaleProfile: profile == ProfileType.female,
      );
  return NutritionSummary(items: items, femaleProfile: profile == ProfileType.female);
});

// ==================== 打卡 streak ====================

final streakProvider = FutureProvider<int>((ref) async {
  final events = ref.watch(todayEventsProvider).valueOrNull;
  if (events == null) return 0;
  return ref.watch(plantServiceProvider).currentStreak();
});

// ==================== 设置 ====================

class SettingsState {
  const SettingsState({
    required this.profile,
    required this.confirmWindowHours,
    required this.snoozeMinutes,
    required this.notificationsEnabled,
  });

  final ProfileType profile;
  final int confirmWindowHours;
  final int snoozeMinutes;
  final bool notificationsEnabled;

  SettingsState copyWith({
    ProfileType? profile,
    int? confirmWindowHours,
    int? snoozeMinutes,
    bool? notificationsEnabled,
  }) =>
      SettingsState(
        profile: profile ?? this.profile,
        confirmWindowHours: confirmWindowHours ?? this.confirmWindowHours,
        snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      );
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController(this._repo) : super(const SettingsState(
        profile: ProfileType.male,
        confirmWindowHours: 4,
        snoozeMinutes: 10,
        notificationsEnabled: true,
      )) {
    _load();
  }

  final SettingsRepository _repo;

  Future<void> _load() async {
    final p = await _repo.profile();
    final w = await _repo.confirmWindowHours();
    final s = await _repo.snoozeMinutes();
    final n = await _repo.notificationsEnabled();
    state = SettingsState(
      profile: p,
      confirmWindowHours: w,
      snoozeMinutes: s,
      notificationsEnabled: n,
    );
  }

  /// 供外部读取当前设置（避免直接访问 StateNotifier.state）
  SettingsState get current => state;

  Future<void> setProfile(ProfileType v) async {
    state = state.copyWith(profile: v);
    await _repo.setProfile(v);
  }

  Future<void> setConfirmWindow(int hours) async {
    state = state.copyWith(confirmWindowHours: hours);
    await _repo.setConfirmWindowHours(hours);
  }

  Future<void> setSnooze(int minutes) async {
    state = state.copyWith(snoozeMinutes: minutes);
    await _repo.setSnoozeMinutes(minutes);
  }

  Future<void> setNotifications(bool v) async {
    state = state.copyWith(notificationsEnabled: v);
    await _repo.setNotificationsEnabled(v);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController(ref.watch(settingsRepoProvider));
});

// ==================== 事件控制器 ====================

class EventController {
  EventController({
    required this.repo,
    required this.dao,
    required this.settings,
  });

  final EventRepository repo;
  final AppDao dao;
  final SettingsController settings;
  int get _snoozeMinutes => settings.current.snoozeMinutes;

  Future<void> markTaken(String eventId) async {
    await repo.markTaken(eventId);
    _reschedule();
  }

  Future<void> skip(String eventId) async {
    await repo.markSkipped(eventId);
    _reschedule();
  }

  Future<void> undo(String eventId) async {
    await repo.undo(eventId);
    _reschedule();
  }

  Future<void> fixMissed(String eventId, {String? note}) async {
    await repo.fixMissed(eventId, note: note);
    _reschedule();
  }

  Future<void> logAsNeeded({
    required String medId,
    required double dose,
    String? note,
  }) async {
    await repo.logAsNeeded(medId: medId, dose: dose, note: note);
  }

  /// 通知 Action 的前台分发（后台走 isolate 版本）
  Future<void> handlePayload(String payload) async {
    final parts = payload.split('|');
    if (parts[0] == 'maintenance') {
      await NotificationService.runMaintenance(dao.attachedDatabase);
      return;
    }
    if (parts.length < 2) return;
    final eventId = parts[1];
    if (parts[0] == 'take') {
      await markTaken(eventId);
      final event = await dao.eventById(eventId);
      if (event != null) {
        final med = await dao.getMed(event.medicationId);
        await NotificationService.gateway.show(
          id: NotificationService.confirmId(eventId),
          title: '✓ 已记录',
          body: med != null ? '${med.emoji} ${med.name} 已记一次，库存已自动扣减' : '已记录，库存已自动扣减',
        );
      }
    } else if (parts[0] == 'snooze') {
      await NotificationService.scheduleSnooze(eventId, _snoozeMinutes);
    }
  }

  void _reschedule() {
    NotificationService.rescheduleAll(dao.attachedDatabase);
  }

  /// 计划/药品变更后：清理失效 pending → 补生成事件 → 漏服判定 → 全量重排通知
  Future<void> refreshPlan() async {
    await EventGenerator(dao).pruneStale();
    await EventGenerator(dao).run();
    await MissedMarker(dao).run(confirmWindowHours: settings.current.confirmWindowHours);
    await NotificationService.rescheduleAll(dao.attachedDatabase);
  }
}

final eventControllerProvider = Provider<EventController>((ref) {
  return EventController(
    repo: ref.watch(eventRepoProvider),
    dao: ref.watch(daoProvider),
    settings: ref.watch(settingsProvider.notifier),
  );
});

// ==================== 启动引导 ====================

/// 冷启动：清理失效 → 补生成事件 → 补漏服 → 全量重排通知 → 每日维护
Future<void> bootstrap(ProviderContainer container) async {
  final generator = container.read(eventGeneratorProvider);
  final marker = container.read(missedMarkerProvider);
  final db = container.read(dbProvider);
  final window = container.read(settingsProvider).confirmWindowHours;
  await generator.pruneStale();
  await generator.run();
  await marker.run(confirmWindowHours: window);
  await NotificationService.rescheduleAll(db);
  await NotificationService.scheduleDailyMaintenance();
}
