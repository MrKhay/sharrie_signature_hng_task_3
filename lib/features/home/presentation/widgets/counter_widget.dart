import 'package:flutter/material.dart';
import 'package:sharrie_signature/features/_common/constants/padding.dart';

/// Enum to define different sizes for the CounterWidget
enum CounterWidgetSize { small, medium, large }

class CounterWidget extends StatefulWidget {
  /// Initial value
  final int initialValue;

  /// Triggered when value changes
  final void Function(int)? onCountChange;

  /// Size of the counter widget
  final CounterWidgetSize size;

  ///
  const CounterWidget({
    super.key,
    this.onCountChange,
    this.initialValue = 1,
    this.size = CounterWidgetSize.medium,
  });

  /// Factory constructors for different sizes
  factory CounterWidget.small(
      {int initialValue = 1, void Function(int)? onCountChange}) {
    return CounterWidget(
      initialValue: initialValue,
      onCountChange: onCountChange,
      size: CounterWidgetSize.small,
    );
  }

  factory CounterWidget.medium(
      {int initialValue = 1, void Function(int)? onCountChange}) {
    return CounterWidget(
      initialValue: initialValue,
      onCountChange: onCountChange,
      size: CounterWidgetSize.medium,
    );
  }

  factory CounterWidget.large(
      {int initialValue = 1, void Function(int)? onCountChange}) {
    return CounterWidget(
      initialValue: initialValue,
      onCountChange: onCountChange,
      size: CounterWidgetSize.large,
    );
  }

  @override
  CounterWidgetState createState() => CounterWidgetState();
}

class CounterWidgetState extends State<CounterWidget> {
  int _count = 1;

  @override
  void initState() {
    super.initState();
    _count = widget.initialValue;
  }

  double _getSize(CounterWidgetSize size) {
    switch (size) {
      case CounterWidgetSize.small:
        return 20.0;
      case CounterWidgetSize.medium:
        return 32.0;
      case CounterWidgetSize.large:
        return 40.0;
      default:
        return 32.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = _getSize(widget.size);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(kGap_0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Decrement button
          Container(
            height: buttonSize,
            width: buttonSize,
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant),
              ),
            ),
            child: IconButton(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(0),
              onPressed: _decreaseCount,
              icon: Icon(
                Icons.remove,
                size: buttonSize / 2,
              ),
            ),
          ),
          const SizedBox(width: 8.0),

          // Count text
          Text(
            _count.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8.0),

          // Increment button
          Container(
            height: buttonSize,
            width: buttonSize,
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant),
              ),
            ),
            child: IconButton(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(0),
              onPressed: _increaseCount,
              icon: Icon(
                Icons.add,
                size: buttonSize / 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _decreaseCount() {
    // Return when count is less or equal to one
    if (_count <= 1) return;
    setState(() {
      _count--;
      widget.onCountChange?.call(_count);
    });
  }

  void _increaseCount() {
    setState(() {
      _count++;
      widget.onCountChange?.call(_count);
    });
  }
}
