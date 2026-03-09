import 'package:flutter/material.dart';

class CoreCalendar extends StatefulWidget {
  const CoreCalendar({
    super.key,
    this.selected,
    this.onChanged,
    this.showOutsideDays = true,
    this.initialMonth,
    this.fromMonth,
    this.toMonth,
    this.fixedWeeks = false,
    this.weekStartsOn = DateTime.monday,
    this.selectableDayPredicate,
    this.allowDeselection = false,
    this.onMonthChanged,
    this.headerTextStyle,
    this.weekdaysTextStyle,
    this.dayTextStyle,
    this.selectedDayTextStyle,
    this.outsideDayTextStyle,
    this.todayDecoration,
    this.selectedDayDecoration,
    this.daySize = 36.0,
    this.outsideDayOpacity = 0.5,
    this.padding = const EdgeInsets.all(12),
  });

  final DateTime? selected;
  final ValueChanged<DateTime?>? onChanged;
  final bool showOutsideDays;
  final DateTime? initialMonth;
  final DateTime? fromMonth;
  final DateTime? toMonth;
  final bool fixedWeeks;
  final int weekStartsOn;
  final bool Function(DateTime day)? selectableDayPredicate;
  final bool allowDeselection;
  final ValueChanged<DateTime>? onMonthChanged;
  final TextStyle? headerTextStyle;
  final TextStyle? weekdaysTextStyle;
  final TextStyle? dayTextStyle;
  final TextStyle? selectedDayTextStyle;
  final TextStyle? outsideDayTextStyle;
  final BoxDecoration? todayDecoration;
  final BoxDecoration? selectedDayDecoration;
  final double daySize;
  final double outsideDayOpacity;
  final EdgeInsetsGeometry padding;

  @override
  State<CoreCalendar> createState() => _CoreCalendarState();
}

class _CoreCalendarState extends State<CoreCalendar> {
  late DateTime _currentMonth;
  late DateTime _today;

  @override
  void initState() {
    super.initState();
    _today = _dateOnly(DateTime.now());
    _currentMonth = _startOfMonth(widget.initialMonth ?? _today);
  }

  @override
  void didUpdateWidget(covariant CoreCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMonth != null &&
        oldWidget.initialMonth != widget.initialMonth) {
      _currentMonth = _startOfMonth(widget.initialMonth!);
    }
  }

  //* Helpers
  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime _startOfMonth(DateTime d) => DateTime(d.year, d.month);
  DateTime _endOfMonth(DateTime d) => DateTime(d.year, d.month + 1, 0);
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
  bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  bool get _canGoBack {
    if (widget.fromMonth == null) return true;
    final prev = DateTime(_currentMonth.year, _currentMonth.month - 1);
    return !prev.isBefore(_startOfMonth(widget.fromMonth!));
  }

  bool get _canGoForward {
    if (widget.toMonth == null) return true;
    final next = DateTime(_currentMonth.year, _currentMonth.month + 1);
    return !next.isAfter(_startOfMonth(widget.toMonth!));
  }

  void _goToPreviousMonth() {
    if (!_canGoBack) return;
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  void _goToNextMonth() {
    if (!_canGoForward) return;
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  List<DateTime?> _generateDates() {
    final firstOfMonth = _startOfMonth(_currentMonth);
    final lastOfMonth = _endOfMonth(_currentMonth);

    var cursor = firstOfMonth;
    while (cursor.weekday != widget.weekStartsOn) {
      cursor = cursor.subtract(const Duration(days: 1));
    }

    final dates = <DateTime?>[];
    var coveredMonth = false;

    while (!coveredMonth ||
        dates.length % 7 != 0 ||
        (widget.fixedWeeks && dates.length < 42)) {
      final isOutside = cursor.month != _currentMonth.month;

      if (isOutside && !widget.showOutsideDays) {
        dates.add(null);
      } else {
        dates.add(_dateOnly(cursor));
      }

      if (_isSameDay(cursor, lastOfMonth)) coveredMonth = true;
      cursor = cursor.add(const Duration(days: 1));
    }

    return dates;
  }

  String _monthYearLabel(DateTime d) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

  String _weekdayLabel(int weekday) {
    const labels = {
      DateTime.monday: 'Seg',
      DateTime.tuesday: 'Ter',
      DateTime.wednesday: 'Qua',
      DateTime.thursday: 'Qui',
      DateTime.friday: 'Sex',
      DateTime.saturday: 'Sáb',
      DateTime.sunday: 'Dom',
    };
    return labels[weekday] ?? '';
  }

  List<int> _weekdayOrder() {
    final order = <int>[];
    for (var i = 0; i < 7; i++) {
      var d = widget.weekStartsOn + i;
      if (d > 7) d -= 7;
      order.add(d);
    }
    return order;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = theme.colorScheme.onSurface;
    final mutedForeground = foreground.withValues(alpha: 0.5);
    final primaryColor = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;
    final borderColor = theme.dividerColor;

    final effectiveHeaderStyle = widget.headerTextStyle ??
        TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: foreground);

    final effectiveWeekdayStyle = widget.weekdaysTextStyle ??
        TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: mutedForeground);

    final effectiveDayStyle = widget.dayTextStyle ??
        TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: foreground);

    final effectiveSelectedStyle = widget.selectedDayTextStyle ??
        TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: onPrimary);

    final effectiveOutsideStyle = widget.outsideDayTextStyle ??
        TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: mutedForeground);

    final effectiveTodayDecoration = widget.todayDecoration ??
        BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        );

    final effectiveSelectedDecoration = widget.selectedDayDecoration ??
        BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(8),
        );

    final dates = _generateDates();
    final weekdays = _weekdayOrder();

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //* Header
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              height: 38,
              child: Row(
                children: [
                  _NavButton(
                    icon: Icons.chevron_left,
                    enabled: _canGoBack,
                    onPressed: _goToPreviousMonth,
                    foreground: foreground,
                    borderColor: borderColor,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _monthYearLabel(_currentMonth),
                        style: effectiveHeaderStyle,
                      ),
                    ),
                  ),
                  _NavButton(
                    icon: Icons.chevron_right,
                    enabled: _canGoForward,
                    onPressed: _goToNextMonth,
                    foreground: foreground,
                    borderColor: borderColor,
                  ),
                ],
              ),
            ),
          ),

          //* Weekday names
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: weekdays.map((wd) {
                return Expanded(
                  child: Center(
                    child: Text(
                      _weekdayLabel(wd),
                      style: effectiveWeekdayStyle,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          //* Day grid
          GridView.count(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: dates.map((date) {
              if (date == null) {
                return const SizedBox.shrink();
              }

              final isSelected =
                  widget.selected != null && _isSameDay(date, widget.selected!);
              final isToday = _isSameDay(date, _today);
              final isOutside = !_isSameMonth(date, _currentMonth);
              final isEnabled = widget.selectableDayPredicate?.call(date) ?? true;

              BoxDecoration? decoration;
              TextStyle style;

              if (isSelected) {
                decoration = effectiveSelectedDecoration;
                style = effectiveSelectedStyle;
              } else if (isToday) {
                decoration = effectiveTodayDecoration;
                style = effectiveDayStyle;
              } else {
                style = isOutside ? effectiveOutsideStyle : effectiveDayStyle;
              }

              Widget cell = Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: widget.daySize,
                  height: widget.daySize,
                  decoration: decoration,
                  alignment: Alignment.center,
                  child: Text(date.day.toString(), style: style),
                ),
              );

              if (isOutside) {
                cell = Opacity(opacity: widget.outsideDayOpacity, child: cell);
              }

              if (!isEnabled) {
                cell = Opacity(opacity: 0.35, child: cell);
              }

              return GestureDetector(
                onTap: isEnabled
                    ? () {
                        if (isSelected && widget.allowDeselection) {
                          widget.onChanged?.call(null);
                        } else {
                          widget.onChanged?.call(date);
                        }
                      }
                    : null,
                behavior: HitTestBehavior.opaque,
                child: cell,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
    required this.foreground,
    required this.borderColor,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  final Color foreground;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: SizedBox(
        width: 28,
        height: 28,
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: borderColor),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: enabled ? onPressed : null,
            child: Icon(icon, size: 16, color: foreground),
          ),
        ),
      ),
    );
  }
}
