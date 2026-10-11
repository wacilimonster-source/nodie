import 'package:flutter/material.dart';
import 'package:cyjl/app/theme/app_colors.dart';

/// 字阶：标题重、正文清晰、数据用等宽数字
abstract final class AppText {
  static const _base = 'PingFang SC';

  static TextStyle get heroTitle => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: AppColors.ink,
        letterSpacing: .3,
      );

  static TextStyle get pageTitle => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: AppColors.ink,
        letterSpacing: .5,
      );

  static TextStyle get cardTitle => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      );

  static TextStyle get body => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      );

  static TextStyle get bodyStrong => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      );

  static TextStyle get sub => const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        color: AppColors.sub,
      );

  static TextStyle get caption => const TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        color: AppColors.sub,
      );

  static TextStyle get bigNumber => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: AppColors.priDark,
      );

  static TextStyle get section => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppColors.sub,
        letterSpacing: 1,
      );

  /// 数字等宽（营养条数值）
  static TextStyle get numeric => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: AppColors.ink,
        fontFeatures: [FontFeature.tabularFigures()],
        fontFamily: _base,
      );
}
