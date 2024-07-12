import 'package:flutter/material.dart';

import '../../features.dart';

/// Error widget
Widget errorWidget(
    {required BuildContext context,
    void Function()? retry,
    String errorMsg = kSomethingWentWrong}) {
  return SizedBox(
    width: context.screenSize.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(errorMsg),
        const SizedBox(height: kGap_2),
        OutlinedButton(
          onPressed: retry,
          child: Text(
            kRetry,
            style: context.textTheme.bodyLarge,
          ),
        )
      ],
    ),
  );
}
