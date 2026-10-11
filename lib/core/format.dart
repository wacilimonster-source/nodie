import 'package:intl/intl.dart';

/// 数值格式化：整数去掉小数点，分数保留一位
String fmtNum(double v) {
  if (v == v.roundToDouble()) return v.toInt().toString();
  return (v * 10).roundToDouble() / 10 == v ? v.toStringAsFixed(1) : v.toString();
}

String fmtPercent(int percent) => '$percent%';

/// 服药记录时间 HH:mm
String fmtHM(DateTime dt) => DateFormat('HH:mm').format(dt);

String fmtDuration(int minutes) {
  if (minutes < 60) return '$minutes 分钟';
  if (minutes < 60 * 24) return '${(minutes / 60).round()} 小时';
  return '${(minutes / (60 * 24)).round()} 天';
}

/// 库存天数 → 文案
String stockDaysText(int days) {
  if (days <= 0) return '已用完';
  if (days == 1) return '约 1 天';
  return '约 $days 天';
}
