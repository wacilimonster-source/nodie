import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyjl/app/providers.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/domain/plan_slot.dart';
import 'package:cyjl/features/add_med/add_med_screen.dart';
import 'package:cyjl/features/med_detail/med_detail_screen.dart';
import 'package:cyjl/shared/widgets/page_scaffold.dart';
import 'package:cyjl/shared/widgets/pop_button.dart';
import 'package:cyjl/shared/widgets/section_title.dart';

class CabinetScreen extends ConsumerWidget {
  const CabinetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medsAsync = ref.watch(medsProvider);
    final schedules = ref.watch(schedulesProvider).valueOrNull ?? const <ScheduleRow>[];
    final ingredients = ref.watch(ingredientsProvider).valueOrNull ?? const <ProductIngredientRow>[];

    return PageScaffold(
      title: '药箱',
      action: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddMedScreen()),
        ),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.acc,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: AppColors.acc.withOpacity(0.45), blurRadius: 14, offset: const Offset(0, 5)),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 22),
        ),
      ),
      child: medsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (meds) {
          if (meds.isEmpty) {
            return _empty(context);
          }
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              ..._group(context, ref, meds, schedules, ingredients, MedType.medicine, '💊 药品'),
              ..._group(context, ref, meds, schedules, ingredients, MedType.supplement, '🌿 保健品'),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 18, 16, 8),
                child: Text(
                  '点击条目查看详情 · 长按可暂停/删除',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.sub),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _group(
    BuildContext context,
    WidgetRef ref,
    List<MedicationRow> meds,
    List<ScheduleRow> schedules,
    List<ProductIngredientRow> ingredients,
    MedType type,
    String title,
  ) {
    final list = meds.where((m) => m.type == type.code).toList();
    if (list.isEmpty) return const [];
    return [
      SectionTitle('$title（${list.length}）'),
      ...list.map((m) => _row(context, ref, m, schedules, ingredients)),
    ];
  }

  Widget _row(
    BuildContext context,
    WidgetRef ref,
    MedicationRow m,
    List<ScheduleRow> schedules,
    List<ProductIngredientRow> ingredients,
  ) {
    final mySchedules = schedules.where((s) => s.medicationId == m.id && s.isActive).toList();
    final summary = mySchedules.isEmpty
        ? (m.isActive ? '未配置计划' : '已暂停')
        : describeSchedule(mySchedules.first);
    final ingCount = ingredients.where((i) => i.medicationId == m.id).length;
    final low = m.stockEnabled &&
        m.stockRemaining != null &&
        m.stockRemaining! / dailyDoseFor(mySchedules) <= m.lowStockDays;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MedDetailScreen(medId: m.id)),
      ),
      onLongPress: () => _showActions(context, ref, m),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 9, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Color(0x125D5040), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.fromHex(m.color),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(m.emoji, style: const TextStyle(fontSize: 21)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          m.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      if (!m.isActive) ...[
                        const SizedBox(width: 6),
                        const MiniChip('已暂停', bg: Color(0xFFEFE9DB), fg: AppColors.sub),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$summary${ingCount > 0 ? ' · 含$ingCount种成分' : ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.sub),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (m.stockEnabled && m.stockRemaining != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                    decoration: BoxDecoration(
                      color: low ? AppColors.badLight : const Color(0xFFF4EFE3),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '余 ${m.stockRemaining!.toInt()}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: low ? AppColors.bad : AppColors.sub,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    low ? '库存不足' : '约${(m.stockRemaining! / dailyDoseFor(mySchedules)).floor()}天',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: low ? AppColors.bad : AppColors.sub,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🧺', style: TextStyle(fontSize: 46)),
            const SizedBox(height: 12),
            const Text(
              '药箱还是空的',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.ink),
            ),
            const SizedBox(height: 6),
            const Text(
              '添加第一种药品或保健品开始记录',
              style: TextStyle(fontSize: 11.5, color: AppColors.sub),
            ),
            const SizedBox(height: 18),
            CapsuleButton(
              label: '＋ 添加',
              kind: CapsuleKind.accent,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddMedScreen()),
              ),
            ),
          ],
        ),
      );

  void _showActions(BuildContext context, WidgetRef ref, MedicationRow m) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('⏸'),
              title: Text(m.isActive ? '暂停（不再生成提醒）' : '恢复启用'),
              onTap: () async {
                Navigator.pop(ctx);
                await ref.read(medicationRepoProvider).setActive(m.id, !m.isActive);
                await ref.read(eventControllerProvider).refreshPlan();
              },
            ),
            ListTile(
              leading: const Text('🗑'),
              title: const Text('删除（历史记录保留）'),
              onTap: () async {
                Navigator.pop(ctx);
                await ref.read(medicationRepoProvider).softDelete(m.id);
                await ref.read(eventControllerProvider).refreshPlan();
              },
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
