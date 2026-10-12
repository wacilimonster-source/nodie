import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/data/repositories/event_repository.dart';
import 'package:cyjl/data/repositories/medication_repository.dart';
import 'package:cyjl/domain/plan_slot.dart';
import 'package:cyjl/domain/services.dart';
import 'package:cyjl/notifications/notification_service.dart';
import 'package:cyjl/notifications/notifier.dart';

/// ============================================================
/// 真机验收的「逻辑层模拟」：
/// 用 Fake 通知网关替代 flutter_local_notifications，断言真实业务编排结果。
/// 真机才能验证的部分（通知真实弹出/权限/ROM 保活）见文末说明与 AGENTS.md。
/// ============================================================

class SchedCall {
  SchedCall({required this.id, required this.payload, required this.when, required this.withActions});

  final int id;
  final String payload;
  final DateTime when;
  final bool withActions;
}

class FakeGateway implements DoseGateway {
  final List<SchedCall> scheduled = [];
  final List<int> cancelled = [];
  final List<int> shown = [];

  @override
  Future<void> init({
    required void Function(String payload) onForeground,
  }) async {}

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
    required String payload,
    bool withActions = false,
    bool silent = false,
    bool daily = false,
  }) async {
    scheduled.add(SchedCall(id: id, payload: payload, when: when, withActions: withActions));
  }

  @override
  Future<void> show({required int id, required String title, required String body, String thread = ''}) async {
    shown.add(id);
  }

  @override
  Future<void> cancel(int id) async => cancelled.add(id);

  List<SchedCall> get doseCalls => scheduled.where((c) => c.payload.startsWith('take|')).toList();
  void reset() {
    scheduled.clear();
    cancelled.clear();
    shown.clear();
  }
}

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

void main() {
  late AppDatabase db;
  late AppDao dao;
  late FakeGateway fake;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dao = AppDao(db);
    fake = FakeGateway();
    NotificationService.gateway = fake;
  });

  tearDown(() async {
    NotificationService.gateway = FlutterDoseGateway();
    await db.close();
  });

  Future<String> createMed({
    bool active = true,
    bool stockEnabled = false,
    double? stock,
    List<IngredientDraft> ingredients = const [],
  }) async {
    final id = await MedicationRepository(dao).create(MedDraft(
      name: '维生素D3',
      type: MedType.supplement,
      form: '软胶囊',
      color: '#3B82F6',
      emoji: '🌞',
      stockEnabled: stockEnabled,
      stock: stock,
      freq: FreqType.daily,
      slots: const [PlanSlot(time: '08:00', dose: 1, unit: '粒')],
      unit: '粒',
      startDate: DateTime(2026, 1, 1),
      ingredients: ingredients,
    ));
    if (!active) await MedicationRepository(dao).setActive(id, false);
    return id;
  }

  Future<String> insertPending(String medId, DateTime date, String time) async {
    final id = 'ev-${date.millisecondsSinceEpoch}-$time';
    await dao.insertEvents([
      IntakeEventsCompanion.insert(
        id: id,
        medicationId: medId,
        scheduleId: 'sch-1',
        planDate: _ymd(date),
        planTime: time,
        planDose: 1,
        status: EventStatus.pending.code,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ]);
    return id;
  }

  // ============================================================
  // 验收项 1 / 3：通知调度与重启恢复（逻辑层）
  // ============================================================
  group('验收1/3 · 到点注册通知 & 重启后按 pending 恢复', () {
    test('为未来 pending 事件注册通知，为已确认事件取消、为暂停药跳过', () async {
      final activeMed = await createMed();
      final pausedMed = await createMed(active: false);
      final tomorrow = DateTime.now().add(const Duration(days: 1));

      await insertPending(activeMed, tomorrow, '23:30'); // 会被注册
      await insertPending(pausedMed, tomorrow, '23:40'); // 暂停 → 取消
      // 已确认事件（明天，已服用）→ 应取消、不注册
      const takenId = 'ev-taken';
      await dao.insertEvents([
        IntakeEventsCompanion.insert(
          id: takenId,
          medicationId: activeMed,
          scheduleId: 'sch-1',
          planDate: _ymd(tomorrow),
          planTime: '23:50',
          planDose: 1,
          status: EventStatus.taken.code,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ]);

      await NotificationService.rescheduleAll(db);

      expect(fake.doseCalls.length, 1, reason: '只有 active 药的未来 pending 才注册');
      expect(fake.doseCalls.single.payload, startsWith('take|'));
      // 已确认事件被取消
      expect(fake.cancelled.any((id) => id == takenId.hashCode & 0x0FFFFFFF), isTrue);
      // 维护任务被排期（每日 00:10）
      expect(fake.scheduled.any((c) => c.payload == 'maintenance'), isTrue);
    });
  });

  // ============================================================
  // 验收项 1：点通知【已服用】→ 事件已服 + 库存扣减 + 不再提醒
  // ============================================================
  group('验收1 · 通知【已服用】闭环', () {
    test('确认后：状态=taken、库存-1、该事件不再注册通知', () async {
      final med = await createMed(stockEnabled: true, stock: 30);
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final evId = await insertPending(med, tomorrow, '23:30');

      final repo = EventRepository(dao, StockService(dao));
      await repo.markTaken(evId); // 等价于后台 Action 的核心落库
      await NotificationService.cancelForEvent(evId); // Action 中会取消该通知

      final e = (await dao.eventById(evId))!;
      expect(e.status, EventStatus.taken.code);
      expect(e.actualAt, isNotNull);
      expect((await dao.getMed(med))!.stockRemaining, 29); // 库存扣减
      expect(fake.cancelled.contains(NotificationService.confirmId(evId) - 500000), isTrue);

      // 再次重排：该事件不再是 pending → 不应被注册
      fake.reset();
      await NotificationService.rescheduleAll(db);
      expect(fake.doseCalls.any((c) => c.payload == 'take|$evId'), isFalse);
    });
  });

  // ============================================================
  // 验收项 2：点【稍后】→ 10 分钟后重发
  // ============================================================
  group('验收2 · 稍后提醒', () {
    test('snooze 注册一条 ~now+10min 的通知（同 payload）', () async {
      final med = await createMed();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final evId = await insertPending(med, tomorrow, '23:30');

      final before = DateTime.now();
      await NotificationService.scheduleSnooze(evId, 10);

      final call = fake.doseCalls.single;
      expect(call.payload, 'take|$evId');
      final delta = call.when.difference(before).inMinutes;
      expect(delta, inInclusiveRange(9, 11));
    });
  });

  // ============================================================
  // 验收项（一致性）：编辑/暂停后，失效的未来 pending 被清理，不再误报
  // ============================================================
  group('一致性 · pruneStale 清理失效 pending', () {
    test('暂停药品后，其未来 pending 事件被清理，历史保留', () async {
      final med = await createMed();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final future = await insertPending(med, tomorrow, '23:30');
      final past = await insertPending(med, yesterday, '08:00');

      await MedicationRepository(dao).setActive(med, false);
      final removed = await EventGenerator(dao).pruneStale();

      expect(removed, 1);
      expect(await dao.eventById(future), isNull);
      expect(await dao.eventById(past), isNotNull, reason: '历史事件保留');
    });
  });

  // ============================================================
  // 验收项 6：新增保健品 → 生成计划事件 → 确认 → 营养摄入增长
  // ============================================================
  group('验收6 · 新增保健品→确认→营养增长', () {
    test('创建含成分保健品并经事件生成 + 确认后，营养汇总增加且库存扣减', () async {
      // 1. 新增保健品（含维生素D 25μg/粒）
      final med = await MedicationRepository(dao).create(MedDraft(
        name: '维生素D3',
        type: MedType.supplement,
        form: '软胶囊',
        color: '#3B82F6',
        emoji: '🌞',
        stockEnabled: true,
        stock: 60,
        freq: FreqType.daily,
        slots: const [PlanSlot(time: '08:00', dose: 1, unit: '粒')],
        unit: '粒',
        startDate: DateTime(2026, 1, 1),
        ingredients: const [IngredientDraft(nutrientCode: 'vd', amountPerUnit: 25)],
      ));

      // 2. 生成计划事件（模拟明日到点）
      final future = DateTime(2030, 1, 1, 6, 0);
      await EventGenerator(dao).run(daysAhead: 1, now: future);
      final tomorrow = _ymd(DateTime(2030, 1, 1));
      final events = await dao.eventsOn(tomorrow);
      expect(events.length, 1);

      // 3. 确认服用
      final today = DateTime.now();
      final summaryBefore =
          await NutritionService(dao).summarizeDay(_ymd(today), femaleProfile: false);
      expect(summaryBefore, isEmpty);

      await EventRepository(dao, StockService(dao)).markTaken(events.single.id);

      // 4. 摄入增长（用事件所在日期汇总）
      final summary =
          await NutritionService(dao).summarizeDay(tomorrow, femaleProfile: false);
      final vd = summary.firstWhere((i) => i.nutrient.code == 'vd');
      expect(vd.amount, 25);
      expect(vd.reached(false), isTrue); // 25 ≥ RNI 10
      expect((await dao.getMed(med))!.stockRemaining, 59);
    });
  });
}
