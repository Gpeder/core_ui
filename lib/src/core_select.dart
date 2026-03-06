import 'package:core_ui/src/core_input.dart';
import 'package:flutter/material.dart';

class CoreSelect<T> extends StatelessWidget {
  const CoreSelect({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.variant = CoreInputVariant.outlined,
    this.size = CoreInputSize.md,
    this.disabled = false,
    this.prefixIcon,
    this.validator,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final CoreInputVariant variant;
  final CoreInputSize size;
  final bool disabled;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;
  static const _border = Color(0xFFE4E4E7);
  static const _focusBorder = Color(0xFF18181B);
  static const _errorBorder = Color(0xFFEF4444);
  static const _fillColor = Color(0xFFF4F4F5);
  static const _textColor = Color(0xFF18181B);
  static const _hintColor = Color(0xFFA1A1AA);
  static const _labelColor = Color(0xFF71717A);

  double get _fontSize {
    return switch (size) {
      CoreInputSize.sm => 13,
      CoreInputSize.md => 14,
      CoreInputSize.lg => 16,
    };
  }

  double get _iconSize {
    return switch (size) {
      CoreInputSize.sm => 16,
      CoreInputSize.md => 18,
      CoreInputSize.lg => 20,
    };
  }

  EdgeInsets get _contentPadding {
    return switch (size) {
      CoreInputSize.sm => const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      CoreInputSize.md => const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      CoreInputSize.lg => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    };
  }

  double get _borderRadius => 8;

  InputBorder _enabledBorder() {
    return switch (variant) {
      CoreInputVariant.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: _border, width: 1),
      ),
      CoreInputVariant.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide.none,
      ),
      CoreInputVariant.underline => const UnderlineInputBorder(
        borderSide: BorderSide(color: _border, width: 1),
      ),
    };
  }

  InputBorder _focusedBorder() {
    return switch (variant) {
      CoreInputVariant.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: _focusBorder, width: 1.5),
      ),
      CoreInputVariant.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: _focusBorder, width: 1.5),
      ),
      CoreInputVariant.underline => const UnderlineInputBorder(
        borderSide: BorderSide(color: _focusBorder, width: 1.5),
      ),
    };
  }

  InputBorder _errorBorderStyle() {
    return switch (variant) {
      CoreInputVariant.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: _errorBorder, width: 1),
      ),
      CoreInputVariant.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: _errorBorder, width: 1),
      ),
      CoreInputVariant.underline => const UnderlineInputBorder(
        borderSide: BorderSide(color: _errorBorder, width: 1),
      ),
    };
  }

  InputBorder _focusedErrorBorder() {
    return switch (variant) {
      CoreInputVariant.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: _errorBorder, width: 1.5),
      ),
      CoreInputVariant.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: _errorBorder, width: 1.5),
      ),
      CoreInputVariant.underline => const UnderlineInputBorder(
        borderSide: BorderSide(color: _errorBorder, width: 1.5),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = variant == CoreInputVariant.filled;
    final effectiveDisabled = disabled || onChanged == null;

    final textStyle = TextStyle(
      fontSize: _fontSize,
      fontWeight: FontWeight.w400,
      color: _textColor,
      height: 1.4,
    );

    Widget field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _labelColor,
          )),
          const SizedBox(height: 10),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: effectiveDisabled ? null : onChanged,
          validator: validator,
          style: textStyle,
          icon: Icon(Icons.unfold_more, size: _iconSize, color: _hintColor),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(_borderRadius),
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            filled: isFilled,
            fillColor: isFilled ? _fillColor : null,
            contentPadding: _contentPadding,
            hintStyle: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w400,
              color: _hintColor,
            ),
            errorStyle: TextStyle(
              fontSize: _fontSize - 2,
              color: _errorBorder,
            ),
            enabledBorder: _enabledBorder(),
            focusedBorder: _focusedBorder(),
            errorBorder: _errorBorderStyle(),
            focusedErrorBorder: _focusedErrorBorder(),
            disabledBorder: _enabledBorder(),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: _iconSize, color: _hintColor)
                : null,
          ),
        ),
      ],
    );

    // opacidade para disabled
    if (effectiveDisabled) {
      field = Opacity(opacity: 0.5, child: field);
    }

    return field;
  }
}
