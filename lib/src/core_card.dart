import 'package:flutter/material.dart';

enum CoreCardVariant { outline, elevated }

class CoreCard extends StatefulWidget {
  const CoreCard({
    super.key,
    required this.child,
    this.variant = CoreCardVariant.outline,
    this.onTap,
    this.padding = const EdgeInsets.all(24),
  });

  final Widget child;
  final CoreCardVariant variant;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  State<CoreCard> createState() => _CoreCardState();
}

class _CoreCardState extends State<CoreCard> {
  bool _isHovering = false;
  bool _isPressed = false;

  void _onHover(bool isHovering) {
    if (widget.onTap != null) {
      setState(() => _isHovering = isHovering);
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = false);
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE4E4E7);
    const backgroundColor = Colors.white;

    final isElevated = widget.variant == CoreCardVariant.elevated;

    final Color overlayColor = _isPressed
        ? const Color(0xFFF4F4F5).withValues(alpha: 0.8)
        : _isHovering
        ? const Color(0xFFF4F4F5).withValues(alpha: 0.5)
        : Colors.transparent;

    final double scale = _isPressed ? 0.98 : 1.0;

    Widget cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: overlayColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: widget.padding,
      child: widget.child,
    );

    Widget card = AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: isElevated ? null : Border.all(color: borderColor, width: 1),
          boxShadow: isElevated
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onHover: _onHover,
            borderRadius: BorderRadius.circular(12),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: cardContent,
          ),
        ),
      ),
    );

    return card;
  }
}
