import 'package:flutter/material.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/app/theme/app_shapes.dart';

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.pri,
    primary: AppColors.pri,
    secondary: AppColors.acc,
    surface: AppColors.card,
    error: AppColors.bad,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    canvasColor: AppColors.bg,
    dividerColor: AppColors.line,
    splashColor: AppColors.priLight,
    highlightColor: AppColors.priLight.withOpacity(0.3),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      foregroundColor: AppColors.ink,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: AppColors.ink,
        letterSpacing: .5,
      ),
    ),
    cardTheme: const CardTheme(
      color: AppColors.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppShapes.card)),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppShapes.card)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        color: AppColors.card,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppShapes.pill)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppShapes.field)),
        borderSide: BorderSide(color: AppColors.line, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppShapes.field)),
        borderSide: BorderSide(color: AppColors.line, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppShapes.field)),
        borderSide: BorderSide(color: AppColors.pri, width: 2),
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: AppColors.ink,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      bodySmall: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        color: AppColors.sub,
      ),
      labelSmall: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: AppColors.sub,
      ),
    ),
  );
}
