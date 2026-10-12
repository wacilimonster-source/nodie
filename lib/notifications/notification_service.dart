import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdb;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/data/repositories/event_repository.dart';
import 'package:cyjl/domain/services.dart';
import 'package:cyjl/notifications/notifier.dart';

/// 本地通知服务（业务编排层）
/// 平台调用全部委托给可注入的 [DoseGateway]，便于测试注入 Fake 断言调度行为。
/// - 到点单次提醒 + Action（已服用 / 稍后）
/// - 后台 Action 落库（含库存扣减）后发确认通知
/// - 每日 00:10 维护任务：补生成 + 漏服判定 + 全量重排
class NotificationService {
  NotificationService._();

  /// 可替换实现（测试注入 Fake）
  static DoseGateway gateway = FlutterDoseGateway();

  static void Function(String payload)? _actionHandler;
  static bool _tzReady = false;

  static const _maintenanceId = 999999;
  static const _maintenancePayload = 'maintenance';

  static Future<void> ensureTz() async {
    if (_tzReady) return;
    tzdb.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Shanghai'));
    }
    _tzReady = true;
  }

  static Future<void> init({
    required void Function(String payload) actionHandler,
  }) async {
    _actionHandler = actionHandler;
    await ensureTz();
    await gateway.init(
      onForeground: (p) => _actionHandler?.call(p),
    );
  }

  static Future<bool> requestPermission() => gateway.requestPermission();

  /// 稳定的通知 id（空库冷启动也稳定）
  static int _eventNotifId(String eventId) => eventId.hashCode & 0x0FFFFFFF;

  /// 确认通知 id（与剂量通知错开）
  static int confirmId(String eventId) => _eventNotifId(eventId) + 500000;

  static Future<void> scheduleForEvent(
    IntakeEventRow event, {
    required String medName,
    required String medEmoji,
    required String instruction,
    required String unit,
  }) async {
    if (event.status != 'pending') return;
    final planAt = tz.TZDateTime.from(combineAt(event.planDate, event.planTime), tz.local);
    if (planAt.isBefore(tz.TZDateTime.now(tz.local))) return;

    final doseText = '${_num(event.planDose)}$unit';
    final body = instruction.isEmpty ? doseText : '$doseText · $instruction';
    await gateway.schedule(
      id: _eventNotifId(event.id),
      title: '$medEmoji 该吃「$medName」了',
      body: body,
      when: planAt,
      payload: 'take|${event.id}',
      withActions: true,
    );
  }

  static Future<void> scheduleSnooze(String eventId, int minutes) async {
    await ensureTz();
    final when = tz.TZDateTime.now(tz.local).add(Duration(minutes: minutes));
    await gateway.schedule(
      id: _eventNotifId(eventId),
      title: '💤 稍后提醒',
      body: '该吃药了，别忘记',
      when: when,
      payload: 'take|$eventId',
      withActions: true,
    );
  }

  static Future<void> cancelForEvent(String eventId) => gateway.cancel(_eventNotifId(eventId));

  /// 每日 00:10 维护任务（补生成/漏服/重排）——App 不开也能自我修复
  static Future<void> scheduleDailyMaintenance() async {
    await ensureTz();
    final now = tz.TZDateTime.now(tz.local);
    var at = tz.TZDateTime(tz.local, now.year, now.month, now.day, 0, 10);
    if (at.isBefore(now)) at = at.add(const Duration(days: 1));
    await gateway.schedule(
      id: _maintenanceId,
      title: '维护任务',
      body: '维护任务',
      when: at,
      payload: _maintenancePayload,
      silent: true,
      daily: true,
    );
  }

  /// 全量重排：[today, today+6] 的 pending 事件注册，非 pending 的残留取消
  static Future<void> rescheduleAll(AppDatabase db) async {
    await ensureTz();
    final dao = AppDao(db);
    final now = DateTime.now();
    final from = ymdOf(now);
    final to = ymdOf(now.add(const Duration(days: 7)));
    final events = await dao.eventsInRange(from, to);
    final meds = {for (final m in await dao.getAllMeds()) m.id: m};
    final schedules = {for (final s in await dao.allSchedules()) s.id: s};

    for (final e in events) {
      if (e.status != 'pending') await gateway.cancel(_eventNotifId(e.id));
    }
    for (final e in events.where((e) => e.status == 'pending')) {
      final med = meds[e.medicationId];
      if (med == null || !med.isActive) {
        await gateway.cancel(_eventNotifId(e.id));
        continue;
      }
      await scheduleForEvent(
        e,
        medName: med.name,
        medEmoji: med.emoji,
        instruction: med.instruction ?? '',
        unit: schedules[e.scheduleId]?.unit ?? _unitOf(med),
      );
    }
    await scheduleDailyMaintenance();
  }

  static String _unitOf(MedicationRow med) => med.form.contains('液') ? 'ml' : '片';

  static String ymdOf(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// 维护任务：补生成事件 + 漏服判定 + 重排通知
  static Future<void> runMaintenance(AppDatabase db) async {
    final dao = AppDao(db);
    await EventGenerator(dao).pruneStale();
    await EventGenerator(dao).run();
    await MissedMarker(dao).run();
    await rescheduleAll(db);
  }

  /// 后台 Action 入口（由顶层 `notificationBackgroundResponse` 调用）。
  /// 在独立 isolate 中自建数据库连接，不依赖主 isolate 状态。
  static Future<void> handleBackgroundAction(String payload) async {
    try {
      await _handleAction(payload);
    } catch (_) {
      // 后台失败静默：App 下次打开时 EventGenerator 兜底
    }
  }

  static Future<void> _handleAction(String payload) async {
    await ensureTz();
    final parts = payload.split('|');
    final kind = parts[0];

    if (kind == 'maintenance') {
      final db = AppDatabase.connect();
      try {
        await runMaintenance(db);
      } finally {
        await db.close();
      }
      return;
    }

    final eventId = parts.length > 1 ? parts[1] : null;
    if (eventId == null) return;

    final db = AppDatabase.connect();
    try {
      final dao = AppDao(db);
      final repo = EventRepository(dao, StockService(dao));
      if (kind == 'take') {
        await repo.markTaken(eventId);
        await cancelForEvent(eventId);
        final event = await dao.eventById(eventId);
        final med = event == null ? null : await dao.getMed(event.medicationId);
        await gateway.show(
          id: confirmId(eventId),
          title: '✓ 已记录',
          body: med != null ? '${med.emoji} ${med.name} 已记一次，库存已自动扣减' : '已记录，库存已自动扣减',
        );
      } else if (kind == 'snooze') {
        await cancelForEvent(eventId);
        await scheduleSnooze(eventId, 10);
      }
    } finally {
      await db.close();
    }
  }

  static DateTime combineAt(String planDate, String planTime) {
    final d = DateTime.parse(planDate);
    final parts = planTime.split(':');
    return DateTime(d.year, d.month, d.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  static String _num(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
