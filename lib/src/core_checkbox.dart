import 'package:flutter/material.dart';

class CoreCheckBox extends StatelessWidget {
  const CoreCheckBox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.description,
    this.disabled = false,
  });
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final String? description;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled || onChanged == null;
    const primaryColor = Color(0xFF18181B);
    const textColor = Color(0xFF18181B);
    const descriptionColor = Color(0xFF71717A);

    Widget checkbox = Checkbox(
      value: value,
      onChanged: isDisabled ? null : onChanged,
      activeColor: primaryColor,
      checkColor: Colors.white,
      side: const BorderSide(color: primaryColor, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    );

    if (label != null || description != null) {
      checkbox = Row(
        crossAxisAlignment: description != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: description != null ? 2.0 : 0.0),
            child: checkbox,
          ),
          const SizedBox(width: 8),
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
                      style: const TextStyle(
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
                    style: const TextStyle(
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
      checkbox = Opacity(opacity: 0.5, child: checkbox);
    }

    return checkbox;
  }
}
