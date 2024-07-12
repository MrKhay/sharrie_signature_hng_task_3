import 'package:flutter/material.dart';
import '../../features.dart';

/// returns true when accepted and false when not
Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String titleText,
  Color? actionBtnColor,
  Color? actionTxtColor,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: context.colorScheme.outlineVariant,
      content: Text(titleText,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          )),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            kNo,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ),
        MaterialButton(
          color: actionBtnColor ?? context.colorScheme.error,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            kYes,
            style: context.textTheme.bodyLarge?.copyWith(
              color: actionTxtColor ?? context.colorScheme.onError,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
