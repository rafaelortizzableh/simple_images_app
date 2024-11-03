import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import 'theme.dart';

/// The provider for the [CustomTheme].
final customThemeProvider = Provider.autoDispose<CustomTheme>((ref) {
  final preferredColor = ref.watch(preferredColorControllerProvider);
  return CustomTheme(primaryColor: preferredColor);
});

class CustomTheme {
  const CustomTheme({
    required this.primaryColor,
  });

  final MaterialColor primaryColor;

  static const errorRed = Colors.red;

  static const _raleWay = 'Raleway';

  ThemeData darkTheme(
    MaterialColor primaryColor,
  ) {
    final defaultTheme = ThemeData.dark();
    final textTheme = defaultTheme.primaryTextTheme;
    final foregroundColor =
        primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    final overlayStyle = primaryColor.computeLuminance() > 0.5
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
    return ThemeData(
      extensions: [
        ForegroundColor(foregroundColor: foregroundColor),
        PreferredColor(preferredColor: primaryColor),
      ],
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: foregroundColor,
        ),
        titleTextStyle: defaultTheme.appBarTheme.titleTextStyle?.copyWith(
          color: foregroundColor,
        ),
        backgroundColor: primaryColor,
        foregroundColor: foregroundColor,
        actionsIconTheme: IconThemeData(
          color: foregroundColor,
        ),
        systemOverlayStyle: overlayStyle,
      ),
      primarySwatch: primaryColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primaryColor,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        cardColor: Colors.grey.shade900,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: foregroundColor,
          shape: AppConstants.roundedRectangleBorder12,
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacing8,
            horizontal: AppConstants.spacing16,
          ),
        ),
      ),
      useMaterial3: true,
      textTheme: defaultTheme.primaryTextTheme
          .copyWith(
            displayMedium: textTheme.displayMedium?.copyWith(
              fontSize: 42.0,
            ),
            titleMedium: textTheme.titleMedium?.copyWith(
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
            bodyLarge: textTheme.titleMedium?.copyWith(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
            bodyMedium: textTheme.titleMedium?.copyWith(
              fontSize: 13.0,
              fontWeight: FontWeight.w300,
            ),
          )
          .apply(
            fontFamily: _raleWay,
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
    );
  }

  ThemeData lightTheme(
    MaterialColor primaryColor,
  ) {
    final foregroundColor =
        primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    final overlayStyle = primaryColor.computeLuminance() > 0.5
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
    final defaultTheme = ThemeData.light();
    final textTheme = defaultTheme.primaryTextTheme;

    return ThemeData(
      extensions: [
        ForegroundColor(foregroundColor: foregroundColor),
        PreferredColor(preferredColor: primaryColor),
      ],
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: foregroundColor,
        ),
        titleTextStyle: defaultTheme.appBarTheme.titleTextStyle?.copyWith(
          color: foregroundColor,
        ),
        backgroundColor: primaryColor,
        foregroundColor: foregroundColor,
        actionsIconTheme: IconThemeData(
          color: foregroundColor,
        ),
        systemOverlayStyle: overlayStyle,
      ),
      primarySwatch: primaryColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primaryColor,
        brightness: Brightness.light,
        backgroundColor: defaultTheme.scaffoldBackgroundColor,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.light,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: foregroundColor,
          shape: AppConstants.roundedRectangleBorder12,
        ),
      ),
      useMaterial3: true,
      textTheme: defaultTheme.primaryTextTheme
          .copyWith(
            displayMedium: textTheme.displayMedium?.copyWith(
              fontSize: 42.0,
            ),
            titleMedium: textTheme.titleMedium?.copyWith(
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
            bodyLarge: textTheme.titleMedium?.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
            bodyMedium: textTheme.titleMedium?.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
            ),
          )
          .apply(
            fontFamily: _raleWay,
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
    );
  }
}
