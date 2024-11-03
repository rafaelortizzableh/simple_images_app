import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../features.dart';

final _unsplashHttpClientProvider = Provider.autoDispose<Dio>(
  (ref) {
    return Dio(
      BaseOptions(
        baseUrl: UnsplashPhotosService._apiBaseUrl,
        headers: {
          'Authorization': 'Client-ID ${UnsplashPhotosService._apiKey}',
        },
      ),
    );
  },
);

final photosServiceProvider = Provider.autoDispose<PhotosService>(
  (ref) => UnsplashPhotosService(
    client: ref.read(_unsplashHttpClientProvider),
  ),
);

abstract class PhotosService {
  Future<List<PhotoModel>> getPhotos({
    required int page,
  });

  Future<PhotoModel> getPhoto({required String photoId});

  Future<List<PhotoModel>> searchPhotos({
    required String query,
    required int page,
  });
}

class UnsplashPhotosService implements PhotosService {
  const UnsplashPhotosService({
    required Dio client,
  }) : _client = client;

  final Dio _client;

  static const _apiKey = AppConstants.unsplashApiKey;

  static const _apiBaseUrl = 'https://api.unsplash.com/';

  @override
  Future<List<PhotoModel>> getPhotos({
    required int page,
  }) async {
    try {
      final response = await _client.get(
        'photos?page=$page',
      );

      final unwrappedList = response.data as List;
      final filteredList = unwrappedList.where(
        (element) => element['sponsorship'] == null,
      );
      final photos = filteredList
          .map(
            (photo) => PhotoModel.fromUnsplash(photo),
          )
          .toList();
      return photos;
    } catch (e, st) {
      _handleError(e, st);
    }
  }

  @override
  Future<PhotoModel> getPhoto({required String photoId}) async {
    try {
      final response = await _client.get(
        'photos/$photoId',
      );

      final photo = PhotoModel.fromUnsplash(response.data);

      return photo;
    } catch (e, st) {
      _handleError(e, st);
    }
  }

  @override
  Future<List<PhotoModel>> searchPhotos({
    required String query,
    required int page,
  }) async {
    try {
      final response = await _client.get(
        'search/photos?page=$page&query=$query',
      );

      final unwrappedList = response.data['results'] as List;
      final filteredList = unwrappedList.where(
        (element) => element['sponsorship'] == null,
      );
      final photos = filteredList
          .map(
            (photo) => PhotoModel.fromUnsplash(photo),
          )
          .toList();
      return photos;
    } catch (e, st) {
      _handleError(e, st);
    }
  }

  Never _handleError(Object error, StackTrace stackTrace) {
    if (error is DioException) {
      _handleDioException(error, stackTrace);
    }
    if (error is SerializationFailure) {
      Error.throwWithStackTrace(
        error,
        stackTrace,
      );
    }

    Error.throwWithStackTrace(
      ApiRequestFailure(
        error: error,
      ),
      stackTrace,
    );
  }

  Never _handleDioException(DioException exception, StackTrace stackTrace) {
    if (exception.type == DioExceptionType.connectionError) {
      Error.throwWithStackTrace(
        const NoInternetConnectionFailure(),
        stackTrace,
      );
    }

    if (exception.type == DioExceptionType.badResponse) {
      _handleBadResponse(exception, stackTrace);
    }

    if (exception.type == DioExceptionType.cancel) {
      Error.throwWithStackTrace(
        ApiCancelledFailure(
          error: exception,
        ),
        stackTrace,
      );
    }

    if (exception.response?.statusCode == 404) {
      Error.throwWithStackTrace(
        const PhotoDetailNotFoundFailure(),
        stackTrace,
      );
    }

    if ((exception.response?.data as String?)?.toLowerCase().trim() ==
        'rate limit exceeded') {
      Error.throwWithStackTrace(
        const PhotosRateLimitExceeded(),
        stackTrace,
      );
    }

    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout) {
      Error.throwWithStackTrace(
        ApiTimeoutFailure(
          error: exception,
        ),
        stackTrace,
      );
    }

    Error.throwWithStackTrace(
      ApiRequestFailure(
        error: exception,
      ),
      stackTrace,
    );
  }

  Never _handleBadResponse(DioException exception, StackTrace stackTrace) {
    if (exception.response?.statusCode == 404) {
      Error.throwWithStackTrace(
        const NoPhotosFoundFailure(),
        stackTrace,
      );
    }

    Error.throwWithStackTrace(
      ApiInvalidResponseFailure(
        body: exception.response?.data ?? {},
        statusCode: exception.response?.statusCode ?? 400,
      ),
      stackTrace,
    );
  }
}
