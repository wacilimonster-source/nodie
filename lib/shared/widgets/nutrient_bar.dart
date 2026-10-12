import 'package:flutter/material.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/core/format.dart';
import 'package:cyjl/domain/plan_slot.dart';

/// 营养素卡片：
/// - 有参考值（RNI/AI/SPL）→ 双刻度进度条（RNI 刻度 + UL 红色刻度）
/// - 无参考值（仅记录）→ 简版卡片，只展示摄入量与来源
class NutrientBar extends StatelessWidget {
  const NutrientBar({super.key, required this.intake, required this.femaleProfile});

  final NutrientIntake intake;
  final bool femaleProfile;

  @override
  Widget build(BuildContext context) {
    final n = intake.nutrient;
    if (!intake.hasReference) {
      return _card(
        Row(
          children: [
            Expanded(
              child: Text('${n.emoji} ${n.name}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.ink)),
            ),
            _tag('仅记录'),
          ],
        ),
        [
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(fmtNum(intake.amount),
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.ink)),
              const SizedBox(width: 4),
              Text(n.unit, style: const TextStyle(fontSize: 10, color: AppColors.sub)),
            ],
          ),
          if ((n.note ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(n.note!, style: const TextStyle(fontSize: 10, color: AppColors.sub)),
          ],
          if (intake.sources.isNotEmpty) ...[
            const SizedBox(height: 7),
            _sources(n),
          ],
        ],
      );
    }

    final goal = intake.goal(femaleProfile);
    final ul = intake.ul;
    final amount = intake.amount;
    final overUl = intake.overUl;
    final nearUl = intake.nearUl(femaleProfile);
    final reached = intake.reached(femaleProfile);

    final maxScale = <double>[
      if (ul != null) ul,
      goal * 1.6,
      amount * 1.15,
    ].reduce((a, b) => a > b ? a : b);

    final fillClass = overUl ? 'over' : (reached ? 'ok' : 'low');
    late final Color fillStart;
    late final Color fillEnd;
    switch (fillClass) {
      case 'over':
        fillStart = AppColors.acc;
        fillEnd = AppColors.bad;
        break;
      case 'ok':
        fillStart = const Color(0xFF8FBC78);
        fillEnd = AppColors.pri;
        break;
      default:
        fillStart = AppColors.honey;
        fillEnd = const Color(0xFFE9BF7A);
    }

    late final Color msgColor;
    late final String msg;
    if (overUl) {
      msgColor = AppColors.bad;
      msg = '⛔ 已超每日上限 ${fmtNum(ul!)}${n.unit}，请勿继续服用并咨询医生';
    } else if (nearUl) {
      msgColor = AppColors.acc;
      msg = '⚠️ 接近每日上限（${fmtNum(amount)}/${fmtNum(ul!)}${n.unit}），注意总量';
    } else if (reached) {
      msgColor = AppColors.priDark;
      msg = '✓ 已达${n.refLabel ?? '参考值'}';
    } else {
      msgColor = AppColors.honeyDark;
      msg = '还差 ${fmtNum(goal - amount)}${n.unit} 达标';
    }

    return _card(
      Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text('${n.emoji} ${n.name}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.ink)),
          const Spacer(),
          Text('${n.refLabel} ${fmtNum(goal)}${n.unit}',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.sub)),
        ],
      ),
      [
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(fmtNum(amount),
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.ink)),
            const SizedBox(width: 4),
            Text(n.unit, style: const TextStyle(fontSize: 10, color: AppColors.sub)),
            const Spacer(),
            Text('目标 ${fmtNum(goal)}${n.unit}',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.sub)),
          ],
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final fillW = (amount / maxScale).clamp(0.0, 1.0) * w;
            return SizedBox(
              height: 22,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 4,
                    left: 0,
                    right: 0,
                    height: 14,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFE9DB),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 0,
                    height: 14,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: fillW),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      builder: (context, v, _) => Container(
                        width: v,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [fillStart, fillEnd]),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                  _tick(x: goal / maxScale * w, color: AppColors.priDark, label: 'RNI'),
                  if (ul != null)
                    _tick(x: ul / maxScale * w, color: AppColors.bad, label: 'UL ${fmtNum(ul)}'),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Text(msg, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: msgColor)),
        if ((n.note ?? '').isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(n.note!, style: const TextStyle(fontSize: 10, color: AppColors.sub)),
        ],
        if (intake.sources.isNotEmpty) ...[
          const SizedBox(height: 7),
          _sources(n),
        ],
      ],
    );
  }

  Widget _card(Widget header, List<Widget> rest) => Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 13),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Color(0x125D5040), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [header, ...rest]),
      );

  Widget _tag(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EADC),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.sub)),
      );

  Widget _sources(dynamic n) => Wrap(
        spacing: 5,
        runSpacing: 5,
        children: intake.sources
            .map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4EFE3),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${s.emoji} ${s.name} +${fmtNum(s.amount)}${n.unit}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.sub),
                  ),
                ))
            .toList(),
      );

  Widget _tick({required double x, required Color color, required String label}) {
    return Positioned(
      left: x - 1,
      top: 1,
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: color)),
          Container(width: 2.5, height: 20, color: color),
        ],
      ),
    );
  }
}
