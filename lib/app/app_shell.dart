import 'package:flutter/material.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/features/cabinet/cabinet_screen.dart';
import 'package:cyjl/features/history/history_screen.dart';
import 'package:cyjl/features/nutrition/nutrition_screen.dart';
import 'package:cyjl/features/settings/settings_screen.dart';
import 'package:cyjl/features/today/today_screen.dart';
import 'package:cyjl/shared/widgets/capsule_nav.dart';

/// 根导航：IndexedStack（保持各页状态）+ 悬浮胶囊 Tab
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _pages = [
    TodayScreen(),
    NutritionScreen(),
    HistoryScreen(),
    CabinetScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _index, children: _pages),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: CapsuleNav(
            index: _index,
            onChanged: (i) => setState(() => _index = i),
          ),
        ),
      ),
    );
  }
}
