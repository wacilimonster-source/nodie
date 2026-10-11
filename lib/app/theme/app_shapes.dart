import 'package:flutter/widgets.dart';

/// 形状语言：24px 大圆角 + 胶囊形（呼应药丸主题）
abstract final class AppShapes {
  static const card = 24.0;
  static const cardSmall = 18.0;
  static const field = 16.0;
  static const inner = 12.0;
  static const pill = 999.0;

  static final cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(card),
  );
  static final pillShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(pill),
  );
  static final fieldShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(field),
  );
}

/// 间距刻度
abstract final class AppSpacing {
  static const xs = 4.0;
  static const s = 8.0;
  static const m = 12.0;
  static const l = 16.0;
  static const xl = 24.0;
}
