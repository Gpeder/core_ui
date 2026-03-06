import 'package:flutter/material.dart';

enum CoreInputVariant { outlined, filled, underline }

enum CoreInputSize { sm, md, lg }

class PasswordRule {
  final String label;
  final bool Function(String value) check;

  const PasswordRule({required this.label, required this.check});
}

class CoreInput extends StatefulWidget {
  const CoreInput({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.variant = CoreInputVariant.outlined,
    this.size = CoreInputSize.md,
    this.disabled = false,
    this.readOnly = false,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
    this.autofocus = false,
    this.passwordRules,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final CoreInputVariant variant;
  final CoreInputSize size;
  final bool disabled;
  final bool readOnly;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool autofocus;
  final List<PasswordRule>? passwordRules;

  @override
  State<CoreInput> createState() => _CoreInputState();
}

class _CoreInputState extends State<CoreInput> {
  late TextEditingController _controller;
  bool _ownsController = false;
  String _currentValue = '';

  Color get _border => Theme.of(context).dividerColor;
  Color get _focusBorder => Theme.of(context).colorScheme.primary;
  Color get _errorBorder => Theme.of(context).colorScheme.error;
  Color get _fillColor => Theme.of(context).colorScheme.secondary;
  Color get _textColor => Theme.of(context).colorScheme.onSurface;
  Color get _hintColor => Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
  Color get _labelColor => Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
  Color get _successColor => Colors.green;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
    _currentValue = _controller.text;
    if (_hasRules) {
      _controller.addListener(_onTextChanged);
    }
  }

  @override
  void didUpdateWidget(covariant CoreInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.removeListener(_onTextChanged);
        _controller.dispose();
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
        _ownsController = false;
      } else {
        _controller = TextEditingController();
        _ownsController = true;
      }
      _currentValue = _controller.text;
      if (_hasRules) {
        _controller.addListener(_onTextChanged);
      }
    }
  }

  @override
  void dispose() {
    if (_hasRules) {
      _controller.removeListener(_onTextChanged);
    }
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  bool get _hasRules =>
      widget.passwordRules != null && widget.passwordRules!.isNotEmpty;

  void _onTextChanged() {
    setState(() {
      _currentValue = _controller.text;
    });
  }

  double get _fontSize {
    return switch (widget.size) {
      CoreInputSize.sm => 13,
      CoreInputSize.md => 14,
      CoreInputSize.lg => 16,
    };
  }

  double get _iconSize {
    return switch (widget.size) {
      CoreInputSize.sm => 16,
      CoreInputSize.md => 18,
      CoreInputSize.lg => 20,
    };
  }

  EdgeInsets get _contentPadding {
    return switch (widget.size) {
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

  // bordas por variante
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
        Text(
          widget.label ?? '',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _labelColor,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          autofocus: widget.autofocus,
          enabled: !widget.disabled,
          readOnly: widget.readOnly,
          style: textStyle,
          cursorColor: _focusBorder,
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
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: _iconSize, color: _hintColor)
                : null,
            suffixIcon: widget.suffixIcon != null
                ? GestureDetector(
                    onTap: widget.onSuffixTap,
                    child: Icon(
                      widget.suffixIcon,
                      size: _iconSize,
                      color: _hintColor,
                    ),
                  )
                : null,
          ),
        ),
        if (_hasRules) ...[
          const SizedBox(height: 12),
          ...widget.passwordRules!.map((rule) {
            final passed =
                _currentValue.isNotEmpty && rule.check(_currentValue);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: passed ? _successColor : _border,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    rule.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: passed ? _successColor : _hintColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );

    // opacidade para disabled
    if (widget.disabled) {
      field = Opacity(opacity: 0.5, child: field);
    }

    return field;
  }
}
