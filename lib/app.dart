import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/core.dart';
import 'features/features.dart';

class SimplePhotosApp extends ConsumerWidget {
  const SimplePhotosApp({super.key});

  static const appTitle = 'Simple Photos App';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final customTheme = ref.watch(customThemeProvider);
    final preferredColor = ref.watch(preferredColorControllerProvider);

    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: customTheme.lightTheme(preferredColor),
      darkTheme: customTheme.darkTheme(preferredColor),
      color: preferredColor,
      themeMode: themeMode,
      onGenerateRoute: generatePageRoute,
      navigatorKey: AppConstants.appNavigationKey,
    );
  }
}
