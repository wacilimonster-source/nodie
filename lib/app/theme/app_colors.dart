import 'package:flutter/material.dart';

/// 自然活力（Natural Vitality）设计令牌
/// 奶油大地色 · 苔藓绿 · 陶土橙 · 蜂蜜黄
abstract final class AppColors {
  // 背景与卡片
  static const bg = Color(0xFFF6F1E7); // 奶油
  static const card = Color(0xFFFFFDF8); // 暖白卡片
  static const bg2 = Color(0xFFEFE7D8); // 深奶油（次级容器）
  static const line = Color(0xFFE7DFD0); // 暖分割线

  // 文字
  static const ink = Color(0xFF3E3A33); // 深棕墨
  static const sub = Color(0xFF8A8378); // 暖灰

  // 主色：苔藓绿
  static const pri = Color(0xFF5F8D4E);
  static const priDark = Color(0xFF4C7340);
  static const priLight = Color(0xFFE4EEDA);
  static const priGradTop = Color(0xFF7BA96A);

  // 强调：陶土橙
  static const acc = Color(0xFFE07A5F);
  static const accLight = Color(0xFFFBEAE3);

  // 点缀：蜂蜜黄
  static const honey = Color(0xFFF2CC8F);
  static const honeyDark = Color(0xFFDDA54F);

  // 警示：暖红
  static const bad = Color(0xFFD4654F);
  static const badLight = Color(0xFFF9E4DF);

  // 已完成/中性
  static const doneTag = Color(0xFFE3F0DA);
  static const doneInk = Color(0xFF3F6B33);
  static const muted = Color(0xFFC9C0AE);

  // 药品色板（列表颜色识别）
  static const palette = <Color>[
    Color(0xFFE07A5F), // 陶土橙
    Color(0xFFDDA54F), // 蜂蜜
    Color(0xFFF2CC8F), // 浅蜜
    Color(0xFF5F8D4E), // 苔藓绿
    Color(0xFF7BA96A), // 浅苔绿
    Color(0xFF8CB4C9), // 雾蓝
    Color(0xFF9B8CB8), // 薰衣草
    Color(0xFFE8A0B4), // 粉绒
  ];

  /// 状态条/分类用的语义色（依从率等）
  static Color adherence(int percent) {
    if (percent >= 90) return pri;
    if (percent >= 80) return honeyDark;
    return bad;
  }

  /// '#RRGGBB' → Color（非法值回落主色）
  static Color fromHex(String hex) {
    var h = hex.replaceAll('#', '').trim();
    if (h.length == 6) h = 'FF$h';
    final v = int.tryParse(h, radix: 16);
    return v == null ? pri : Color(v);
  }
}
