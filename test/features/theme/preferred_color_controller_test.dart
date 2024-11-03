import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_images_app/core/core.dart';
import 'package:simple_images_app/features/features.dart';

void main() {
  group('PreferredColorController', () {
    test('Should have initial value after instantiation', () async {
      // Given
      SharedPreferences.setMockInitialValues({
        ThemeConstants.preferredColorKey: Colors.primaries.indexOf(Colors.red),
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
          container.listen(preferredColorControllerProvider, (_, __) {});

      final state = subscription.read();
      // Then

      expect(state, Colors.red);
    });

    test('Should update the preferred color', () async {
      // Given
      SharedPreferences.setMockInitialValues({
        ThemeConstants.preferredColorKey: Colors.primaries.indexOf(Colors.red),
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
          container.listen(preferredColorControllerProvider, (_, __) {});

      final controller =
          container.read(preferredColorControllerProvider.notifier);

      await controller.updatePreferredColor(Colors.blue);

      final state = subscription.read();

      // Then

      expect(state, Colors.blue);
    });
  });
}
