import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:simple_images_app/features/features.dart';

import '../../../fixtures.dart';

void main() {
  group('PhotosService', () {
    late Dio dio;
    late DioAdapter dioAdapter;

    setUp(() {
      dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.unsplash.com',
          headers: {
            'Authorization  ': 'Client ID xxx',
          },
        ),
      );
      dioAdapter = DioAdapter(dio: dio);
    });

    test('getPhotos', () async {
      // Given
      TestWidgetsFlutterBinding.ensureInitialized();

      final fakePhotos = [
        emptySamplePhotoModel,
      ];

      dioAdapter.onGet(
        'photos?page=1',
        (request) => request.reply(200, [
          emptySamplePhotoMap,
        ]),
      );

      final service = UnsplashPhotosService(
        client: dio,
      );

      // When
      final photos = await service.getPhotos(page: 1);

      // Then
      expect(
        photos,
        isA<List<PhotoModel>>(),
      );

      expect(
        photos,
        equals(fakePhotos),
      );
    });

    test('getPhoto', () async {
      // Given
      TestWidgetsFlutterBinding.ensureInitialized();

      const fakePhoto = emptySamplePhotoModel;

      dioAdapter.onGet(
        'photos/${fakePhoto.id}',
        (request) => request.reply(200, emptySamplePhotoMap),
      );

      final service = UnsplashPhotosService(
        client: dio,
      );

      // When
      final photo = await service.getPhoto(photoId: fakePhoto.id);

      // Then
      expect(
        photo,
        isA<PhotoModel>(),
      );

      expect(
        photo,
        equals(fakePhoto),
      );
    });

    test('searchPhotos', () async {
      // Given
      TestWidgetsFlutterBinding.ensureInitialized();

      final fakePhotos = [
        emptySamplePhotoModel,
      ];

      dioAdapter.onGet(
        'search/photos?page=1&query=test',
        (request) => request.reply(
          200,
          {
            'results': [
              emptySamplePhotoMap,
            ],
          },
        ),
      );

      final service = UnsplashPhotosService(
        client: dio,
      );

      // When
      final photos = await service.searchPhotos(query: 'test', page: 1);

      // Then
      expect(
        photos,
        isA<List<PhotoModel>>(),
      );

      expect(
        photos,
        equals(fakePhotos),
      );
    });
  });
}
