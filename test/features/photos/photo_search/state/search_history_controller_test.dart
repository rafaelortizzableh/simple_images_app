import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_images_app/core/core.dart';
import 'package:simple_images_app/features/features.dart';

void main() {
  group('Search History Controller', () {
    // Should have the correct initial state when created
    test(
        'Should have the correct initial state when created with a list of previous search queries',
        () async {
      // Given
      final sampleSearchQueries = ['Nature', 'Mountains', 'Beach'];
      SharedPreferences.setMockInitialValues({
        SharedPreferencesPhotoSearchHistoryService.storageKey:
            sampleSearchQueries,
      });
      final mockPreferences = await SharedPreferences.getInstance();

      final mockSharedPreferencesService = SharedPreferencesService(
        mockPreferences,
      );
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider
              .overrideWithValue(mockSharedPreferencesService),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);

      // When
      final state = container.read(searchHistoryProvider);

      // Then
      expect(
        state,
        isA<SearchHistoryState>(),
      );

      final searchQueries = state.searchQueries;

      expect(
        searchQueries,
        sampleSearchQueries,
      );
    });

    test(
        'Should have the correct initial state when created with a an empty list of previous search queries',
        () async {
      // Given
      final sampleSearchQueries = <String>[];
      SharedPreferences.setMockInitialValues({
        SharedPreferencesPhotoSearchHistoryService.storageKey:
            sampleSearchQueries,
      });
      final mockPreferences = await SharedPreferences.getInstance();

      final mockSharedPreferencesService = SharedPreferencesService(
        mockPreferences,
      );
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider
              .overrideWithValue(mockSharedPreferencesService),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);

      // When
      final state = container.read(searchHistoryProvider);

      // Then
      expect(
        state,
        isA<SearchHistoryState>(),
      );
      final searchQueries = state.searchQueries;
      expect(
        searchQueries,
        isEmpty,
      );
    });

    test('addSearchQuery', () async {
      // Given
      final sampleSearchQueries = ['Nature', 'Mountains', 'Beach'];
      SharedPreferences.setMockInitialValues({
        SharedPreferencesPhotoSearchHistoryService.storageKey:
            sampleSearchQueries,
      });

      final mockPreferences = await SharedPreferences.getInstance();

      final mockSharedPreferencesService = SharedPreferencesService(
        mockPreferences,
      );

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider
              .overrideWithValue(mockSharedPreferencesService),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);

      final searchHistoryController =
          container.read(searchHistoryProvider.notifier);

      // When
      await searchHistoryController.addSearchQuery('Forest');

      // Then
      final state = container.read(searchHistoryProvider);

      final searchQueries = state.searchQueries;

      expect(
        searchQueries,
        ['Nature', 'Mountains', 'Beach', 'Forest'],
      );
    });

    test('removeSearchQuery', () async {
      // Given
      final sampleSearchQueries = ['Nature', 'Mountains', 'Beach'];
      SharedPreferences.setMockInitialValues({
        SharedPreferencesPhotoSearchHistoryService.storageKey:
            sampleSearchQueries,
      });

      final mockPreferences = await SharedPreferences.getInstance();

      final mockSharedPreferencesService = SharedPreferencesService(
        mockPreferences,
      );

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider
              .overrideWithValue(mockSharedPreferencesService),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);

      final searchHistoryController =
          container.read(searchHistoryProvider.notifier);

      // When
      await searchHistoryController.removeSearchQuery('Mountains');

      // Then
      final state = container.read(searchHistoryProvider);

      final searchQueries = state.searchQueries;

      expect(
        searchQueries,
        ['Nature', 'Beach'],
      );
    });
  });
}
