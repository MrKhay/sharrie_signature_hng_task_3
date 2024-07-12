import 'package:flutter/material.dart';

import '../../features.dart';

/// Scaffold Extensions
extension ScaffoldExtension on ScaffoldMessengerState {
  /// Show snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnack(
    String content, {
    Duration duration = const Duration(seconds: 1),
    SnackBarType type = SnackBarType.info,
  }) {
    switch (type) {
      case SnackBarType.success:
        return showSnackBar(
          SnackBar(
            backgroundColor: Colors.green.shade300,
            content: Text(
              content,
              style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
            ),
            duration: duration,
          ),
        );
      case SnackBarType.error:
        return showSnackBar(
          SnackBar(
            backgroundColor: context.colorScheme.error,
            content: Text(
              content,
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: context.colorScheme.onError),
            ),
            duration: duration,
          ),
        );
      case SnackBarType.info:
        return showSnackBar(
          SnackBar(
            backgroundColor: context.colorScheme.outline,
            content: Text(
              content,
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: context.colorScheme.surface),
            ),
            duration: duration,
          ),
        );
    }
  }
}

/// Snackbar Type
enum SnackBarType {
  /// When error occurs
  error,

  /// When success occurs
  success,

  /// Regular info
  info
}
