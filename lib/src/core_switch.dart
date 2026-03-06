import 'package:flutter/material.dart';

class CoreSwitch extends StatelessWidget {
  const CoreSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.description,
    this.disabled = false,
  });
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? description;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled || onChanged == null;
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Theme.of(context).dividerColor;
    final thumbColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final descriptionColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    Widget customSwitch = GestureDetector(
      onTap: isDisabled ? null : () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 44,
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value ? activeColor : inactiveColor,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: thumbColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.12),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (label != null || description != null) {
      customSwitch = Row(
        crossAxisAlignment: description != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: description != null ? 2.0 : 0.0),
            child: customSwitch,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label != null)
                  GestureDetector(
                    onTap: isDisabled ? null : () => onChanged?.call(!value),
                    child: Text(
                      label!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                        height: 1.2,
                      ),
                    ),
                  ),
                if (description != null) ...[
                  if (label != null) const SizedBox(height: 4),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: descriptionColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    if (isDisabled) {
      customSwitch = Opacity(opacity: 0.5, child: customSwitch);
    }

    return customSwitch;
  }
}
