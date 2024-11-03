import 'package:flutter/material.dart';

abstract class AppConstants {
  // API Keys
  static const unsplashApiKey = String.fromEnvironment('UNSPLASH_API');

  /// The name of the author of the app.
  static const authorName = String.fromEnvironment('AUTHOR_NAME');

  // Colors
  static const primaryColor = Color(0xFF032541);

  // Spacing
  static const spacing1 = 1.0;
  static const spacing2 = 2.0;
  static const spacing4 = 4.0;
  static const spacing6 = 6.0;
  static const spacing8 = 8.0;
  static const spacing12 = 12.0;
  static const spacing16 = 16.0;
  static const spacing24 = 24.0;
  static const spacing32 = 32.0;
  static const spacing48 = 58.0;

  // Padding
  static const horizontalPadding4 = EdgeInsets.symmetric(horizontal: spacing4);
  static const horizontalPadding8 = EdgeInsets.symmetric(horizontal: spacing8);
  static const horizontalPadding12 = EdgeInsets.symmetric(
    horizontal: spacing12,
  );
  static const horizontalPadding16 = EdgeInsets.symmetric(
    horizontal: spacing16,
  );
  static const horizontalPadding24 = EdgeInsets.symmetric(
    horizontal: spacing24,
  );
  static const horizontalPadding32 = EdgeInsets.symmetric(
    horizontal: spacing32,
  );

  static const verticalPadding4 = EdgeInsets.symmetric(vertical: spacing4);
  static const verticalPadding8 = EdgeInsets.symmetric(vertical: spacing8);
  static const verticalPadding12 = EdgeInsets.symmetric(vertical: spacing12);
  static const verticalPadding16 = EdgeInsets.symmetric(vertical: spacing16);
  static const verticalPadding24 = EdgeInsets.symmetric(vertical: spacing24);
  static const verticalPadding32 = EdgeInsets.symmetric(vertical: spacing32);

  static const topPadding4 = EdgeInsets.only(top: spacing4);
  static const topPadding8 = EdgeInsets.only(top: spacing8);
  static const topPadding12 = EdgeInsets.only(top: spacing12);
  static const topPadding16 = EdgeInsets.only(top: spacing16);
  static const topPadding24 = EdgeInsets.only(top: spacing24);
  static const topPadding32 = EdgeInsets.only(top: spacing32);

  static const bottomPadding4 = EdgeInsets.only(bottom: spacing4);
  static const bottomPadding8 = EdgeInsets.only(bottom: spacing8);
  static const bottomPadding12 = EdgeInsets.only(bottom: spacing12);
  static const bottomPadding16 = EdgeInsets.only(bottom: spacing16);
  static const bottomPadding24 = EdgeInsets.only(bottom: spacing24);
  static const bottomPadding32 = EdgeInsets.only(bottom: spacing32);

  static const leftPadding4 = EdgeInsets.only(left: spacing4);
  static const leftPadding8 = EdgeInsets.only(left: spacing8);
  static const leftPadding12 = EdgeInsets.only(left: spacing12);
  static const leftPadding16 = EdgeInsets.only(left: spacing16);
  static const leftPadding24 = EdgeInsets.only(left: spacing24);
  static const leftPadding32 = EdgeInsets.only(left: spacing32);

  static const rightPadding4 = EdgeInsets.only(right: spacing4);
  static const rightPadding8 = EdgeInsets.only(right: spacing8);
  static const rightPadding12 = EdgeInsets.only(right: spacing12);
  static const rightPadding16 = EdgeInsets.only(right: spacing16);
  static const rightPadding24 = EdgeInsets.only(right: spacing24);
  static const rightPadding32 = EdgeInsets.only(right: spacing32);

  static const padding1 = EdgeInsets.all(spacing1);
  static const padding2 = EdgeInsets.all(spacing2);
  static const padding4 = EdgeInsets.all(spacing4);
  static const padding8 = EdgeInsets.all(spacing8);
  static const padding12 = EdgeInsets.all(spacing12);
  static const padding16 = EdgeInsets.all(spacing16);
  static const padding24 = EdgeInsets.all(spacing24);
  static const padding32 = EdgeInsets.all(spacing32);

  // Border Radius
  static const borderRadius4 = BorderRadius.all(circularRadius4);
  static const borderRadius8 = BorderRadius.all(circularRadius8);
  static const borderRadius12 = BorderRadius.all(circularRadius12);
  static const borderRadius16 = BorderRadius.all(circularRadius16);
  static const circularRadius4 = Radius.circular(4.0);
  static const circularRadius8 = Radius.circular(8.0);
  static const circularRadius12 = Radius.circular(12.0);
  static const circularRadius16 = Radius.circular(16.0);
  static const circularRadius32 = Radius.circular(32.0);
  static const circularRadius48 = Radius.circular(48.0);
  static const circularRadius64 = Radius.circular(64.0);
  static const roundedRectangleBorder12 = RoundedRectangleBorder(
    borderRadius: borderRadius12,
  );
  static const roundedRectangleTopBorder12 = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: circularRadius12,
      topRight: circularRadius12,
    ),
  );
  static const roundedRectangleVerticalBorder16 = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(spacing16),
    ),
  );
}
