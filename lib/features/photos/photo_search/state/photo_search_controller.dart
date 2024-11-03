import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_images_app/core/core.dart';

import '../../../features.dart';

final photoSearchProvider =
    StateNotifierProvider.autoDispose<PhotoSearchController, PhotoSearchState>(
        (ref) {
  return PhotoSearchController(
    photosService: ref.read(photosServiceProvider),
    errorReportingService: ref.read(errorReportingServiceProvider),
    state: const PhotoSearchState(),
  );
});

class PhotoSearchController extends StateNotifier<PhotoSearchState> {
  PhotoSearchController({
    required PhotosService photosService,
    required ErrorReportingService errorReportingService,
    required PhotoSearchState state,
  })  : _photosService = photosService,
        _errorReportingService = errorReportingService,
        super(state);

  final PhotosService _photosService;
  final ErrorReportingService _errorReportingService;

  static const _tag = 'PhotoSearchController';

  Future<void> searchPhotos({
    String? query,
    int? page,
  }) async {
    if (state.isLoading) return;
    if (!state.hasMore) return;
    if (state.isLoadingMore) return;

    try {
      final pageToFetch = page ?? state.page;
      if (!mounted) return;
      state = state.copyWith(
        isLoading: pageToFetch == 1,
        failure: null,
        isLoadingMore: pageToFetch > 1,
        query: query,
      );
      log('Searching photos for query: ${state.query} on page: $pageToFetch');
      final photos = await _photosService.searchPhotos(
        query: query ?? state.query,
        page: pageToFetch,
      );
      if (!mounted) return;
      state = state.copyWith(
        photos: {...state.photos, ...photos}.toList(),
        page: pageToFetch + 1,
        hasMore: photos.isNotEmpty,
      );
    } on PhotoFailure catch (e, stackTrace) {
      if (e is PhotosRateLimitExceeded) {
        state = state.copyWith(
          failure: const PhotoFailure(
            type: PhotoFailureType.rateLimitExceeded,
          ),
        );
        return;
      }

      _errorReportingService.recordError(
        error: e,
        stackTrace: stackTrace,
        tag: _tag,
      );

      if (!mounted) return;
      state = state.copyWith(failure: e);
    } catch (e, stackTrace) {
      _errorReportingService.recordError(
        error: e,
        stackTrace: stackTrace,
        tag: _tag,
      );

      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        failure: const PhotoFailure(type: PhotoFailureType.unknown),
      );
    } finally {
      if (mounted) {
        state = state.copyWith(isLoading: false, isLoadingMore: false);
      }
    }
  }

  void clearSearchResults() {
    if (!mounted) return;
    state = state.copyWith(photos: [], page: 1, hasMore: true);
  }
}
