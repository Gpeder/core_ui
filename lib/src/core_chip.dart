import 'package:flutter/material.dart';

enum CoreChipSize { sm, md, lg }

enum CoreChipRadius { sm, md, lg }

enum CoreChipVariant { outlined, filled }

class CoreChip extends StatelessWidget {
  const CoreChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.disabled = false,
    this.size = CoreChipSize.md,
    this.radius = CoreChipRadius.md,
    this.variant = CoreChipVariant.outlined,
    this.fillColor,
    this.activeColor,
    this.activeLabelColor,
    this.inactiveLabelColor,
    this.inactiveBorderColor,
  });
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final bool disabled;
  final CoreChipSize size;
  final CoreChipRadius radius;
  final CoreChipVariant variant;
  final Color? fillColor;
  final Color? activeColor;
  final Color? activeLabelColor;
  final Color? inactiveLabelColor;
  final Color? inactiveBorderColor;

  EdgeInsets get _padding => switch (size) {
    CoreChipSize.sm => const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    CoreChipSize.md => const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    CoreChipSize.lg => const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
  };

  double get _fontSize => switch (size) {
    CoreChipSize.sm => 11,
    CoreChipSize.md => 13,
    CoreChipSize.lg => 15,
  };

  double get _borderRadius => switch (radius) {
    CoreChipRadius.sm => 8,
    CoreChipRadius.md => 12,
    CoreChipRadius.lg => 24,
  };

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled;
    final isFilled = variant == CoreChipVariant.filled;
    final activeBgColor = activeColor ?? Theme.of(context).colorScheme.primary;
    final activeTextColor = activeLabelColor ?? Theme.of(context).colorScheme.onPrimary;
    final defaultFillColor = fillColor ?? Colors.grey.shade200;
    final inactiveBgColor = isFilled ? defaultFillColor : Colors.transparent;
    final inactiveTextColor = inactiveLabelColor ?? Theme.of(context).colorScheme.onSurface;
    final inactiveBorderColorValue =
        inactiveBorderColor ?? (isFilled ? Colors.transparent : Theme.of(context).dividerColor);

    Widget chip = GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              if (onSelected != null) {
                onSelected!(!selected);
              }
            },
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 200),
        padding: _padding,
        decoration: BoxDecoration(
          color: selected ? activeBgColor : inactiveBgColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          border: Border.all(
            color: selected ? activeBgColor : inactiveBorderColorValue,
            width: 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: _fontSize,
            fontWeight: FontWeight.w500,
            color: selected ? activeTextColor : inactiveTextColor,
            height: 1.2,
          ),
        ),
      ),
    );

    if (isDisabled) {
      chip = Opacity(opacity: 0.5, child: chip);
    }

    return chip;
  }
}
