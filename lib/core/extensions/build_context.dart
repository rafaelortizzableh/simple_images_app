import 'package:flutter/material.dart';

extension CustomExtension on BuildContext {
  Locale get locale => Localizations.localeOf(this);
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
  double get dpr => View.of(this).devicePixelRatio;
  double get topPadding {
    final viewPaddingTop = View.of(this).padding.top;
    return viewPaddingTop / dpr;
  }
}
