import 'package:intl/intl.dart';

/// 日期键 yyyy-MM-dd，全部本地时区
final DateFormat _fmt = DateFormat('yyyy-MM-dd');

String ymd(DateTime d) => _fmt.format(d);

DateTime parseYmd(String s) => _fmt.parse(s);

String todayYmd() => _fmt.format(DateTime.now());

/// 目标日期是否命中该频率规则
bool matchesSchedule({
  required String freqType,
  required String? weekdaysJson,
  required int? intervalDays,
  required int? cycleOn,
  required int? cycleOff,
  required DateTime startDate,
  required DateTime target,
}) {
  final start = DateTime(startDate.year, startDate.month, startDate.day);
  final date = DateTime(target.year, target.month, target.day);
  final diffDays = date.difference(start).inDays;
  if (diffDays < 0) return false;

  switch (freqType) {
    case 'daily':
      return true;
    case 'weekly':
      final days = parseWeekdays(weekdaysJson);
      return days.contains(date.weekday); // 1=周一
    case 'every_n_days':
      if (intervalDays == null || intervalDays < 2) return true;
      return diffDays % intervalDays == 0;
    case 'cycle':
      final on = cycleOn ?? 1, off = cycleOff ?? 1;
      if (on <= 0) return false;
      return diffDays % (on + off) < on;
    case 'as_needed':
      return false;
    default:
      return false;
  }
}

List<int> parseWeekdays(String? json) {
  if (json == null || json.trim().isEmpty) return const [];
  final cleaned = json.replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '');
  if (cleaned.isEmpty) return const [];
  return cleaned.split(',').map(int.tryParse).whereType<int>().toList();
}

String encodeWeekdays(List<int> days) => '[${days.join(',')}]';

/// 合并日期与 HH:mm 为完整 DateTime
DateTime combine(String planDate, String planTime) {
  final d = parseYmd(planDate);
  final parts = planTime.split(':');
  return DateTime(d.year, d.month, d.day, int.parse(parts[0]), int.parse(parts[1]));
}

/// HH:mm 比较
bool timeGreater(String a, String b) => a.compareTo(b) > 0;

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
