import 'package:simple_images_app/features/features.dart';

class MockPhotoService implements PhotosService {
  final List<PhotoModel> photosToReturn;
  final Object? exceptionToThrow;
  final PhotoModel? photoToReturn;

  const MockPhotoService({
    required this.photosToReturn,
    this.photoToReturn,
    this.exceptionToThrow,
  });

  @override
  Future<PhotoModel> getPhoto({required String photoId}) {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }

    final photoToReturn = this.photoToReturn;
    if (photoToReturn == null) {
      throw Exception('No photo to return');
    }

    return Future.value(photoToReturn);
  }

  @override
  Future<List<PhotoModel>> getPhotos({required int page}) {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }

    return Future.value(photosToReturn);
  }

  @override
  Future<List<PhotoModel>> searchPhotos({
    required String query,
    required int page,
  }) {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }

    return Future.value(photosToReturn);
  }
}

class MockFavoritePhotosService implements FavoritePhotosService {
  final List<PhotoModel> photosToReturn;
  final Exception? exceptionToThrow;

  const MockFavoritePhotosService({
    required this.photosToReturn,
    this.exceptionToThrow,
  });

  @override
  Future<void> addFavoritePhoto({required PhotoModel photo}) {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }

    return Future.value();
  }

  @override
  List<PhotoModel> getFavoritePhotos() {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }

    return photosToReturn;
  }

  @override
  Future<void> removeFavoritePhoto({required String photoId}) {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }

    return Future.value();
  }
}
