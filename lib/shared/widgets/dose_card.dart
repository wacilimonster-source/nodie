import 'package:flutter/material.dart';
import 'package:cyjl/app/providers.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/shared/widgets/pop_button.dart';

/// 今日剂量卡片：颜色条 + 名称/标签 + 元信息 + 已服/跳过
class DoseCard extends StatelessWidget {
  const DoseCard({
    super.key,
    required this.item,
    required this.onTaken,
    required this.onSkip,
  });

  final DoseItem item;
  final VoidCallback onTaken;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final med = item.med;
    final event = item.event;
    final overdue = item.overdue;
    final barColor = overdue ? AppColors.bad : AppColors.fromHex(med.color);
    final isMed = med.type == MedType.medicine.code;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.fromLTRB(15, 13, 13, 13),
      decoration: BoxDecoration(
        color: overdue ? AppColors.badLight : AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x145D5040), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 46,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(999),
            ),
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
                        '${med.emoji} ${med.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isMed ? AppColors.accLight : AppColors.priLight,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isMed ? '药' : '保',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: isMed ? AppColors.acc : AppColors.priDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '🕐 ${event.planTime} · ${_num(event.planDose)}${item.unit}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.sub,
                      ),
                    ),
                    if ((med.instruction ?? '').isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.priLight,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          med.instruction!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.priDark,
                          ),
                        ),
                      ),
                    if (overdue)
                      const Text(
                        '已超时',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.bad,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              CapsuleButton(
                label: '已服用',
                dense: true,
                kind: overdue ? CapsuleKind.danger : CapsuleKind.primary,
                onPressed: onTaken,
              ),
              const SizedBox(height: 6),
              CapsuleButton(
                label: '跳过',
                dense: true,
                kind: CapsuleKind.ghost,
                onPressed: onSkip,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _num(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}

/// 已完成条目（置灰 + 状态徽章 + 撤销）
class DoneDoseRow extends StatelessWidget {
  const DoneDoseRow({super.key, required this.item, required this.onUndo});

  final DoseItem item;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    final status = EventStatus.fromCode(item.event.status);
    late Color fg;
    late Color bg;
    switch (status) {
      case EventStatus.taken:
        fg = AppColors.doneInk;
        bg = AppColors.doneTag;
        break;
      case EventStatus.skipped:
        fg = const Color(0xFFA0742A);
        bg = const Color(0xFFFBF0DA);
        break;
      default:
        fg = AppColors.bad;
        bg = AppColors.badLight;
    }
    final actual = item.event.actualAt;
    final actualText = actual == null
        ? ''
        : ' · ${_hm(DateTime.fromMillisecondsSinceEpoch(actual))}';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.fromLTRB(15, 11, 13, 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1E6),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.med.emoji} ${item.med.name}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
                  child: Text(
                    '${status.label}$actualText · 计划 ${item.event.planTime}',
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: fg),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onUndo,
            child: const Text(
              '撤销',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.pri,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _hm(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
