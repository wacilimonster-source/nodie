import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyjl/app/providers.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/core/date_utils.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/shared/widgets/page_scaffold.dart';
import 'package:cyjl/shared/widgets/section_title.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month, 1);
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final first = DateTime(_month.year, _month.month, 1);
    final last = DateTime(_month.year, _month.month + 1, 0);
    final monthEventsAsync =
        ref.watch(eventsRangeProvider(DateRangeKey(ymd(first), ymd(last))));
    final statsFrom = today.subtract(const Duration(days: 29));
    final statsEventsAsync =
        ref.watch(eventsRangeProvider(DateRangeKey(ymd(statsFrom), ymd(today))));
    final meds = ref.watch(medsProvider).valueOrNull ?? const <MedicationRow>[];
    final medById = {for (final m in meds) m.id: m};

    final monthEvents = monthEventsAsync.valueOrNull ?? const <IntakeEventRow>[];
    final statsEvents = statsEventsAsync.valueOrNull ?? const <IntakeEventRow>[];
    final byDate = <String, List<IntakeEventRow>>{};
    for (final e in monthEvents) {
      byDate.putIfAbsent(e.planDate, () => []).add(e);
    }

    final selectedKey = _selected ?? ymd(today);
    final selDate = parseYmd(selectedKey);
    final selectedEvents = byDate[selectedKey] ?? const <IntakeEventRow>[];

    final stats7 = statsEvents.where((e) => _withinDays(e, today, 7)).toList();
    final ad7 = _adherence(stats7);
    final ad30 = _adherence(statsEvents);

    return PageScaffold(
      title: '记录',
      subtitle: '${_month.year}年${_month.month}月',
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _calendar(byDate, today, selectedKey),
          const SectionTitle('当日明细'),
          _dayDetail(selectedEvents, selDate, today, medById),
          const SizedBox(height: 12),
          _statCards(ad7, ad30),
          const SectionTitle('按药品依从率（近30天）'),
          ..._adherenceBars(statsEvents, medById),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  // ============ 日历 ============
  Widget _calendar(
    Map<String, List<IntakeEventRow>> byDate,
    DateTime today,
    String selectedKey,
  ) {
    final firstWeekday = DateTime(_month.year, _month.month, 1).weekday; // 1..7
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final offset = firstWeekday - 1; // 周一开头

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      padding: const EdgeInsets.fromLTRB(13, 15, 13, 13),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x125D5040), blurRadius: 14, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _monthNav('‹', () => setState(() {
                    _month = DateTime(_month.year, _month.month - 1, 1);
                  })),
              const Spacer(),
              Text(
                '${_month.year}年${_month.month}月',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              _monthNav('›', () => setState(() {
                    _month = DateTime(_month.year, _month.month + 1, 1);
                  })),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final w in const ['一', '二', '三', '四', '五', '六', '日'])
                Expanded(
                  child: Center(
                    child: Text(
                      w,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.sub,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 40,
            ),
            itemCount: offset + daysInMonth,
            itemBuilder: (context, i) {
              if (i < offset) return const SizedBox.shrink();
              final day = i - offset + 1;
              final date = DateTime(_month.year, _month.month, day);
              final key = ymd(date);
              final isToday = isSameDay(date, today);
              final isSel = key == selectedKey;
              final status = _dayStatus(byDate[key] ?? const [], date, today);
              final dotColor = _statusColor(status);

              return GestureDetector(
                onTap: () => setState(() => _selected = key),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isToday ? AppColors.pri : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: isSel && !isToday
                        ? Border.all(color: AppColors.pri, width: 2)
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isToday ? FontWeight.w900 : FontWeight.w600,
                          color: isToday
                              ? Colors.white
                              : (date.isAfter(today) ? AppColors.muted : AppColors.ink),
                        ),
                      ),
                      if (dotColor != null && !isToday)
                        Positioned(
                          bottom: 4,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(AppColors.pri, '完成'),
              const SizedBox(width: 12),
              _legendDot(AppColors.honeyDark, '有跳过'),
              const SizedBox(width: 12),
              _legendDot(AppColors.bad, '有漏服'),
              const SizedBox(width: 12),
              _legendDot(AppColors.muted, '无计划'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _monthNav(String label, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(color: Color(0xFFF0EADC), shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.sub),
          ),
        ),
      );

  Widget _legendDot(Color c, String text) => Row(
        children: [
          Container(width: 7, height: 7, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 3),
          Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.sub)),
        ],
      );

  // ============ 当日明细 ============
  Widget _dayDetail(
    List<IntakeEventRow> events,
    DateTime date,
    DateTime today,
    Map<String, MedicationRow> medById,
  ) {
    if (events.isEmpty) {
      return _box(
        const Text(
          '当日无记录',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.sub),
        ),
      );
    }
    final sorted = [...events]..sort((a, b) => a.planTime.compareTo(b.planTime));
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x125D5040), blurRadius: 14, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < sorted.length; i++)
            _detailRow(sorted[i], medById[sorted[i].medicationId], i == 0, date, today),
        ],
      ),
    );
  }

  Widget _detailRow(
    IntakeEventRow e,
    MedicationRow? med,
    bool first,
    DateTime date,
    DateTime today,
  ) {
    final status = EventStatus.fromCode(e.status);
    final canFix = (status == EventStatus.missed || status == EventStatus.pending) &&
        !date.isAfter(today);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        border: first
            ? null
            : const Border(top: BorderSide(color: Color(0xFFF3EDE0), width: 1.5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: Text(
              e.planTime,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.sub),
            ),
          ),
          Expanded(
            child: Text(
              '${med?.emoji ?? '💊'} ${med?.name ?? '未知'}\u2002${_num(e.planDose)}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink),
            ),
          ),
          _statusChip(status),
          if (canFix) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => ref.read(eventControllerProvider).fixMissed(e.id),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.pri, width: 1.5),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '补记',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.pri),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusChip(EventStatus status) {
    late Color bg;
    late Color fg;
    switch (status) {
      case EventStatus.taken:
        bg = AppColors.doneTag;
        fg = AppColors.doneInk;
        break;
      case EventStatus.skipped:
        bg = const Color(0xFFFBF0DA);
        fg = const Color(0xFFA0742A);
        break;
      case EventStatus.missed:
        bg = AppColors.badLight;
        fg = AppColors.bad;
        break;
      case EventStatus.pending:
        bg = const Color(0xFFEFE9DB);
        fg = AppColors.sub;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }

  Widget _box(Widget child) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
        ),
        child: child,
      );

  // ============ 统计 ============
  Widget _statCards(int? ad7, int? ad30) {
    final streak = ref.watch(streakProvider).valueOrNull ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _statCard(ad7 == null ? '—' : '$ad7%', '近7天依从率', ad7),
          const SizedBox(width: 10),
          _statCard(ad30 == null ? '—' : '$ad30%', '近30天依从率', ad30),
          const SizedBox(width: 10),
          _statCard('$streak🌱', '连续灌溉', streak >= 30 ? 100 : 50),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, int? pct) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(color: Color(0x105D5040), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: pct == null
                    ? AppColors.priDark
                    : AppColors.adherence(pct),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.sub),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _adherenceBars(
    List<IntakeEventRow> events,
    Map<String, MedicationRow> medById,
  ) {
    final grouped = <String, List<IntakeEventRow>>{};
    for (final e in events) {
      grouped.putIfAbsent(e.medicationId, () => []).add(e);
    }
    final rows = <Widget>[];
    grouped.forEach((medId, list) {
      final med = medById[medId];
      if (med == null) return;
      final pct = _adherence(list) ?? 0;
      rows.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  '${med.emoji} ${med.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 10,
                    color: const Color(0xFFEFE9DB),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (pct / 100).clamp(0.0, 1.0),
                      child: Container(color: AppColors.adherence(pct)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 38,
                child: Text(
                  '$pct%',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.sub),
                ),
              ),
            ],
          ),
        ),
      );
    });
    if (rows.isEmpty) {
      rows.add(_box(
        const Text(
          '暂无依从率数据',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.sub),
        ),
      ));
    }
    return rows;
  }

  // ============ 计算 ============
  bool _withinDays(IntakeEventRow e, DateTime today, int days) {
    final d = parseYmd(e.planDate);
    return !d.isBefore(DateTime(today.year, today.month, today.day - (days - 1)));
  }

  int? _adherence(List<IntakeEventRow> events) {
    final confirmed = events.where((e) => e.status != 'pending').toList();
    if (confirmed.isEmpty) return null;
    final taken = confirmed.where((e) => e.status == 'taken').length;
    return (taken / confirmed.length * 100).round();
  }

  String _dayStatus(List<IntakeEventRow> dayEvents, DateTime date, DateTime today) {
    if (dayEvents.isEmpty) return date.isAfter(today) ? 'future' : 'none';
    if (dayEvents.any((e) => e.status == 'missed')) return 'bad';
    if (dayEvents.any((e) => e.status == 'skipped')) return 'warn';
    if (dayEvents.every((e) => e.status != 'pending')) return 'ok';
    return 'warn';
  }

  Color? _statusColor(String status) {
    switch (status) {
      case 'ok':
        return AppColors.pri;
      case 'warn':
        return AppColors.honeyDark;
      case 'bad':
        return AppColors.bad;
      case 'none':
        return AppColors.muted;
      default:
        return null;
    }
  }

  static String _num(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
