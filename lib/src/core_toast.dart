import 'package:flutter/material.dart';

enum CoreToastVariant { defaultToast, destructive, success }

class CoreToast {
  static void show({
    required BuildContext context,
    required String title,
    String? description,
    CoreToastVariant variant = CoreToastVariant.defaultToast,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final Color backgroundColor;
    final Color textColor;
    final Color descriptionColor;
    final Color borderColor;
    final Color iconColor;
    final Color actionTextColor;
    final Color actionBackgroundColor;
    final Color actionBorderColor;

    switch (variant) {
      case CoreToastVariant.destructive:
        backgroundColor = Theme.of(context).colorScheme.error;
        textColor = Theme.of(context).colorScheme.onError;
        descriptionColor = Theme.of(context).colorScheme.onError.withValues(alpha: 0.9);
        borderColor = Theme.of(context).colorScheme.error;
        iconColor = Theme.of(context).colorScheme.onError;
        actionTextColor = Theme.of(context).colorScheme.onError;
        actionBackgroundColor = Theme.of(context).colorScheme.surface.withValues(alpha: 0.0);
        actionBorderColor = Theme.of(context).colorScheme.onError.withValues(alpha: 0.2);
        break;
      case CoreToastVariant.success:
        backgroundColor = Colors.green;
        textColor = Theme.of(context).colorScheme.onPrimary;
        descriptionColor = Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.9);
        borderColor = Colors.green;
        iconColor = Theme.of(context).colorScheme.onPrimary;
        actionTextColor = Theme.of(context).colorScheme.onPrimary;
        actionBackgroundColor = Theme.of(context).colorScheme.surface.withValues(alpha: 0.0);
        actionBorderColor = Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.2);
        break;
      case CoreToastVariant.defaultToast:
        backgroundColor = Theme.of(context).colorScheme.surface;
        textColor = Theme.of(context).colorScheme.onSurface;
        descriptionColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
        borderColor = Theme.of(context).dividerColor;
        iconColor = Theme.of(context).colorScheme.onSurface;
        actionTextColor = Theme.of(context).colorScheme.onSurface;
        actionBackgroundColor = Theme.of(context).colorScheme.surface.withValues(alpha: 0.0);
        actionBorderColor = Theme.of(context).dividerColor;
        break;
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    scaffoldMessenger.hideCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        elevation: 2,
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        padding: const EdgeInsets.all(16),
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColor, width: 1),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      height: 1.2,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
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
            if (actionLabel != null) ...[
              const SizedBox(width: 12),
              SizedBox(
                height: 32,
                child: TextButton(
                  onPressed: () {
                    scaffoldMessenger.hideCurrentSnackBar();
                    if (onAction != null) {
                      onAction();
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: actionTextColor,
                    backgroundColor: actionBackgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: actionBorderColor, width: 1),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: Text(actionLabel),
                ),
              ),
            ],
            if (actionLabel == null) ...[
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => scaffoldMessenger.hideCurrentSnackBar(),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: descriptionColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
