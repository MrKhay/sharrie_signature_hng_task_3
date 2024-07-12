import 'package:flutter/material.dart';

import '../../../features.dart';

///
class CounterWidget extends StatefulWidget {
  /// Inital value
  int initalValue;

  /// triggered when value changes
  void Function(int)? onCountChange;

  ///
  CounterWidget({
    super.key,
    this.onCountChange,
    this.initalValue = 1,
  });

  @override
  CounterWidgetState createState() => CounterWidgetState();
}

///
class CounterWidgetState extends State<CounterWidget> {
  int _count = 1;
  @override
  void initState() {
    super.initState();
    _count = widget.initalValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kGap_0),
      decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(kGap_4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // decrement btn
          SizedBox(
            height: context.textTheme.headlineMedium?.fontSize,
            width: context.textTheme.headlineMedium?.fontSize,
            child: IconButton.outlined(
              padding: const EdgeInsets.all(kGap_0),
              onPressed: _decreaseCount,
              icon: Icon(
                Icons.remove,
                size: context.textTheme.bodyLarge?.fontSize,
              ),
            ),
          ),
          const SizedBox(width: kGap_1),

          // count txt
          Text(
            _count.toString(),
            style: context.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: kGap_1),

          // increment btn
          SizedBox(
            height: context.textTheme.headlineMedium?.fontSize,
            width: context.textTheme.headlineMedium?.fontSize,
            child: IconButton.filled(
              padding: const EdgeInsets.all(kGap_0),
              onPressed: _increaseCount,
              icon: Icon(
                Icons.add,
                size: context.textTheme.bodyLarge?.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _decreaseCount() {
    // return when count is less or equal to one
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
