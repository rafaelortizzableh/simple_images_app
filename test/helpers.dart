import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_images_app/core/core.dart';
import 'package:simple_images_app/features/features.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    SharedPreferencesService? sharedPreferencesService,
    List<Override> overrides = const [],
  }) async {
    // Set up mocked [SharedPreferencesService].
    SharedPreferences.setMockInitialValues({});
    SharedPreferences mockPreferences = await SharedPreferences.getInstance();
    final mockSharedPreferencesService =
        sharedPreferencesService ?? SharedPreferencesService(mockPreferences);

    const preferredColor = Colors.deepPurple;
    const customTheme = CustomTheme(primaryColor: preferredColor);

    return await pumpWidget(
      MaterialApp(
        home: Theme(
          data: customTheme.darkTheme(preferredColor),
          child: Scaffold(
            body: ProviderScope(
              overrides: [
                sharedPreferencesServiceProvider.overrideWithValue(
                  mockSharedPreferencesService,
                ),
                ...overrides,
              ],
              child: widget,
            ),
          ),
        ),
      ),
    );
  }
}
