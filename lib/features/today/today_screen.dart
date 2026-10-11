import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyjl/app/providers.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/shared/widgets/dose_card.dart';
import 'package:cyjl/shared/widgets/page_scaffold.dart';
import 'package:cyjl/shared/widgets/plant_hero.dart';
import 'package:cyjl/shared/widgets/section_title.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(doseItemsProvider);
    final streak = ref.watch(streakProvider).valueOrNull ?? 0;
    final meds = ref.watch(medsProvider).valueOrNull ?? const <MedicationRow>[];
    final schedules = ref.watch(schedulesProvider).valueOrNull ?? const <ScheduleRow>[];

    return PageScaffold(
      title: '今日',
      subtitle: _dateText(),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('加载失败：$e', style: const TextStyle(color: AppColors.sub)),
        ),
        data: (list) {
          final pending = list.where((i) => i.event.status == 'pending').toList();
          final done = list.where((i) => i.event.status != 'pending').toList();

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              PlantHero(
                streak: streak,
                pendingCount: pending.length,
                totalCount: list.length,
                doneCount: done.length,
              ),
              ..._lowStockBanners(meds, schedules),
              if (list.isEmpty) _emptyState(),
              if (pending.isNotEmpty) const SectionTitle('待服用'),
              ...pending.map(
                (i) => DoseCard(
                  item: i,
                  onTaken: () => ref.read(eventControllerProvider).markTaken(i.event.id),
                  onSkip: () => ref.read(eventControllerProvider).skip(i.event.id),
                ),
              ),
              if (done.isNotEmpty)
                _DoneSection(
                  items: done,
                  onUndo: (id) => ref.read(eventControllerProvider).undo(id),
                ),
              const SizedBox(height: 14),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _lowStockBanners(List<MedicationRow> meds, List<ScheduleRow> schedules) {
    final rows = <Widget>[];
    for (final m in meds) {
      if (!m.stockEnabled || m.stockRemaining == null) continue;
      final mySchedules = schedules.where((s) => s.medicationId == m.id).toList();
      final daily = dailyDoseFor(mySchedules);
      if (daily <= 0) continue;
      final days = (m.stockRemaining! / daily).floor();
      if (days <= m.lowStockDays) {
        rows.add(_banner('🍂 ${m.name} 库存约还能吃 $days 天'));
      }
    }
    return rows;
  }

  Widget _banner(String text) => Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF3DC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.honeyDark, style: BorderStyle.solid, width: 1.5),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF8A6D1F),
          ),
        ),
      );

  Widget _emptyState() => const Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
        child: Column(
          children: [
            Text('🌻', style: TextStyle(fontSize: 44)),
            SizedBox(height: 10),
            Text(
              '今天没有安排，去药箱添加吧',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.sub,
              ),
            ),
          ],
        ),
      );

  String _dateText() {
    final now = DateTime.now();
    const weeks = ['一', '二', '三', '四', '五', '六', '日'];
    return '${now.month}月${now.day}日 周${weeks[now.weekday - 1]}';
  }
}

class _DoneSection extends StatefulWidget {
  const _DoneSection({required this.items, required this.onUndo});

  final List<DoseItem> items;
  final ValueChanged<String> onUndo;

  @override
  State<_DoneSection> createState() => _DoneSectionState();
}

class _DoneSectionState extends State<_DoneSection> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
          child: GestureDetector(
            onTap: () => setState(() => _open = !_open),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFEFE9DB),
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: Text(
                '${_open ? '▾' : '▸'} 今日已确认（${widget.items.length}）',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.sub,
                ),
              ),
            ),
          ),
        ),
        if (_open)
          ...widget.items.map(
            (i) => DoneDoseRow(item: i, onUndo: () => widget.onUndo(i.event.id)),
          ),
      ],
    );
  }
}
