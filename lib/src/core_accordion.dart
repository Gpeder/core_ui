import 'package:flutter/material.dart';


enum CoreAccordionVariant { single, multiple }

class CoreAccordionController<T> extends ValueNotifier<List<T>> {
  CoreAccordionController([T? value])
      : _variant = CoreAccordionVariant.single,
        super(List<T>.unmodifiable([?value]));

  CoreAccordionController.multiple([List<T>? value])
      : _variant = CoreAccordionVariant.multiple,
        super(List<T>.unmodifiable(value ?? <T>[]));

  final CoreAccordionVariant _variant;

  @override
  set value(List<T> newValue) {
    super.value = List<T>.unmodifiable(newValue);
  }

  void toggle(T v) {
    switch (_variant) {
      case CoreAccordionVariant.single:
        if (value.contains(v)) {
          value = <T>[];
        } else {
          value = <T>[v];
        }
      case CoreAccordionVariant.multiple:
        if (value.contains(v)) {
          value = value.toList()..remove(v);
        } else {
          value = value.toList()..add(v);
        }
    }
  }
}


class _CoreAccordionScope<T> extends InheritedNotifier<CoreAccordionController<T>> {
  const _CoreAccordionScope({
    required CoreAccordionController<T> controller,
    required this.maintainState,
    required super.child,
  }) : super(notifier: controller);

  final bool maintainState;

  static _CoreAccordionScope<T> of<T>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_CoreAccordionScope<T>>();
    assert(scope != null, 'No CoreAccordion<$T> found in context');
    return scope!;
  }
}



class CoreAccordion<T> extends StatefulWidget {
  CoreAccordion({
    super.key,
    required this.children,
    T? initialValue,
    this.maintainState = false,
    this.controller,
  })  : variant = CoreAccordionVariant.single,
        initialValue = <T>[?initialValue],
        assert(
          controller == null || controller._variant == CoreAccordionVariant.single,
          'Pass a single-mode CoreAccordionController to CoreAccordion(...)',
        );

  CoreAccordion.multiple({
    super.key,
    required this.children,
    this.initialValue,
    this.maintainState = false,
    this.controller,
  })  : variant = CoreAccordionVariant.multiple,
        assert(
          controller == null || controller._variant == CoreAccordionVariant.multiple,
          'Pass a multiple-mode CoreAccordionController to CoreAccordion.multiple(...)',
        );

  final CoreAccordionVariant variant;
  final List<Widget> children;
  final List<T>? initialValue;
  final bool maintainState;
  final CoreAccordionController<T>? controller;

  @override
  State<CoreAccordion<T>> createState() => _CoreAccordionState<T>();
}

class _CoreAccordionState<T> extends State<CoreAccordion<T>> {
  CoreAccordionController<T>? _controller;

  CoreAccordionController<T> get _effectiveController {
    if (widget.controller != null) return widget.controller!;
    return _controller ??= _createInternalController();
  }

  CoreAccordionController<T> _createInternalController() {
    return switch (widget.variant) {
      CoreAccordionVariant.single => CoreAccordionController<T>(
          widget.initialValue != null && widget.initialValue!.isNotEmpty
              ? widget.initialValue!.first
              : null,
        ),
      CoreAccordionVariant.multiple =>
        CoreAccordionController<T>.multiple(widget.initialValue),
    };
  }

  @override
  void didUpdateWidget(covariant CoreAccordion<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == null && widget.controller != null) {
      _controller?.dispose();
      _controller = null;
    }
    if ((oldWidget.controller != null && widget.controller == null) ||
        (oldWidget.variant != widget.variant && widget.controller == null)) {
      _controller?.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CoreAccordionScope<T>(
      controller: _effectiveController,
      maintainState: widget.maintainState,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: widget.children,
      ),
    );
  }
}



class CoreAccordionItem<T> extends StatefulWidget {
  const CoreAccordionItem({
    super.key,
    required this.value,
    required this.title,
    required this.child,
    this.separator,
    this.icon,
    this.padding,
    this.underlineTitleOnHover = true,
    this.titleStyle,
    this.curve = const Cubic(0.87, 0, 0.13, 1),
    this.duration = const Duration(milliseconds: 300),
  });

  final T value;
  final Widget title;
  final Widget child;
  final Widget? separator;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final bool underlineTitleOnHover;
  final TextStyle? titleStyle;
  final Curve curve;
  final Duration duration;

  @override
  State<CoreAccordionItem<T>> createState() => _CoreAccordionItemState<T>();
}

class _CoreAccordionItemState<T> extends State<CoreAccordionItem<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _expandAnimation;
  late final Animation<double> _iconTurnAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: widget.curve,
    );
    _iconTurnAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animController, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap(CoreAccordionController<T> controller) {
    controller.toggle(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final scope = _CoreAccordionScope.of<T>(context);
    final controller = scope.notifier!;
    final maintainState = scope.maintainState;

    final theme = Theme.of(context);
    final borderColor = theme.dividerColor;
    final foregroundColor = theme.colorScheme.onSurface;

    final effectivePadding =
        widget.padding ?? const EdgeInsets.symmetric(vertical: 16);

    final effectiveTitleStyle = widget.titleStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: foregroundColor,
        );

    final effectiveIcon = widget.icon ??
        Icon(Icons.keyboard_arrow_down, size: 18, color: foregroundColor);

    final effectiveSeparator =
        widget.separator ?? Divider(height: 1, color: borderColor);

    return ValueListenableBuilder<List<T>>(
      valueListenable: controller,
      builder: (context, expandedValues, _) {
        final expanded = expandedValues.contains(widget.value);

        if (expanded && !_animController.isCompleted) {
          _animController.forward();
        } else if (!expanded && !_animController.isDismissed) {
          _animController.reverse();
        }

        final closed = !expanded && _animController.isDismissed;
        final shouldRemoveChild = closed && !maintainState;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //* Header
            InkWell(
              onTap: () => _handleTap(controller),
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onHover: (hovering) => setState(() => _isHovered = hovering),
              child: Padding(
                padding: effectivePadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: effectiveTitleStyle.copyWith(
                          decoration:
                              _isHovered && widget.underlineTitleOnHover
                                  ? TextDecoration.underline
                                  : null,
                        ),
                        child: widget.title,
                      ),
                    ),
                    RotationTransition(
                      turns: _iconTurnAnimation,
                      child: effectiveIcon,
                    ),
                  ],
                ),
              ),
            ),

            //* Content
            if (!shouldRemoveChild)
              SizeTransition(
                sizeFactor: _expandAnimation,
                axisAlignment: -1.0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: widget.child,
                ),
              ),

            //* Separator
            effectiveSeparator,
          ],
        );
      },
    );
  }
}
