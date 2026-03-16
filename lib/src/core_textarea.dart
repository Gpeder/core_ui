import 'package:flutter/material.dart';
import 'core_input.dart';

class CoreTextArea extends StatefulWidget {
  const CoreTextArea({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.variant = CoreInputVariant.outlined,
    this.size = CoreInputSize.md,
    this.disabled = false,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.multiline,
    this.minLines = 4,
    this.maxLines,
    this.autofocus = false,
    this.radius = CoreInputRadius.md,
    this.fillColor,
    this.labelColor,
    this.hintColor,
    this.textColor,
    this.focusColor,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final CoreInputVariant variant;
  final CoreInputSize size;
  final CoreInputRadius radius;
  final bool disabled;
  final bool readOnly;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final int minLines;
  final int? maxLines;
  final bool autofocus;
  final Color? fillColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? focusColor;

  @override
  State<CoreTextArea> createState() => _CoreTextAreaState();
}

class _CoreTextAreaState extends State<CoreTextArea> {
  late TextEditingController _controller;
  bool _ownsController = false;

  Color get _border => Theme.of(context).dividerColor;
  Color get _focusBorder => widget.focusColor ?? Theme.of(context).colorScheme.primary;
  Color get _errorBorder => Theme.of(context).colorScheme.error;
  Color get _fillColor => widget.fillColor ?? Theme.of(context).colorScheme.secondary;
  Color get _textColor => widget.textColor ?? Theme.of(context).colorScheme.onSurface;
  Color get _hintColor => widget.hintColor ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
  Color get _labelColor => widget.labelColor ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
  }

  @override
  void didUpdateWidget(covariant CoreTextArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.dispose();
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
        _ownsController = false;
      } else {
        _controller = TextEditingController();
        _ownsController = true;
      }
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  double get _fontSize {
    return switch (widget.size) {
      CoreInputSize.sm => 13,
      CoreInputSize.md => 14,
      CoreInputSize.lg => 16,
    };
  }

  EdgeInsets get _contentPadding {
    return switch (widget.size) {
      CoreInputSize.sm => const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      CoreInputSize.md => const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      CoreInputSize.lg => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
    };
  }

  double get _borderRadius {
    return switch (widget.radius) {
      CoreInputRadius.sm => 8,
      CoreInputRadius.md => 12,
      CoreInputRadius.lg => 24,
    };
  }

  InputBorder _enabledBorder() {
    return switch (widget.variant) {
      CoreInputVariant.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _border, width: 1),
      ),
      CoreInputVariant.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide.none,
      ),
      CoreInputVariant.underline => UnderlineInputBorder(
        borderSide: BorderSide(color: _border, width: 1),
      ),
    };
  }

  InputBorder _focusedBorder() {
    return switch (widget.variant) {
      CoreInputVariant.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _focusBorder, width: 1.5),
      ),
      CoreInputVariant.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _focusBorder, width: 1.5),
      ),
      CoreInputVariant.underline => UnderlineInputBorder(
        borderSide: BorderSide(color: _focusBorder, width: 1.5),
      ),
    };
  }

  InputBorder _errorBorderStyle() {
    return switch (widget.variant) {
      CoreInputVariant.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _errorBorder, width: 1),
      ),
      CoreInputVariant.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _errorBorder, width: 1),
      ),
      CoreInputVariant.underline => UnderlineInputBorder(
        borderSide: BorderSide(color: _errorBorder, width: 1),
      ),
    };
  }

  InputBorder _focusedErrorBorder() {
    return switch (widget.variant) {
      CoreInputVariant.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _errorBorder, width: 1.5),
      ),
      CoreInputVariant.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: _errorBorder, width: 1.5),
      ),
      CoreInputVariant.underline => UnderlineInputBorder(
        borderSide: BorderSide(color: _errorBorder, width: 1.5),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.variant == CoreInputVariant.filled;

    final textStyle = TextStyle(
      fontSize: _fontSize,
      fontWeight: FontWeight.w400,
      color: _textColor,
      height: 1.4,
    );

    Widget field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _labelColor,
            ),
          ),
          const SizedBox(height: 10),
        ],
        TextFormField(
          controller: _controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          autofocus: widget.autofocus,
          enabled: !widget.disabled,
          readOnly: widget.readOnly,
          style: textStyle,
          cursorColor: _focusBorder,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            hintText: widget.hint,
            isDense: true,
            filled: isFilled,
            fillColor: isFilled ? _fillColor : null,
            contentPadding: _contentPadding,
            hintStyle: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w400,
              color: _hintColor,
            ),
            errorStyle: TextStyle(fontSize: _fontSize - 2, color: _errorBorder),
            enabledBorder: _enabledBorder(),
            focusedBorder: _focusedBorder(),
            errorBorder: _errorBorderStyle(),
            focusedErrorBorder: _focusedErrorBorder(),
            disabledBorder: _enabledBorder(),
          ),
        ),
      ],
    );

    if (widget.disabled) {
      field = Opacity(opacity: 0.5, child: field);
    }

    return field;
  }
}
