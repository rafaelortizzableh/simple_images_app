import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

final favoritePhotosProvider = StateNotifierProvider.autoDispose<
    FavoritePhotosController, FavoritePhotosState>(
  (ref) {
    final service = ref.read(favoritePhotosServiceProvider);
    final errorReportingService = ref.read(errorReportingServiceProvider);

    return FavoritePhotosController(
      service: service,
      errorReportingService: errorReportingService,
    );
  },
);

class FavoritePhotosController extends StateNotifier<FavoritePhotosState> {
  FavoritePhotosController({
    required FavoritePhotosService service,
    required ErrorReportingService errorReportingService,
  })  : _service = service,
        _errorReportingService = errorReportingService,
        super(_getInitialFavoritePhotos(service));

  final FavoritePhotosService _service;
  final ErrorReportingService _errorReportingService;

  static FavoritePhotosState _getInitialFavoritePhotos(
    FavoritePhotosService service,
  ) {
    final photos = service.getFavoritePhotos();
    return FavoritePhotosState(favoritePhotos: photos);
  }

  Future<void> addFavoritePhoto(PhotoModel photo) async {
    try {
      if (state.photoBeingAdded == photo.id) {
        return;
      }
      state = state.copyWith(photoBeingAdded: photo.id);

      await _service.addFavoritePhoto(photo: photo);
      final newPhotos = {...state.favoritePhotos, photo}.toList();
      final newState =
          state.copyWith(favoritePhotos: newPhotos).clearPhotoBeingAdded();
      state = newState;
    } catch (e, st) {
      _errorReportingService.recordError(
        error: e,
        stackTrace: st,
        tag: _tag,
      );
    }
  }

  Future<void> removeFavoritePhoto(String photoId) async {
    try {
      if (state.photoBeingRemoved == photoId) {
        return;
      }
      state = state.copyWith(photoBeingRemoved: photoId);
      await _service.removeFavoritePhoto(photoId: photoId);
      final newPhotos =
          state.favoritePhotos.where((photo) => photo.id != photoId).toList();
      final newState =
          state.copyWith(favoritePhotos: newPhotos).clearPhotoBeingRemoved();
      state = newState;
    } catch (e, st) {
      _errorReportingService.recordError(
        error: e,
        stackTrace: st,
        tag: _tag,
      );
    }
  }

  static const _tag = 'FavoritePhotosController';
}
