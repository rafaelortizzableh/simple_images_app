import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_images_app/core/core.dart';
import 'package:simple_images_app/features/features.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';

void main() {
  group('PhotosController', () {
    test('Should have the correct initial state when created', () async {
      // Given
      final samplePhotos = [samplePhotoModel];
      final photosService = MockPhotoService(
        photosToReturn: samplePhotos,
      );
      // When
      final container = ProviderContainer(
        overrides: [
          photosServiceProvider.overrideWithValue(photosService),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);

      final subscription = container.listen<PhotosState>(
        photosProvider,
        (_, __) {},
      );

      await Future<void>.delayed(const Duration(milliseconds: 250));

      final state = subscription.read();
      // Then
      expect(
        state,
        isA<PhotosState>(),
      );

      expect(
        state.photos,
        samplePhotos,
      );

      expect(
        state.hasMore,
        true,
      );
    });

    // Should fetch photos and update the state
    test('Should fetch photos and update the state', () async {
      // Given
      final samplePhotos = [emptySamplePhotoModel];
      final photosService = MockPhotoService(
        photosToReturn: samplePhotos,
      );

      final container = ProviderContainer(
        overrides: [
          photosServiceProvider.overrideWithValue(photosService),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);
      // When

      final subscription = container.listen<PhotosState>(
        photosProvider,
        (_, __) {},
      );

      final controller = container.read(photosProvider.notifier);

      await controller.getPhotos();

      await Future<void>.delayed(const Duration(milliseconds: 250));

      final state = subscription.read();
      // Then
      expect(
        state.photos,
        containsAll(samplePhotos),
      );
    });

    // Should fetch more photos and update the state
    test('Should fetch more photos and update the state', () async {
      // Given
      final samplePhotos = [emptySamplePhotoModel];
      final photosService = MockPhotoService(
        photosToReturn: samplePhotos,
      );

      final container = ProviderContainer(
        overrides: [
          photosServiceProvider.overrideWithValue(photosService),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);
      // When

      final subscription = container.listen<PhotosState>(
        photosProvider,
        (_, __) {},
      );

      final controller = container.read(photosProvider.notifier);

      await controller.getMorePhotos();

      await Future<void>.delayed(const Duration(milliseconds: 250));

      final state = subscription.read();
      // Then
      expect(
        state.photos,
        containsAll(samplePhotos),
      );
    });

    // Should handle errors when fetching photos
    test('Should handle errors when fetching photos', () async {
      // Given
      const photosService = MockPhotoService(
        photosToReturn: [],
        exceptionToThrow: PhotoFailure(type: PhotoFailureType.unknown),
      );

      final container = ProviderContainer(
        overrides: [
          photosServiceProvider.overrideWithValue(photosService),
          errorReportingServiceProvider.overrideWithValue(
            LocalLoggingErrorReportingService(),
          ),
        ],
      );

      addTearDown(container.dispose);
      // When

      final subscription = container.listen<PhotosState>(
        photosProvider,
        (_, __) {},
      );

      final controller = container.read(photosProvider.notifier);

      await controller.getPhotos();

      await Future<void>.delayed(const Duration(milliseconds: 250));

      final state = subscription.read();
      // Then
      expect(
        state.failure,
        isA<PhotoFailure>(),
      );
    });
  });
}
