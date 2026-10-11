import 'package:flutter/material.dart';

/// 胶囊按钮 + 点击弹跳（pop）动效
enum CapsuleKind { primary, ghost, accent, danger, honey }

class CapsuleButton extends StatefulWidget {
  const CapsuleButton({
    super.key,
    required this.label,
    this.onPressed,
    this.kind = CapsuleKind.primary,
    this.expand = false,
    this.dense = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final CapsuleKind kind;
  final bool expand;
  final bool dense;

  @override
  State<CapsuleButton> createState() => _CapsuleButtonState();
}

class _CapsuleButtonState extends State<CapsuleButton> {
  double _scale = 1;

  Color _bg(BuildContext c) {
    switch (widget.kind) {
      case CapsuleKind.primary:
        return const Color(0xFF5F8D4E);
      case CapsuleKind.accent:
        return const Color(0xFFE07A5F);
      case CapsuleKind.danger:
        return const Color(0xFFD4654F);
      case CapsuleKind.honey:
        return const Color(0xFFDDA54F);
      case CapsuleKind.ghost:
        return const Color(0xFFEFE7D8);
    }
  }

  Color _fg() => widget.kind == CapsuleKind.ghost ? const Color(0xFF8A8378) : Colors.white;

  void _set(double s) => setState(() => _scale = s);

  @override
  Widget build(BuildContext context) {
    final btn = GestureDetector(
      onTapDown: (_) => _set(0.92),
      onTapUp: (_) => _set(1),
      onTapCancel: () => _set(1),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: widget.dense
              ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8)
              : const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _bg(context),
            borderRadius: BorderRadius.circular(999),
            boxShadow: widget.kind == CapsuleKind.ghost
                ? null
                : [
                    BoxShadow(
                      color: _bg(context).withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(
              color: _fg(),
              fontWeight: FontWeight.w800,
              fontSize: widget.dense ? 11.5 : 13,
            ),
          ),
        ),
      ),
    );
    return widget.expand ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}
