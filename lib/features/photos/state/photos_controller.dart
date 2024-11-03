import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../features.dart';

final photosProvider =
    StateNotifierProvider.autoDispose<PhotosController, PhotosState>(
  (ref) => PhotosController(
    photosService: ref.read(photosServiceProvider),
    errorReportingService: ref.read(errorReportingServiceProvider),
    state: const PhotosState(photos: []),
  ),
);

class PhotosController extends StateNotifier<PhotosState> {
  PhotosController({
    required PhotosService photosService,
    required ErrorReportingService errorReportingService,
    required PhotosState state,
  })  : _photosService = photosService,
        _errorReportingService = errorReportingService,
        super(state) {
    unawaited(getPhotos());
  }

  final PhotosService _photosService;
  final ErrorReportingService _errorReportingService;

  static const _tag = 'PhotosController';

  Future<void> getPhotos() async {
    if (state.isLoading) return;
    try {
      state = state.copyWith(
        isLoading: true,
        failure: null,
      );
      final photos = await _photosService.getPhotos(page: state.page);
      state = state.copyWith(
        isLoading: false,
        photos: photos,
        page: state.page + 1,
      );
    } on PhotoFailure catch (e, stackTrace) {
      _errorReportingService.recordError(
        error: e,
        stackTrace: stackTrace,
        tag: _tag,
      );

      state = state.copyWith(
        isLoading: false,
        failure: e,
      );
    } catch (e, stackTrace) {
      _errorReportingService.recordError(
        error: e,
        stackTrace: stackTrace,
        tag: _tag,
      );

      state = state.copyWith(
        isLoading: false,
        failure: const PhotoFailure(type: PhotoFailureType.unknown),
      );
    }
  }

  Future<void> getMorePhotos() async {
    if (state.isLoadingMore || !state.hasMore) return;

    try {
      state = state.copyWith(
        isLoadingMore: true,
        failure: null,
      );

      final photos = await _photosService.getPhotos(page: state.page);

      state = state.copyWith(
        isLoadingMore: false,
        photos: {...state.photos, ...photos}.toList(),
        page: state.page + 1,
      );
    } on PhotoFailure catch (e, stackTrace) {
      _errorReportingService.recordError(
        error: e,
        stackTrace: stackTrace,
        tag: _tag,
      );

      state = state.copyWith(
        isLoadingMore: false,
        failure: e,
      );
    } catch (e, stackTrace) {
      _errorReportingService.recordError(
        error: e,
        stackTrace: stackTrace,
        tag: _tag,
      );

      state = state.copyWith(
        isLoadingMore: false,
        failure: const PhotoFailure(type: PhotoFailureType.unknown),
      );
    }
  }
}
