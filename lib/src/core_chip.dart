import 'package:flutter/material.dart';

class CoreChip extends StatelessWidget {
  const CoreChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.disabled = false,
  });
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled;
    final activeBgColor = Theme.of(context).colorScheme.primary;
    final activeTextColor = Theme.of(context).colorScheme.onPrimary;
    const inactiveBgColor = Colors.transparent;
    final inactiveTextColor = Theme.of(context).colorScheme.onSurface;
    final inactiveBorderColor = Theme.of(context).dividerColor;

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? activeBgColor : inactiveBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? activeBgColor : inactiveBorderColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
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
