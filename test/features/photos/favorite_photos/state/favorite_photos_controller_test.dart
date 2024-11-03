import 'package:flutter_test/flutter_test.dart';
import 'package:simple_images_app/core/core.dart';
import 'package:simple_images_app/features/features.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  group('FavoritePhotosController', () {
    // Should have the correct initial state when created
    test(
        'Should have the correct initial state when created with a list of favorite photos',
        () async {
      // Given
      final samplePhotos = [samplePhotoModel];
      final mockService = MockFavoritePhotosService(
        photosToReturn: samplePhotos,
      );

      final controller = FavoritePhotosController(
        service: mockService,
        errorReportingService: LocalLoggingErrorReportingService(),
      );

      // When
      final state = controller.state;

      // Then
      expect(
        state,
        isA<FavoritePhotosState>(),
      );

      final photos = state.favoritePhotos;

      expect(
        photos,
        samplePhotos,
      );
    });

    test(
        'Should have the correct initial state when created with an empty list of favorite photos',
        () async {
      // Given
      final samplePhotos = <PhotoModel>[];
      final mockService = MockFavoritePhotosService(
        photosToReturn: samplePhotos,
      );

      final controller = FavoritePhotosController(
        service: mockService,
        errorReportingService: LocalLoggingErrorReportingService(),
      );

      // When
      final state = controller.state;

      // Then
      expect(
        state,
        isA<FavoritePhotosState>(),
      );

      final photos = state.favoritePhotos;

      expect(
        photos,
        samplePhotos,
      );
    });

    // Should add a favorite photo
    test('Should add a favorite photo', () async {
      // Given
      const samplePhoto = samplePhotoModel;
      const mockService = MockFavoritePhotosService(
        photosToReturn: [],
      );

      final controller = FavoritePhotosController(
        service: mockService,
        errorReportingService: LocalLoggingErrorReportingService(),
      );

      // When
      await controller.addFavoritePhoto(samplePhoto);

      // Then
      final photos = controller.state.favoritePhotos;

      expect(
        photos,
        [samplePhoto],
      );
    });

    // Should not add a favorite photo if it is already being added
    test('Should not add a favorite photo if it is already being added',
        () async {
      // Given
      const samplePhoto = samplePhotoModel;
      const mockService = MockFavoritePhotosService(
        photosToReturn: [],
      );

      final controller = FavoritePhotosController(
        service: mockService,
        errorReportingService: LocalLoggingErrorReportingService(),
      );

      // When
      await controller.addFavoritePhoto(samplePhoto);
      await controller.addFavoritePhoto(samplePhoto);

      // Then
      final photos = controller.state.favoritePhotos;

      expect(
        photos,
        [samplePhoto],
      );

      expect(
        photos.length,
        1,
      );

      expect(
        photos.first.id,
        samplePhoto.id,
      );

      expect(
        photos.first,
        samplePhoto,
      );
    });

    // Should remove a favorite photo
    test('Should remove a favorite photo', () async {
      // Given
      const samplePhoto = samplePhotoModel;
      const mockService = MockFavoritePhotosService(
        photosToReturn: [samplePhoto],
      );

      final controller = FavoritePhotosController(
        service: mockService,
        errorReportingService: LocalLoggingErrorReportingService(),
      );

      // When
      await controller.removeFavoritePhoto(samplePhoto.id);

      // Then
      final photos = controller.state.favoritePhotos;

      expect(
        photos,
        [],
      );
    });

    // Should not remove a favorite photo if it is already being removed
    test('Should not remove a favorite photo if it is already being removed',
        () async {
      // Given
      const samplePhoto = samplePhotoModel;
      const mockService = MockFavoritePhotosService(
        photosToReturn: [],
      );

      final controller = FavoritePhotosController(
        service: mockService,
        errorReportingService: LocalLoggingErrorReportingService(),
      );

      // When
      await controller.addFavoritePhoto(samplePhoto);
      await controller.removeFavoritePhoto(samplePhoto.id);
      await controller.removeFavoritePhoto(samplePhoto.id);

      // Then
      final photos = controller.state.favoritePhotos;

      expect(
        photos,
        [],
      );
    });
  });
}
