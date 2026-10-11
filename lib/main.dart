import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyjl/app/app.dart';
import 'package:cyjl/app/providers.dart';
import 'package:cyjl/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  await NotificationService.init(
    actionHandler: (payload) async {
      await container.read(eventControllerProvider).handlePayload(payload);
    },
  );

  // 冷启动：补生成事件 → 补漏服 → 全量重排通知 → 每日维护
  await bootstrap(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CyjlApp(),
    ),
  );
}
