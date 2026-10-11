import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyjl/app/providers.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/domain/plan_slot.dart';
import 'package:cyjl/features/add_med/add_med_screen.dart';
import 'package:cyjl/shared/widgets/pop_button.dart';
import 'package:cyjl/shared/widgets/section_title.dart';

class MedDetailScreen extends ConsumerWidget {
  const MedDetailScreen({super.key, required this.medId});

  final String medId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meds = ref.watch(medsProvider).valueOrNull ?? const <MedicationRow>[];
    final med = meds.where((m) => m.id == medId).firstOrNull;
    final schedules = ref.watch(schedulesProvider).valueOrNull ?? const <ScheduleRow>[];
    final ingredients =
        ref.watch(ingredientsProvider).valueOrNull ?? const <ProductIngredientRow>[];
    final todayEvents = ref.watch(todayEventsProvider).valueOrNull ?? const <IntakeEventRow>[];
    final nutrients = ref.watch(nutrientsProvider).valueOrNull ?? const <NutrientRow>[];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: med == null
            ? _removed(context)
            : Column(
                children: [
                  _topBar(context, ref, med),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _header(med),
                        if (schedules.isNotEmpty) ...[
                          const SectionTitle('服用计划'),
                          _card(schedules
                              .where((s) => s.isActive)
                              .map((s) => _kv('计划', describeSchedule(s)))
                              .toList()),
                        ],
                        if (ingredients.isNotEmpty) ...[
                          const SectionTitle('营养成分（每单位）'),
                          _ingredients(ingredients, nutrients),
                        ],
                        const SectionTitle('今日状态'),
                        _today(todayEvents.where((e) => e.medicationId == medId).toList()),
                        if (med.stockEnabled) ...[
                          const SectionTitle('库存'),
                          _stock(context, ref, med, schedules),
                        ],
                        _actions(context, ref, med),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _removed(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('该条目已删除', style: TextStyle(color: AppColors.sub)),
            const SizedBox(height: 12),
            CapsuleButton(label: '返回', onPressed: () => Navigator.pop(context)),
          ],
        ),
      );

  Widget _topBar(BuildContext context, WidgetRef ref, MedicationRow med) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 16, 4),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE9DB),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '‹ 药箱',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.ink),
                ),
              ),
            ),
            const Spacer(),
            Text(
              med.isActive ? '启用中' : '已暂停',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: med.isActive ? AppColors.priDark : AppColors.sub,
              ),
            ),
          ],
        ),
      );

  Widget _header(MedicationRow med) {
    final color = AppColors.fromHex(med.color);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.8)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -6,
            top: -10,
            child: Opacity(
              opacity: 0.28,
              child: Text(med.emoji, style: const TextStyle(fontSize: 64)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                med.name,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                '${MedType.fromCode(med.type).label} · ${med.form}'
                '${(med.instruction ?? '').isNotEmpty ? ' · ${med.instruction}' : ''}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xE6FFFFFF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card(List<Widget> children) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Color(0x125D5040), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(children: children),
      );

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(k, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.sub)),
            const Spacer(),
            Flexible(
              child: Text(
                v,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink),
              ),
            ),
          ],
        ),
      );

  Widget _ingredients(List<ProductIngredientRow> list, List<NutrientRow> nutrients) {
    final byCode = {for (final n in nutrients) n.code: n};
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x125D5040), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: list.map((i) {
              final n = byCode[i.nutrientCode];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4EFE3),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${n?.name ?? i.nutrientCode} ${_num(i.amountPerUnit)}${n?.unit ?? ''}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.ink),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          const Text(
            '确认服用后将自动计入「营养」页摄入统计',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.sub),
          ),
        ],
      ),
    );
  }

  Widget _today(List<IntakeEventRow> events) {
    if (events.isEmpty) {
      return _card([
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('今日无计划', style: TextStyle(fontSize: 12, color: AppColors.sub)),
        ),
      ]);
    }
    return _card(
      events.map((e) {
        final status = EventStatus.fromCode(e.status);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: Text(
                  e.planTime,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.sub),
                ),
              ),
              Expanded(
                child: Text(
                  _num(e.planDose),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink),
                ),
              ),
              _statusChip(status),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _statusChip(EventStatus status) {
    final (bg, fg) = switch (status) {
      EventStatus.taken => (AppColors.doneTag, AppColors.doneInk),
      EventStatus.skipped => (const Color(0xFFFBF0DA), const Color(0xFFA0742A)),
      EventStatus.missed => (AppColors.badLight, AppColors.bad),
      EventStatus.pending => (const Color(0xFFEFE9DB), AppColors.sub),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(status.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg)),
    );
  }

  Widget _stock(
    BuildContext context,
    WidgetRef ref,
    MedicationRow med,
    List<ScheduleRow> schedules,
  ) {
    final daily = dailyDoseFor(schedules.where((s) => s.medicationId == med.id).toList());
    final days = med.stockRemaining == null ? 0 : (med.stockRemaining! / daily).floor();
    final low = days <= med.lowStockDays;
    return _card([
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(
              '当前库存（约 $days 天）',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.sub),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _adjust(ref, med, -1),
              icon: const Icon(Icons.remove_circle_outline, color: AppColors.pri),
            ),
            SizedBox(
              width: 52,
              child: Text(
                '${med.stockRemaining?.toInt() ?? 0}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.ink),
              ),
            ),
            IconButton(
              onPressed: () => _adjust(ref, med, 1),
              icon: const Icon(Icons.add_circle_outline, color: AppColors.pri),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Text(
          low ? '⚠️ 库存偏低，建议补货' : '低库存阈值：剩 ${med.lowStockDays} 天时提醒',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: low ? AppColors.bad : AppColors.sub,
          ),
        ),
      ),
    ]);
  }

  Future<void> _adjust(WidgetRef ref, MedicationRow med, double delta) async {
    await ref.read(stockServiceProvider).adjust(med, delta);
  }

  Widget _actions(BuildContext context, WidgetRef ref, MedicationRow med) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Row(
          children: [
            Expanded(
              child: CapsuleButton(
                label: '编辑',
                kind: CapsuleKind.ghost,
                expand: true,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AddMedScreen(editMedId: med.id)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CapsuleButton(
                label: med.isActive ? '暂停' : '启用',
                kind: CapsuleKind.ghost,
                expand: true,
                onPressed: () async {
                  await ref.read(medicationRepoProvider).setActive(med.id, !med.isActive);
                  await ref.read(eventControllerProvider).refreshPlan();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CapsuleButton(
                label: '删除',
                kind: CapsuleKind.danger,
                expand: true,
                onPressed: () async {
                  final ok = await _confirmDelete(context);
                  if (ok == true) {
                    await ref.read(medicationRepoProvider).softDelete(med.id);
                    await ref.read(eventControllerProvider).refreshPlan();
                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      );

  Future<bool?> _confirmDelete(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('删除确认', style: TextStyle(fontWeight: FontWeight.w800)),
          content: const Text('删除后不再生成提醒，历史记录会保留。确定删除吗？'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('删除', style: TextStyle(color: AppColors.bad, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      );

  static String _num(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
