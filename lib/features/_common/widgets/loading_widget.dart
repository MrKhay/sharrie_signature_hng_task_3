import 'package:flutter/material.dart';

import '../../features.dart';

/// Progress animation
Widget progressAnimation(BuildContext context,
    {double? size, String? progressMsg}) {
  return SizedBox(
    width: context.screenSize.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          height: size ?? context.screenSize.width * 0.1,
          width: size ?? context.screenSize.width * 0.1,
          child: const CircularProgressIndicator.adaptive(),
        ),
        if (progressMsg == null)
          const SizedBox()
        else
          const SizedBox(height: kGap_2),
        if (progressMsg == null)
          const SizedBox()
        else
          Text(
            progressMsg,
            style: context.textTheme.labelLarge?.copyWith(
              color: context.theme.hintColor,
            ),
          )
      ],
    ),
  );
}

/// Loading Dialog
void showLoadingDialog(BuildContext context, {String? progressMsg}) {
  final double width = MediaQuery.of(context).size.width;
  // ignore: discarded_futures
  showDialog<int?>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: context.colorScheme.outlineVariant,
        insetPadding: EdgeInsets.symmetric(horizontal: width * 0.4),
        child: SizedBox(
          width: width * 0.2,
          height: width * 0.2,
          child: Center(
              child: progressAnimation(
            context,
          )),
        ),
      );
    },
  ).then((_) {});
}
