import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features.dart';

/// Widget that shows divided undernet appbar
PreferredSizeWidget bottomDivider(BuildContext context) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
          color: context.colorScheme.outlineVariant,
          width: 0.1,
        )),
      ));
}

/// Custom Appbar Widget
PreferredSizeWidget appBar({
  required BuildContext context,
  String? title,
  TextStyle? style,
  List<Widget>? actions,
  PreferredSizeWidget? bottom,
  bool? centerTitle,
  Color? backgroundColor,
  double? elevation,
  double? scrolledUnderElevation,
  SystemUiOverlayStyle? systemOverlayStyle,
  Widget? leading,
}) {
  return AppBar(
    leading: leading,
    elevation: elevation,
    scrolledUnderElevation: 0,
    backgroundColor: backgroundColor,
    systemOverlayStyle: systemOverlayStyle,
    title: Text(
      title ?? '',
      style: style ??
          context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    ),
    bottom: bottom ?? bottomDivider(context),
    actions: actions,
    centerTitle: centerTitle,
  );
}

Widget logo(BuildContext context) {
  return Container(
    height: context.textTheme.headlineLarge?.fontSize ?? kGap_3,
    width: context.textTheme.headlineLarge?.fontSize ?? kGap_3,
    decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/logo.png'))),
  );
}
