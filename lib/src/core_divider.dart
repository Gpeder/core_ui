import 'package:flutter/material.dart';

enum CoreDividerVariant { horizontal, vertical }

class CoreDivider extends StatelessWidget {
  const CoreDivider.horizontal({
    super.key,
    this.margin,
    this.thickness,
    this.color,
    this.radius,
  }) : variant = CoreDividerVariant.horizontal;

  const CoreDivider.vertical({
    super.key,
    this.margin,
    this.thickness,
    this.color,
    this.radius,
  }) : variant = CoreDividerVariant.vertical;

  const CoreDivider.raw({
    super.key,
    required this.variant,
    this.margin,
    this.thickness,
    this.color,
    this.radius,
  });

  final CoreDividerVariant variant;
  final EdgeInsetsGeometry? margin;
  final double? thickness;
  final Color? color;
  final BorderRadiusGeometry? radius;

  @override
  Widget build(BuildContext context) {
    final effectiveThickness = thickness ?? 1.0;
    final effectiveColor = color ?? Theme.of(context).dividerColor;

    final borderSide = BorderSide(
      color: effectiveColor,
      width: effectiveThickness,
    );

    final effectiveMargin = margin ?? EdgeInsets.zero;

    return Padding(
      padding: effectiveMargin,
      child: switch (variant) {
        CoreDividerVariant.horizontal => DecoratedBox(
          decoration: BoxDecoration(
            border: Border(bottom: borderSide),
            borderRadius: radius,
          ),
          child: SizedBox(height: effectiveThickness, width: double.infinity),
        ),
        CoreDividerVariant.vertical => DecoratedBox(
          decoration: BoxDecoration(
            border: Border(left: borderSide),
            borderRadius: radius,
          ),
          child: SizedBox(width: effectiveThickness, height: double.infinity),
        ),
      },
    );
  }
}
