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
    this.radius = CoreInputRadius.md,
    this.disabled = false,
    this.prefixIcon,
    this.validator,
    this.fillColor,
    this.iconColor,
    this.labelColor,
    this.hintColor,
    this.textColor,
    this.focusColor,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final CoreInputVariant variant;
  final CoreInputSize size;
  final CoreInputRadius radius;
  final bool disabled;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;
  final Color? fillColor;
  final Color? iconColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? focusColor;

  Color _borderColor(BuildContext context) => Theme.of(context).dividerColor;
  Color _focusBorderColor(BuildContext context) => focusColor ?? Theme.of(context).colorScheme.primary;
  Color _errorBorderColor(BuildContext context) => Theme.of(context).colorScheme.error;
  Color _fillColorVal(BuildContext context) => fillColor ?? Theme.of(context).colorScheme.secondary;
  Color _textColorVal(BuildContext context) => textColor ?? Theme.of(context).colorScheme.onSurface;
  Color _hintColorVal(BuildContext context) => hintColor ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
  Color _labelColorVal(BuildContext context) => labelColor ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
  Color _iconColorVal(BuildContext context) => iconColor ?? _hintColorVal(context);

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

  double get _borderRadius {
    return switch (radius) {
      CoreInputRadius.sm => 8,
      CoreInputRadius.md => 12,
      CoreInputRadius.lg => 24,
    };
  }

  InputBorder _enabledBorder(BuildContext context) {
    return switch (variant) {
      CoreInputVariant.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _borderColor(context), width: 1),
      ),
      CoreInputVariant.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide.none,
      ),
      CoreInputVariant.underline => UnderlineInputBorder(
        borderSide: BorderSide(color: _borderColor(context), width: 1),
      ),
    };
  }

  InputBorder _focusedBorder(BuildContext context) {
    return switch (variant) {
      CoreInputVariant.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _focusBorderColor(context), width: 1.5),
      ),
      CoreInputVariant.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _focusBorderColor(context), width: 1.5),
      ),
      CoreInputVariant.underline => UnderlineInputBorder(
        borderSide: BorderSide(color: _focusBorderColor(context), width: 1.5),
      ),
    };
  }

  InputBorder _errorBorderStyle(BuildContext context) {
    return switch (variant) {
      CoreInputVariant.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _errorBorderColor(context), width: 1),
      ),
      CoreInputVariant.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _errorBorderColor(context), width: 1),
      ),
      CoreInputVariant.underline => UnderlineInputBorder(
        borderSide: BorderSide(color: _errorBorderColor(context), width: 1),
      ),
    };
  }

  InputBorder _focusedErrorBorder(BuildContext context) {
    return switch (variant) {
      CoreInputVariant.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _errorBorderColor(context), width: 1.5),
      ),
      CoreInputVariant.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _errorBorderColor(context), width: 1.5),
      ),
      CoreInputVariant.underline => UnderlineInputBorder(
        borderSide: BorderSide(color: _errorBorderColor(context), width: 1.5),
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
      color: _textColorVal(context),
      height: 1.4,
    );

    Widget field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _labelColorVal(context),
          )),
          const SizedBox(height: 10),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: effectiveDisabled ? null : onChanged,
          validator: validator,
          style: textStyle,
          icon: Icon(Icons.unfold_more, size: _iconSize, color: _iconColorVal(context)),
          dropdownColor: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(_borderRadius),
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            filled: isFilled,
            fillColor: isFilled ? _fillColorVal(context) : null,
            contentPadding: _contentPadding,
            hintStyle: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w400,
              color: _hintColorVal(context),
            ),
            errorStyle: TextStyle(
              fontSize: _fontSize - 2,
              color: _errorBorderColor(context),
            ),
            enabledBorder: _enabledBorder(context),
            focusedBorder: _focusedBorder(context),
            errorBorder: _errorBorderStyle(context),
            focusedErrorBorder: _focusedErrorBorder(context),
            disabledBorder: _enabledBorder(context),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: _iconSize, color: _iconColorVal(context))
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
