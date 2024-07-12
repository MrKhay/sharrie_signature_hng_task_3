import 'package:flutter/material.dart';

import 'extensions.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  Size get screenSize => MediaQuery.sizeOf(this);

  Locale get appLocale => Localizations.localeOf(this);

  bool get isPlatformDarkThemed =>
      MediaQuery.platformBrightnessOf(this) == Brightness.dark;

  /// Show snack bar
  void showSnackBar(
    String content, {
    Duration duration = const Duration(seconds: 1),
    SnackBarType type = SnackBarType.info,
  }) {
    final ScaffoldMessengerState sMessenger = ScaffoldMessenger.of(this);
    sMessenger.showSnack(content, duration: duration, type: type);
  }
}
