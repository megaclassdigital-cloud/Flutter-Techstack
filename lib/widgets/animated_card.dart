import 'package:flutter/material.dart';

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets margin;
  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin = const EdgeInsets.all(8),
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        _hovered = true;
        _ctrl.forward();
      },
      onTapUp: (_) {
        _hovered = false;
        _ctrl.reverse();
      },
      onTapCancel: () {
        _hovered = false;
        _ctrl.reverse();
      },
      child: AnimatedBuilder(
        animation: _scale,
        builder:
            (context, child) =>
                Transform.scale(scale: _scale.value, child: child),
        child: Card(
          margin: widget.margin,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: _hovered ? 10 : 4,
          color: const Color(0xFF181818),
          shadowColor: Colors.black.withValues(alpha: 0.45),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
