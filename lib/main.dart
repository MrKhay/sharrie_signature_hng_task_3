import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/features.dart';
import 'sharrie_signature.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(
    child: MainApp(),
  ));
}

///
class MainApp extends StatelessWidget {
  ///
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      home: const SharrieSignature(),
    );
  }
}
