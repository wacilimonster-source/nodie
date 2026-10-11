import 'package:flutter/material.dart';
import 'package:cyjl/app/theme/app_colors.dart';

class NavItem {
  const NavItem(this.emoji, this.label);
  final String emoji;
  final String label;
}

/// 悬浮胶囊底部导航（5 Tab）
class CapsuleNav extends StatelessWidget {
  const CapsuleNav({
    super.key,
    required this.index,
    required this.onChanged,
  });

  final int index;
  final ValueChanged<int> onChanged;

  static const items = <NavItem>[
    NavItem('☀️', '今日'),
    NavItem('🥗', '营养'),
    NavItem('📅', '记录'),
    NavItem('🧺', '药箱'),
    NavItem('⚙️', '设置'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.96),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.line.withOpacity(0.7)),
        boxShadow: const [
          BoxShadow(color: Color(0x225D5040), blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: i == index ? AppColors.priLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        scale: i == index ? 1.12 : 1,
                        duration: const Duration(milliseconds: 220),
                        child: Text(items[i].emoji, style: const TextStyle(fontSize: 19)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: i == index ? FontWeight.w800 : FontWeight.w600,
                          color: i == index ? AppColors.priDark : AppColors.sub,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
