import 'package:flutter/material.dart';

enum CoreIconButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
}

enum CoreIconButtonSize { sm, md, lg }

class CoreIconButton extends StatelessWidget {
  const CoreIconButton({
    super.key,
    required this.icon,
    this.label,
    this.onPressed,
    this.variant = CoreIconButtonVariant.ghost,
    this.size = CoreIconButtonSize.md,
    this.isLoading = false,
    this.disabled = false,
    this.tooltip,
    this.iconColor,
    this.borderRadius,
  });

  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final CoreIconButtonVariant variant;
  final CoreIconButtonSize size;
  final bool isLoading;
  final bool disabled;
  final String? tooltip;
  final Color? iconColor;
  final double? borderRadius;

  bool get _isDisabled => disabled || isLoading || onPressed == null;

  bool get _hasLabel => label != null && label!.isNotEmpty;

  double get _height {
    return switch (size) {
      CoreIconButtonSize.sm => 32,
      CoreIconButtonSize.md => 40,
      CoreIconButtonSize.lg => 48,
    };
  }

  double get _iconSize {
    return switch (size) {
      CoreIconButtonSize.sm => 16,
      CoreIconButtonSize.md => 20,
      CoreIconButtonSize.lg => 24,
    };
  }

  double get _fontSize {
    return switch (size) {
      CoreIconButtonSize.sm => 13,
      CoreIconButtonSize.md => 14,
      CoreIconButtonSize.lg => 16,
    };
  }

  EdgeInsetsGeometry get _padding {
    if (!_hasLabel) {
      return switch (size) {
        CoreIconButtonSize.sm => const EdgeInsets.all(6),
        CoreIconButtonSize.md => const EdgeInsets.all(8),
        CoreIconButtonSize.lg => const EdgeInsets.all(10),
      };
    }
    return switch (size) {
      CoreIconButtonSize.sm => const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      CoreIconButtonSize.md => const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      CoreIconButtonSize.lg => const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
    };
  }

  double get _borderRadiusValue => borderRadius ?? 8;
  Color _background(BuildContext context) {
    return switch (variant) {
      CoreIconButtonVariant.primary =>
        Theme.of(context).colorScheme.primary,
      CoreIconButtonVariant.secondary =>
        Theme.of(context).colorScheme.secondary,
      CoreIconButtonVariant.outline => Colors.transparent,
      CoreIconButtonVariant.ghost => Colors.transparent,
      CoreIconButtonVariant.destructive =>
        Theme.of(context).colorScheme.error,
    };
  }

  Color _foreground(BuildContext context) {
    if (iconColor != null) return iconColor!;
    return switch (variant) {
      CoreIconButtonVariant.primary =>
        Theme.of(context).colorScheme.onPrimary,
      CoreIconButtonVariant.secondary =>
        Theme.of(context).colorScheme.onSecondary,
      CoreIconButtonVariant.outline =>
        Theme.of(context).colorScheme.onSurface,
      CoreIconButtonVariant.ghost =>
        Theme.of(context).colorScheme.onSurface,
      CoreIconButtonVariant.destructive =>
        Theme.of(context).colorScheme.onError,
    };
  }

  Color? _borderColor(BuildContext context) {
    return switch (variant) {
      CoreIconButtonVariant.outline => Theme.of(context).dividerColor,
      _ => null,
    };
  }

  Color _hoverColor(BuildContext context) {
    return switch (variant) {
      CoreIconButtonVariant.primary =>
        Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
      CoreIconButtonVariant.secondary =>
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
      CoreIconButtonVariant.outline =>
        Theme.of(context).colorScheme.secondary,
      CoreIconButtonVariant.ghost =>
        Theme.of(context).colorScheme.secondary,
      CoreIconButtonVariant.destructive =>
        Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
    };
  }


  @override
  Widget build(BuildContext context) {
    final bg = _background(context);
    final fg = _foreground(context);
    final border = _borderColor(context);
    final hover = _hoverColor(context);

    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) return hover;
        return bg;
      }),
      foregroundColor: WidgetStateProperty.all(fg),
      overlayColor: WidgetStateProperty.all(
        hover.withValues(alpha: 0.1),
      ),
      elevation: WidgetStateProperty.all(0),
      padding: WidgetStateProperty.all(_padding),
      minimumSize: WidgetStateProperty.all(
        _hasLabel ? Size(0, _height) : Size(_height, _height),
      ),
      maximumSize: WidgetStateProperty.all(
        _hasLabel ? Size.infinite : Size(_height, _height),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadiusValue),
          side: border != null
              ? BorderSide(color: border, width: 1)
              : BorderSide.none,
        ),
      ),
      textStyle: WidgetStateProperty.all(
        TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
      ),
      animationDuration: const Duration(milliseconds: 150),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    final spinnerSize = _iconSize;
    Widget child;

    if (isLoading) {
      final spinner = SizedBox(
        width: spinnerSize,
        height: spinnerSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: fg,
        ),
      );

      child = _hasLabel
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                spinner,
                const SizedBox(width: 8),
                Text(label!),
              ],
            )
          : spinner;
    } else if (_hasLabel) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _iconSize),
          const SizedBox(width: 8),
          Text(label!),
        ],
      );
    } else {
      child = Icon(icon, size: _iconSize);
    }

    Widget button = ElevatedButton(
      onPressed: _isDisabled ? null : onPressed,
      style: buttonStyle,
      child: child,
    );

    if (_isDisabled && !isLoading) {
      button = Opacity(opacity: 0.5, child: button);
    }

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
