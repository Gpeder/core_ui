import 'package:core_ui/src/core_button.dart';
import 'package:flutter/material.dart';

class MainDialog extends StatelessWidget {
  const MainDialog({
    super.key,
    required this.title,
    this.description,
    this.content,
    this.actions,
    this.cancelText,
    this.onCancel,
    this.confirmText,
    this.onConfirm,
    this.confirmVariant = CoreButtonVariant.primary,
    this.icon,
  });

  final String title;
  final String? description;
  final Widget? content;
  final List<Widget>? actions;
  final String? cancelText;
  final VoidCallback? onCancel;
  final String? confirmText;
  final VoidCallback? onConfirm;
  final CoreButtonVariant confirmVariant;
  final IconData? icon;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? description,
    Widget? content,
    List<Widget>? actions,
    String? cancelText,
    VoidCallback? onCancel,
    String? confirmText,
    VoidCallback? onConfirm,
    CoreButtonVariant confirmVariant = CoreButtonVariant.primary,
    IconData? icon,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => MainDialog(
        title: title,
        description: description,
        content: content,
        actions: actions,
        cancelText: cancelText,
        onCancel: onCancel,
        confirmText: confirmText,
        onConfirm: onConfirm,
        confirmVariant: confirmVariant,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24, color: Theme.of(context).colorScheme.onSurface),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.2,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
            ],
            if (content != null) ...[const SizedBox(height: 16), content!],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions ?? _buildDefaultActions(context),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDefaultActions(BuildContext context) {
    final List<Widget> defaultActions = [];

    if (cancelText != null) {
      defaultActions.add(
        CoreButton(
          label: cancelText!,
          variant: CoreButtonVariant.outline,
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      );
    }

    if (confirmText != null) {
      if (defaultActions.isNotEmpty) {
        defaultActions.add(const SizedBox(width: 8));
      }
      defaultActions.add(
        CoreButton(
          label: confirmText!,
          variant: confirmVariant,
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      );
    }

    return defaultActions;
  }
}
