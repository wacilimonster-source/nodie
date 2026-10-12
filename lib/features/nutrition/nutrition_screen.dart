import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyjl/app/providers.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/shared/widgets/nutrient_bar.dart';
import 'package:cyjl/shared/widgets/page_scaffold.dart';
import 'package:cyjl/shared/widgets/section_title.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  static const _catTitle = {
    'vitamin': '🍊 维生素',
    'mineral': '🪨 矿物质',
    'fatty_acid': '🐟 脂肪酸',
    'phyto': '🌿 其他膳食成分',
    'other': '🧪 其他成分',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(settingsProvider).profile;
    final female = profile == ProfileType.female;
    final async = ref.watch(nutritionSummaryProvider);

    return PageScaffold(
      title: '营养摄入',
      action: GestureDetector(
        onTap: () => ref.read(settingsProvider.notifier).setProfile(
              female ? ProfileType.male : ProfileType.female,
            ),
        child: Text(
          '${profile.label} ›',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.sub,
          ),
        ),
      ),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (summary) {
          if (summary.items.isEmpty) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(30, 60, 30, 20),
              child: Column(
                children: [
                  Text('🥗', style: TextStyle(fontSize: 44)),
                  SizedBox(height: 10),
                  Text(
                    '今日暂无营养摄入记录',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.sub,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '在药箱为保健品录入成分后，确认服用即自动汇总',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: AppColors.sub),
                  ),
                ],
              ),
            );
          }

          final children = <Widget>[_hero(summary.totalCount, summary.reachedCount)];
          String? lastCat;
          for (final item in summary.items) {
            final cat = item.nutrient.category;
            if (cat != lastCat) {
              children.add(SectionTitle(_catTitle[cat] ?? '其他'));
              lastCat = cat;
            }
            children.add(NutrientBar(intake: item, femaleProfile: female));
          }
          children.add(const _DrisNote());
          children.add(const SizedBox(height: 14));

          return ListView(padding: EdgeInsets.zero, children: children);
        },
      ),
    );
  }

  Widget _hero(int total, int reached) => Container(
        margin: const EdgeInsets.fromLTRB(16, 2, 16, 0),
        padding: const EdgeInsets.fromLTRB(18, 18, 16, 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5F8D4E), Color(0xFF7BA96A)],
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x4D5F8D4E), blurRadius: 26, offset: Offset(0, 10)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: -24,
              child: Opacity(
                opacity: 0.18,
                child: Transform.rotate(
                  angle: -0.14,
                  child: const Text('🥗', style: TextStyle(fontSize: 78)),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '今日已摄入营养素',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xE6FFFFFF),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$total',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const TextSpan(
                        text: ' 种',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xD9FFFFFF),
                        ),
                      ),
                      TextSpan(
                        text: '  · 达标 $reached 种',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xD9FFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '对照《中国居民膳食营养素参考摄入量 2023》',
                  style: TextStyle(
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

class _DrisNote extends StatelessWidget {
  const _DrisNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EFE3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(fontSize: 10.5, height: 1.8, color: AppColors.sub),
          children: [
            TextSpan(
              text: '📖 参考标准：',
              style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
            ),
            TextSpan(text: '中国营养学会《中国居民膳食营养素参考摄入量（2023 版）》，按人群档案取值（设置页可切换）。\n'),
            TextSpan(
              text: 'RNI',
              style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.priDark),
            ),
            TextSpan(text: ' 推荐摄入量 · '),
            TextSpan(
              text: 'AI',
              style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.priDark),
            ),
            TextSpan(text: ' 适宜摄入量 · '),
            TextSpan(
              text: 'UL',
              style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.bad),
            ),
            TextSpan(text: ' 可耐受最高摄入量。\n'),
            TextSpan(text: '⚠️ 仅统计保健品补充量，不含膳食摄入，结果仅供参考，不构成医疗建议。'),
          ],
        ),
      ),
    );
  }
}
