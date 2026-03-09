import 'package:core_ui/src/core_calendar.dart';
import 'package:flutter/material.dart';

class CoreDatePicker extends StatefulWidget {
  const CoreDatePicker({
    super.key,
    this.selected,
    this.onChanged,
    this.placeholder,
    this.formatDate,
    this.allowDeselection = true,
    this.closeOnSelection = true,
    this.header,
    this.footer,
    this.iconData,
    this.showOutsideDays = true,
    this.initialMonth,
    this.fromMonth,
    this.toMonth,
    this.fixedWeeks = false,
    this.weekStartsOn = DateTime.monday,
    this.selectableDayPredicate,
    this.onMonthChanged,
    this.width = 276,
    this.buttonPadding,
    this.popoverConstraints,
  });

  final DateTime? selected;
  final ValueChanged<DateTime?>? onChanged;
  final Widget? placeholder;
  final String Function(DateTime date)? formatDate;
  final bool allowDeselection;
  final bool closeOnSelection;
  final Widget? header;
  final Widget? footer;
  final IconData? iconData;
  final bool showOutsideDays;
  final DateTime? initialMonth;
  final DateTime? fromMonth;
  final DateTime? toMonth;
  final bool fixedWeeks;
  final int weekStartsOn;
  final bool Function(DateTime day)? selectableDayPredicate;
  final ValueChanged<DateTime>? onMonthChanged;
  final double? width;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxConstraints? popoverConstraints;

  @override
  State<CoreDatePicker> createState() => _CoreDatePickerState();
}

class _CoreDatePickerState extends State<CoreDatePicker> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggle() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_isOpen) setState(() => _isOpen = false);
  }

  void _showOverlay() {
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  String _defaultFormat(DateTime d) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
    ];
    return '${d.day} de ${months[d.month - 1]} de ${d.year}';
  }

  OverlayEntry _buildOverlay() {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            //* tap to close
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeOverlay,
              ),
            ),

            //* Popover
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 4),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surface,
                shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.15),
                child: ConstrainedBox(
                  constraints: widget.popoverConstraints ??
                      const BoxConstraints(maxWidth: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.header != null) widget.header!,
                      CoreCalendar(
                        selected: widget.selected,
                        initialMonth: widget.initialMonth,
                        fromMonth: widget.fromMonth,
                        toMonth: widget.toMonth,
                        showOutsideDays: widget.showOutsideDays,
                        fixedWeeks: widget.fixedWeeks,
                        weekStartsOn: widget.weekStartsOn,
                        selectableDayPredicate: widget.selectableDayPredicate,
                        allowDeselection: widget.allowDeselection,
                        onMonthChanged: widget.onMonthChanged,
                        onChanged: (date) {
                          widget.onChanged?.call(date);
                          if (widget.closeOnSelection) {
                            _removeOverlay();
                          }
                        },
                      ),
                      if (widget.footer != null) widget.footer!,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelection = widget.selected != null;
    final foreground = theme.colorScheme.onSurface;
    final mutedForeground = foreground.withValues(alpha: 0.5);
    final borderColor = theme.dividerColor;

    final format = widget.formatDate ?? _defaultFormat;
    final effectiveIcon = widget.iconData ?? Icons.calendar_today;

    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: widget.width,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _toggle,
            child: Container(
              padding: widget.buttonPadding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Icon(
                    effectiveIcon,
                    size: 16,
                    color: hasSelection ? foreground : mutedForeground,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: hasSelection
                        ? Text(
                            format(widget.selected!),
                            style: TextStyle(
                              fontSize: 14,
                              color: foreground,
                            ),
                          )
                        : widget.placeholder ??
                            Text(
                              'Selecione uma data',
                              style: TextStyle(
                                fontSize: 14,
                                color: mutedForeground,
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
