import 'package:flutter/material.dart';

enum CoreCardVariant { outline, elevated }

enum CoreCardRadius { sm, md, lg }

class CoreCard extends StatefulWidget {
  const CoreCard({
    super.key,
    required this.child,
    this.variant = CoreCardVariant.outline,
    this.radius = CoreCardRadius.md,
    this.onTap,
    this.padding = const EdgeInsets.all(24),
    this.backgroundColor,
  });

  final Widget child;
  final CoreCardVariant variant;
  final CoreCardRadius radius;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

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
    final borderColor = Theme.of(context).dividerColor;
    final backgroundColor = widget.backgroundColor ?? Theme.of(context).colorScheme.surface;

    final isElevated = widget.variant == CoreCardVariant.elevated;

    final Color overlayColor = _isPressed
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
        : _isHovering
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.04)
        : Colors.transparent;

    final double scale = _isPressed ? 0.98 : 1.0;

    final double borderRadiusValue = switch (widget.radius) {
      CoreCardRadius.sm => 8,
      CoreCardRadius.md => 12,
      CoreCardRadius.lg => 24,
    };

    Widget cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: overlayColor,
        borderRadius: BorderRadius.circular(borderRadiusValue),
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
          borderRadius: BorderRadius.circular(borderRadiusValue),
          border: isElevated ? null : Border.all(color: borderColor, width: 1),
          boxShadow: isElevated
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.02),
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
            borderRadius: BorderRadius.circular(borderRadiusValue),
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
