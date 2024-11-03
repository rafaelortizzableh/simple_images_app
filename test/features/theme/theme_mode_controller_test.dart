import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_images_app/core/core.dart';
import 'package:simple_images_app/features/features.dart';

void main() {
  group('ThemeModeController', () {
    test('Should have initial value after instantiation', () async {
      // Given
      SharedPreferences.setMockInitialValues({
        ThemeConstants.selectedThemeKey: ThemeConstants.darkThemeMode,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(
            SharedPreferencesService(sharedPreferences),
          ),
        ],
      );

      // When
      final subscription =
          container.listen(themeModeControllerProvider, (_, __) {});

      final state = subscription.read();

      // Then
      expect(state, ThemeMode.dark);
    });

    test('Should update the theme mode', () async {
      // Given
      SharedPreferences.setMockInitialValues({
        ThemeConstants.selectedThemeKey: ThemeConstants.darkThemeMode,
      });

      final sharedPreferences = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(
            SharedPreferencesService(sharedPreferences),
          ),
        ],
      );
      // When
      final subscription =
          container.listen(themeModeControllerProvider, (_, __) {});

      final controller = container.read(themeModeControllerProvider.notifier);

      await controller.updateThemeMode(ThemeMode.light);
      final state = subscription.read();

      // Then
      expect(state, ThemeMode.light);
    });
  });
}
