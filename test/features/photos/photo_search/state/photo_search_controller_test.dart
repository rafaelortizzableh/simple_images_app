import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_images_app/core/core.dart';
import 'package:simple_images_app/features/features.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  // Group for PhotoSearchController
  group('PhotoSearchController', () {
    // Test for searchPhotos
    test('searchPhotos should search for photos and update the state',
        () async {
      // Given
      final photosToReturn = [
        samplePhotoModel,
      ];
      final service = MockPhotoService(
        photosToReturn: photosToReturn,
      );

      final container = ProviderContainer(
        overrides: [
          photosServiceProvider.overrideWithValue(service),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);

      // When
      final subscription =
          container.listen<PhotoSearchState>(photoSearchProvider, (_, __) {});

      final controller = container.read(photoSearchProvider.notifier);

      await controller.searchPhotos(query: 'Nature');

      await Future<void>.delayed(const Duration(milliseconds: 250));

      // Then
      final state = subscription.read();

      expect(
        state.photos,
        isNotEmpty,
      );

      expect(
        state.photos.first,
        isA<PhotoModel>(),
      );

      expect(
        state.photos.first,
        equals(photosToReturn.first),
      );
    });

    // Test for searchPhotos when isLoading is true
    test('searchPhotos should not search for photos when isLoading is true',
        () async {
      // Given
      const service = MockPhotoService(
        photosToReturn: [],
      );

      final container = ProviderContainer(
        overrides: [
          photosServiceProvider.overrideWithValue(service),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);

      // When

      final controller = container.read(photoSearchProvider.notifier);

      controller.state = const PhotoSearchState(
        photos: [],
        query: 'Nature',
        isLoading: true,
        hasMore: true,
        page: 1,
      );

      await controller.searchPhotos(query: 'Nature');

      // Then
      final subscription =
          container.listen<PhotoSearchState>(photoSearchProvider, (_, __) {});

      final state = subscription.read();

      expect(
        state.photos,
        isEmpty,
      );
    });

    // Test for searchPhotos when hasMore is false
    test('searchPhotos should not search for photos when hasMore is false',
        () async {
      // Given
      const service = MockPhotoService(
        photosToReturn: [],
      );

      final container = ProviderContainer(
        overrides: [
          photosServiceProvider.overrideWithValue(service),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);
      // When
      final controller = container.read(photoSearchProvider.notifier);

      controller.state = const PhotoSearchState(
        photos: [],
        query: 'Nature',
        isLoading: false,
        hasMore: false,
        page: 1,
      );

      final subscription =
          container.listen<PhotoSearchState>(photoSearchProvider, (_, __) {});
      await controller.searchPhotos(query: 'Nature');

      // Then
      final state = subscription.read();

      expect(
        state.photos,
        isEmpty,
      );
    });

    // Test for searchPhotos when isLoadingMore is true
    test('searchPhotos should not search for photos when isLoadingMore is true',
        () async {
      // Given
      const service = MockPhotoService(
        photosToReturn: [],
      );

      final container = ProviderContainer(
        overrides: [
          photosServiceProvider.overrideWithValue(service),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);

      // When
      final controller = container.read(photoSearchProvider.notifier);

      controller.state = const PhotoSearchState(
        photos: [],
        query: 'Nature',
        isLoading: false,
        isLoadingMore: true,
        hasMore: true,
        page: 1,
      );

      final subscription =
          container.listen<PhotoSearchState>(photoSearchProvider, (_, __) {});

      await controller.searchPhotos(query: 'Nature');

      // Then

      final state = subscription.read();

      expect(
        state.photos,
        isEmpty,
      );
    });

    // Test for searchPhotos when searchPhotos throws a PhotoFailure
    test('searchPhotos should handle a PhotoFailure', () async {
      // Given
      const service = MockPhotoService(
        photosToReturn: [],
        exceptionToThrow: PhotoFailure(
          type: PhotoFailureType.unknown,
        ),
      );
      // When
      final container = ProviderContainer(
        overrides: [
          photosServiceProvider.overrideWithValue(service),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);

      final controller = container.read(photoSearchProvider.notifier);

      final subscription =
          container.listen<PhotoSearchState>(photoSearchProvider, (_, __) {});

      await controller.searchPhotos(query: 'Nature');

      // Then

      final state = subscription.read();

      expect(
        state.failure,
        isA<PhotoFailure>(),
      );
    });
  });
}
