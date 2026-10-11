import 'package:flutter/material.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/core/enums.dart';

/// 植物成长 Hero：连续灌溉游戏化（摇摆动画 + 进度胶囊条）
class PlantHero extends StatefulWidget {
  const PlantHero({
    super.key,
    required this.streak,
    required this.pendingCount,
    required this.totalCount,
    required this.doneCount,
  });

  final int streak;
  final int pendingCount;
  final int totalCount;
  final int doneCount;

  @override
  State<PlantHero> createState() => _PlantHeroState();
}

class _PlantHeroState extends State<PlantHero> with SingleTickerProviderStateMixin {
  late final AnimationController _sway = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _sway.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allDone = widget.totalCount > 0 && widget.pendingCount == 0;
    final stage = PlantStage.forStreak(widget.streak + (allDone ? 1 : 0));
    final progress = widget.totalCount == 0 ? 0.0 : widget.doneCount / widget.totalCount;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 2, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(color: Color(0x175D5040), blurRadius: 22, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFEDF4E4), Color(0xFFDCE9CC)],
                  ),
                ),
                alignment: Alignment.center,
                child: AnimatedBuilder(
                  animation: _sway,
                  builder: (_, child) => Transform.rotate(
                    angle: (_sway.value - 0.5) * 0.18,
                    alignment: Alignment.bottomCenter,
                    child: child,
                  ),
                  child: Text(
                    allDone ? '🌻' : stage.emoji,
                    style: const TextStyle(fontSize: 38),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allDone
                          ? '盛开 · 连续灌溉 ${widget.streak + 1} 天'
                          : '${stage.label} · 连续灌溉 ${widget.streak} 天',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.priDark,
                        letterSpacing: .5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.totalCount == 0
                          ? '今天没有安排，轻松一天'
                          : (allDone ? '今日灌溉完成！' : '还有 ${widget.pendingCount} 项待服用'),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      allDone ? '小草喝饱啦，明天继续 🌻' : '全部完成即可为小草浇水 💧',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.sub,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LayoutBuilder(
              builder: (context, c) => Stack(
                children: [
                  Container(height: 10, color: const Color(0xFFECE5D5)),
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    tween: Tween(begin: 0, end: progress),
                    builder: (context, v, _) => Container(
                      height: 10,
                      width: c.maxWidth * v,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF2CC8F), Color(0xFF5F8D4E)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
