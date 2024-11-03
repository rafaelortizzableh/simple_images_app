import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_images_app/core/core.dart';
import 'package:simple_images_app/features/features.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  group('photoDetailsProvider', () {
    test(
        'If there are loaded photos, the photoDetailsProvider should return the photo details for the selected photo',
        () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      // Given
      const samplePhoto = samplePhotoModel;
      final loadedPhotos = [samplePhoto];
      final photosService = MockPhotoService(
        photosToReturn: loadedPhotos,
      );
      final photosController = PhotosController(
        state: PhotosState(
          photos: loadedPhotos,
          hasMore: false,
          isLoading: false,
          failure: null,
        ),
        photosService: photosService,
        errorReportingService: LocalLoggingErrorReportingService(),
      );

      SharedPreferences.setMockInitialValues({
        SharedPreferencesFavoritePhotosService.storageKey: [],
      });

      final sharedPreferencesService = SharedPreferencesService(
        await SharedPreferences.getInstance(),
      );

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(
            sharedPreferencesService,
          ),
          photosProvider.overrideWith((ref) => photosController),
          photosServiceProvider.overrideWithValue(photosService),
        ],
      );

      // When
      final subscription = container.listen<AsyncValue<PhotoModel>>(
        photoDetailsProvider(samplePhoto.id),
        (_, __) {},
      );

      await Future<void>.delayed(const Duration(milliseconds: 250));

      final photoDetails = subscription.read().asData?.value;

      // Then
      expect(
        photoDetails,
        isA<PhotoModel>(),
      );

      expect(photoDetails, samplePhoto);
    });

    test(
        'If favorites include the selected photo, the photoDetailsProvider should return that the photo is a favorite',
        () async {
      // Given
      const samplePhoto = samplePhotoModel;
      final loadedPhotos = <PhotoModel>[];
      final photosController = PhotosController(
        state: PhotosState(
          photos: loadedPhotos,
          hasMore: false,
          isLoading: false,
          failure: null,
        ),
        photosService: MockPhotoService(
          photosToReturn: loadedPhotos,
        ),
        errorReportingService: LocalLoggingErrorReportingService(),
      );

      SharedPreferences.setMockInitialValues({
        SharedPreferencesFavoritePhotosService.storageKey: [
          samplePhoto.toJson(),
        ],
      });

      final sharedPreferencesService = SharedPreferencesService(
        await SharedPreferences.getInstance(),
      );

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(
            sharedPreferencesService,
          ),
          photosProvider.overrideWith((ref) => photosController),
        ],
      );

      // When
      final subscription = container.listen<AsyncValue<PhotoModel>>(
        photoDetailsProvider(samplePhoto.id),
        (_, __) {},
      );

      await Future<void>.delayed(const Duration(milliseconds: 250));

      final photoDetails = subscription.read().asData?.value;

      // Then
      expect(
        photoDetails,
        isA<PhotoModel>(),
      );

      expect(photoDetails, samplePhoto);
    });

    test(
        'If the photoDetailsProvider is loading, it should return that the photo is loading',
        () async {
      // Given
      const samplePhoto = samplePhotoModel;
      final loadedPhotos = <PhotoModel>[];

      final photosController = PhotosController(
        state: PhotosState(
          photos: loadedPhotos,
          hasMore: false,
          isLoading: true,
          failure: null,
        ),
        photosService: MockPhotoService(
          photosToReturn: loadedPhotos,
        ),
        errorReportingService: LocalLoggingErrorReportingService(),
      );

      SharedPreferences.setMockInitialValues({
        SharedPreferencesFavoritePhotosService.storageKey: [],
      });

      final sharedPreferencesService = SharedPreferencesService(
        await SharedPreferences.getInstance(),
      );

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(
            sharedPreferencesService,
          ),
          photosProvider.overrideWith((ref) => photosController),
        ],
      );
      addTearDown(container.dispose);

      // When
      final subscription = container.listen<AsyncValue<PhotoModel>>(
        photoDetailsProvider(samplePhoto.id),
        (_, __) {},
      );

      await Future<void>.delayed(const Duration(milliseconds: 250));

      final photoDetails = subscription.read();

      // Then
      expect(
        photoDetails,
        isA<AsyncValue<PhotoModel>>(),
      );

      expect(photoDetails, isA<AsyncLoading>());
    });

    test(
        'If there is an error loading the photo details, the photoDetailsProvider should return the error',
        () async {
      // Given
      TestWidgetsFlutterBinding.ensureInitialized();
      const samplePhoto = samplePhotoModel;
      final loadedPhotos = <PhotoModel>[];

      final photosController = PhotosController(
        state: PhotosState(
          photos: loadedPhotos,
          hasMore: false,
          isLoading: false,
          failure: const PhotoFailure(type: PhotoFailureType.photoDetailError),
        ),
        photosService: MockPhotoService(
          photosToReturn: loadedPhotos,
          exceptionToThrow: const PhotoDetailNotFoundFailure(),
        ),
        errorReportingService: LocalLoggingErrorReportingService(),
      );

      SharedPreferences.setMockInitialValues({
        SharedPreferencesFavoritePhotosService.storageKey: [],
      });
      final sharedPreferencesService = SharedPreferencesService(
        await SharedPreferences.getInstance(),
      );

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(
            sharedPreferencesService,
          ),
          photosProvider.overrideWith((ref) => photosController),
        ],
      );
      addTearDown(container.dispose);

      // When
      final subscription = container.listen<AsyncValue<PhotoModel>>(
        photoDetailsProvider(samplePhoto.id),
        (_, __) {},
      );

      await Future<void>.delayed(const Duration(milliseconds: 250));

      final photoDetails = subscription.read();

      // Then
      expect(photoDetails, isA<AsyncError>());
    });

    test(
        'If the photo is loaded from the service, the photoDetailsProvider should return the photo details',
        () async {
      // Given
      const samplePhoto = samplePhotoModel;
      final loadedPhotos = <PhotoModel>[];
      final photosService = MockPhotoService(
        photosToReturn: loadedPhotos,
        photoToReturn: samplePhoto,
      );
      final photosController = PhotosController(
        state: PhotosState(
          photos: loadedPhotos,
          hasMore: false,
          isLoading: false,
          failure: null,
        ),
        photosService: photosService,
        errorReportingService: LocalLoggingErrorReportingService(),
      );

      SharedPreferences.setMockInitialValues({
        SharedPreferencesFavoritePhotosService.storageKey: [],
      });

      final sharedPreferencesService = SharedPreferencesService(
        await SharedPreferences.getInstance(),
      );

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(
            sharedPreferencesService,
          ),
          photosProvider.overrideWith((ref) => photosController),
          photosServiceProvider.overrideWithValue(photosService),
        ],
      );

      // When
      final subscription = container.listen<AsyncValue<PhotoModel>>(
        photoDetailsProvider(samplePhoto.id),
        (_, __) {},
      );

      await Future<void>.delayed(const Duration(milliseconds: 250));

      final photoDetails = subscription.read().asData?.value;

      // Then
      expect(
        photoDetails,
        isA<PhotoModel>(),
      );

      expect(photoDetails, samplePhoto);
    });
  });
}
