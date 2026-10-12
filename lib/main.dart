import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyjl/app/app.dart';
import 'package:cyjl/app/providers.dart';
import 'package:cyjl/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  // 通知初始化与启动引导都容错：任何失败都不得阻塞 UI 渲染（否则会黑屏）
  try {
    await NotificationService.init(
      actionHandler: (payload) async {
        await container.read(eventControllerProvider).handlePayload(payload);
      },
    );
  } catch (e, st) {
    debugPrint('NotificationService.init failed: $e\n$st');
  }

  // 冷启动：清理失效 → 补生成事件 → 补漏服 → 全量重排通知 → 每日维护
  try {
    await bootstrap(container);
  } catch (e, st) {
    debugPrint('bootstrap failed: $e\n$st');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CyjlApp(),
    ),
  );
}
