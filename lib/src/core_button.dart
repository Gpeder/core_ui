import 'package:flutter/material.dart';

enum CoreButtonVariant { primary, secondary, outline, ghost, destructive, link }

enum CoreButtonSize { sm, md, lg, icon }

class CoreButton extends StatelessWidget {
  const CoreButton({
    super.key,
    this.label,
    this.onPressed,
    this.variant = CoreButtonVariant.primary,
    this.size = CoreButtonSize.md,
    this.isLoading = false,
    this.disabled = false,
    this.icon,
    this.suffixIcon,
    this.fullWidth = false,
  });

  final String? label;
  final VoidCallback? onPressed;
  final CoreButtonVariant variant;
  final CoreButtonSize size;
  final bool isLoading;
  final bool disabled;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool fullWidth;
  bool get _isDisabled => disabled || isLoading || onPressed == null;

  double get _height {
    return switch (size) {
      CoreButtonSize.sm => 36,
      CoreButtonSize.md => 40,
      CoreButtonSize.lg => 48,
      CoreButtonSize.icon => 40,
    };
  }

  double get _iconSize {
    return switch (size) {
      CoreButtonSize.sm => 14,
      CoreButtonSize.md => 16,
      CoreButtonSize.lg => 18,
      CoreButtonSize.icon => 18,
    };
  }

  double get _fontSize {
    return switch (size) {
      CoreButtonSize.sm => 13,
      CoreButtonSize.md => 14,
      CoreButtonSize.lg => 16,
      CoreButtonSize.icon => 14,
    };
  }

  EdgeInsetsGeometry get _padding {
    return switch (size) {
      CoreButtonSize.sm => const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      CoreButtonSize.md => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      CoreButtonSize.lg => const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      CoreButtonSize.icon => const EdgeInsets.all(10),
    };
  }

  double get _borderRadius => 8;

  //cores do botão
  Color _background(BuildContext context) {
    return switch (variant) {
      CoreButtonVariant.primary => Theme.of(context).colorScheme.primary,
      CoreButtonVariant.secondary => Theme.of(context).colorScheme.secondary,
      CoreButtonVariant.outline => Colors.transparent,
      CoreButtonVariant.ghost => Colors.transparent,
      CoreButtonVariant.destructive => Theme.of(context).colorScheme.error,
      CoreButtonVariant.link => Colors.transparent,
    };
  }

  Color _foreground(BuildContext context) {
    return switch (variant) {
      CoreButtonVariant.primary => Theme.of(context).colorScheme.onPrimary,
      CoreButtonVariant.secondary => Theme.of(context).colorScheme.onSecondary,
      CoreButtonVariant.outline => Theme.of(context).colorScheme.onSurface,
      CoreButtonVariant.ghost => Theme.of(context).colorScheme.onSurface,
      CoreButtonVariant.destructive => Theme.of(context).colorScheme.onError,
      CoreButtonVariant.link => Theme.of(context).colorScheme.primary,
    };
  }

  Color? _borderColor(BuildContext context) {
    return switch (variant) {
      CoreButtonVariant.outline => Theme.of(context).dividerColor,
      _ => null,
    };
  }

  //cores hover
  Color _hoverColor(BuildContext context) {
    return switch (variant) {
      CoreButtonVariant.primary => Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
      CoreButtonVariant.secondary => Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
      CoreButtonVariant.outline => Theme.of(context).colorScheme.secondary,
      CoreButtonVariant.ghost => Theme.of(context).colorScheme.secondary,
      CoreButtonVariant.destructive => Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
      CoreButtonVariant.link => Colors.transparent,
    };
  }

  @override
  Widget build(BuildContext context) {
    final bg = _background(context);
    final fg = _foreground(context);
    final border = _borderColor(context);
    final hover = _hoverColor(context);
    final isLink = variant == CoreButtonVariant.link;

    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) return hover;
        return bg;
      }),
      foregroundColor: WidgetStateProperty.all(fg),
      overlayColor: WidgetStateProperty.all(hover.withValues(alpha: 0.1)),
      elevation: WidgetStateProperty.all(0),
      padding: WidgetStateProperty.all(_padding),
      minimumSize: WidgetStateProperty.all(
        size == CoreButtonSize.icon ? Size(_height, _height) : Size(0, _height),
      ),
      maximumSize: WidgetStateProperty.all(
        size == CoreButtonSize.icon ? Size(_height, _height) : Size.infinite,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          side: border != null
              ? BorderSide(color: border, width: 1)
              : BorderSide.none,
        ),
      ),
      textStyle: WidgetStateProperty.all(
        TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.w500,
          decoration: isLink ? TextDecoration.underline : TextDecoration.none,
          height: 1.2,
        ),
      ),
      animationDuration: const Duration(milliseconds: 150),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );


    final spinnerSize = _iconSize + 2;
    final spinnerColor = fg;

    Widget child;

    if (size == CoreButtonSize.icon) {
      child = isLoading
          ? SizedBox(
              width: spinnerSize,
              height: spinnerSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: spinnerColor,
              ),
            )
          : Icon(icon ?? Icons.circle, size: _iconSize);
    } else {
      // Botão + label
      final List<Widget> children = [];

      // Loading ou icone
      if (isLoading) {
        children.add(
          SizedBox(
            width: spinnerSize,
            height: spinnerSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: spinnerColor,
            ),
          ),
        );
        children.add(const SizedBox(width: 8));
      } else if (icon != null) {
        children.add(Icon(icon, size: _iconSize));
        children.add(const SizedBox(width: 8));
      }

      // Label
      if (label != null) {
        children.add(
          Text(
            label!,
            style: isLink
                ? TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: fg,
                  )
                : null,
          ),
        );
      }

      // Suffix icon
      if (suffixIcon != null && !isLoading) {
        children.add(const SizedBox(width: 8));
        children.add(Icon(suffixIcon, size: _iconSize));
      }

      child = Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    Widget button;

    if (isLink) {
      button = TextButton(
        onPressed: _isDisabled ? null : onPressed,
        style: buttonStyle,
        child: child,
      );
    } else {
      button = ElevatedButton(
        onPressed: _isDisabled ? null : onPressed,
        style: buttonStyle,
        child: child,
      );
    }

    // Opacidade para desabilitado
    if (_isDisabled && !isLoading) {
      button = Opacity(opacity: 0.5, child: button);
    }

    // Largura total
    if (fullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}