import 'package:flutter/material.dart';
import 'package:cyjl/app/app_shell.dart';
import 'package:cyjl/app/theme/app_theme.dart';

class CyjlApp extends StatelessWidget {
  const CyjlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '用药记',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const AppShell(),
    );
  }
}
