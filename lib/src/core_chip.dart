import 'package:flutter/material.dart';

enum CoreChipSize { sm, md, lg }

enum CoreChipVariant { outlined, filled }

class CoreChip extends StatelessWidget {
  const CoreChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.disabled = false,
    this.size = CoreChipSize.md,
    this.variant = CoreChipVariant.outlined,
    this.fillColor,
  });
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final bool disabled;
  final CoreChipSize size;
  final CoreChipVariant variant;
  final Color? fillColor;

  EdgeInsets get _padding => switch (size) {
    CoreChipSize.sm => const .symmetric(horizontal: 8, vertical: 3),
    CoreChipSize.md => const .symmetric(horizontal: 12, vertical: 5),
    CoreChipSize.lg => const .symmetric(horizontal: 16, vertical: 7),
  };

  double get _fontSize => switch (size) {
    CoreChipSize.sm => 11,
    CoreChipSize.md => 13,
    CoreChipSize.lg => 15,
  };

  double get _borderRadius => switch (size) {
    CoreChipSize.sm => 12,
    CoreChipSize.md => 16,
    CoreChipSize.lg => 20,
  };

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled;
    final isFilled = variant == CoreChipVariant.filled;
    final activeBgColor = Theme.of(context).colorScheme.primary;
    final activeTextColor = Theme.of(context).colorScheme.onPrimary;
    final defaultFillColor = fillColor ?? Colors.grey.shade200;
    final inactiveBgColor = isFilled ? defaultFillColor : Colors.transparent;
    final inactiveTextColor = Theme.of(context).colorScheme.onSurface;
    final inactiveBorderColor = isFilled ? Colors.transparent : Theme.of(context).dividerColor;

    Widget chip = GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              if (onSelected != null) {
                onSelected!(!selected);
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: _padding,
        decoration: BoxDecoration(
          color: selected ? activeBgColor : inactiveBgColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          border: Border.all(
            color: selected ? activeBgColor : inactiveBorderColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
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
