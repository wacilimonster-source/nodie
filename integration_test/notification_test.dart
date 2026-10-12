import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cyjl/main.dart' as app;
import 'package:cyjl/notifications/notification_service.dart';

/// 设备端通知能力验证：
/// 直接经可注入网关调度一条通知，再用插件的 pendingNotificationRequests() 确认
/// 平台侧确实登记了它（同时验证 Android 12+ 精确闹钟无权限时的 inexact 回退不会抛异常）。
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('设备端可调度通知', (tester) async {
    await app.main();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));

    await NotificationService.ensureTz();
    await NotificationService.gateway.schedule(
      id: 424242,
      title: '测试提醒',
      body: 'device schedule test',
      when: DateTime.now().add(const Duration(minutes: 3)),
      payload: 'take|test',
      withActions: true,
    );

    // 稍等平台调用完成
    await tester.pump(const Duration(seconds: 1));

    final pending = await FlutterLocalNotificationsPlugin().pendingNotificationRequests();
    expect(
      pending.any((p) => p.id == 424242),
      isTrue,
      reason: '调度后应存在待触发通知，实际 id 列表: ${pending.map((e) => e.id).toList()}',
    );
  });
}
