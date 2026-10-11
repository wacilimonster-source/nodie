import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// 通知网关：把「平台通道调用」抽象出来，便于：
/// 1) 单元/验收测试注入 Fake，断言"为哪些事件、什么时间、什么 payload 注册了通知"
/// 2) 未来替换实现（如换通知库）不影响业务逻辑
abstract interface class DoseGateway {
  Future<void> init({
    required void Function(String payload) onForeground,
    required void Function(String payload) onBackground,
  });

  Future<bool> requestPermission();

  /// 计划一条通知（到点触发）
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
    required String payload,
    bool withActions = false,
    bool silent = false,
    bool daily = false,
  });

  /// 立即展示一条通知（如"已记录 ✓"确认）
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String thread = 'dose-confirm',
  });

  Future<void> cancel(int id);
}

// ==================== 真实实现（flutter_local_notifications） ====================

const AndroidNotificationChannel _doseChannel = AndroidNotificationChannel(
  'dose_v1',
  '服药提醒',
  description: '计划到点提醒与快捷确认',
  importance: Importance.high,
  playSound: true,
);

const AndroidNotificationChannel _maintenanceChannel = AndroidNotificationChannel(
  'maintenance_v1',
  '系统维护',
  description: '后台补生成事件与漏服判定',
  importance: Importance.min,
  playSound: false,
);

final DarwinNotificationCategory _doseCategory = DarwinNotificationCategory(
  'dose',
  actions: <DarwinNotificationAction>[
    DarwinNotificationAction.plain('take', '✓ 已服用'),
    DarwinNotificationAction.plain('snooze', '💤 稍后'),
  ],
);

const DarwinNotificationCategory _maintenanceCategory =
    DarwinNotificationCategory('maintenance', actions: <DarwinNotificationAction>[]);

class FlutterDoseGateway implements DoseGateway {
  FlutterDoseGateway();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  @override
  Future<void> init({
    required void Function(String payload) onForeground,
    required void Function(String payload) onBackground,
  }) async {
    await _plugin.initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          notificationCategories: [_doseCategory, _maintenanceCategory],
        ),
      ),
      onDidReceiveNotificationResponse: (r) {
        final p = r.payload;
        if (p != null && p.isNotEmpty) onForeground(p);
      },
      onDidReceiveBackgroundNotificationResponse: (r) {
        final p = r.payload;
        if (p != null && p.isNotEmpty) onBackground(p);
      },
    );
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_doseChannel);
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_maintenanceChannel);
  }

  @override
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) return await android.requestNotificationsPermission() ?? false;
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) return await ios.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    return false;
  }

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
    final channel = silent ? _maintenanceChannel : _doseChannel;
    final actions = withActions
        ? const <AndroidNotificationAction>[
            AndroidNotificationAction('take', '✓ 已服用', showsUserInterface: false, cancelNotification: true),
            AndroidNotificationAction('snooze', '💤 稍后', showsUserInterface: false, cancelNotification: true),
          ]
        : null;
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: silent ? Importance.min : Importance.high,
          priority: silent ? Priority.min : Priority.high,
          silent: silent,
          category: silent ? null : AndroidNotificationCategory.reminder,
          actions: actions,
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: withActions ? 'dose' : 'maintenance',
          presentSound: !silent,
        ),
      ),
      payload: payload,
      androidScheduleMode:
          silent ? AndroidScheduleMode.inexactAllowWhileIdle : AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: daily ? DateTimeComponents.time : null,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String thread = 'dose-confirm',
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _maintenanceChannel.id,
          _maintenanceChannel.name,
          channelDescription: _maintenanceChannel.description,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(threadIdentifier: thread),
      ),
    );
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id);
}
