import 'package:flutter/material.dart';

enum CoreSliderSize { sm, md, lg }

class CoreSlider extends StatelessWidget {
  const CoreSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.size = CoreSliderSize.md,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.disabled = false,
    this.label,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final CoreSliderSize size;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final bool disabled;
  final String? label;

  bool get _isDisabled => disabled || onChanged == null;

  double get _trackHeight {
    return switch (size) {
      CoreSliderSize.sm => 3,
      CoreSliderSize.md => 4,
      CoreSliderSize.lg => 6,
    };
  }

  double get _thumbRadius {
    return switch (size) {
      CoreSliderSize.sm => 6,
      CoreSliderSize.md => 8,
      CoreSliderSize.lg => 10,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final active = activeColor ?? colorScheme.primary;
    final inactive = inactiveColor ?? colorScheme.surfaceContainerHighest;
    final thumb = thumbColor ?? colorScheme.primary;

    Widget slider = SliderTheme(
      data: SliderThemeData(
        trackHeight: _trackHeight,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: _thumbRadius,
          disabledThumbRadius: _thumbRadius,
          elevation: 1,
          pressedElevation: 2,
        ),
        overlayShape: RoundSliderOverlayShape(overlayRadius: _thumbRadius + 10),
        overlayColor: active.withValues(alpha: 0.12),
        activeTrackColor: active,
        inactiveTrackColor: inactive,
        thumbColor: thumb,
        disabledActiveTrackColor: active.withValues(alpha: 0.4),
        disabledInactiveTrackColor: inactive.withValues(alpha: 0.4),
        disabledThumbColor: thumb.withValues(alpha: 0.4),
        trackShape: const RoundedRectSliderTrackShape(),
        tickMarkShape: SliderTickMarkShape.noTickMark,
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: _isDisabled ? null : onChanged,
        label: label,
        padding: EdgeInsets.zero,
      ),
    );

    if (_isDisabled) {
      slider = Opacity(opacity: 0.5, child: slider);
    }

    return slider;
  }
}
