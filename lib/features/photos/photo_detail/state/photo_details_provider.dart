import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

const _photoDetailTag = 'photo_detail';

final photoDetailProvider =
    FutureProvider.autoDispose.family<PhotoModel, String>(
  (ref, photoId) async {
    final photoService = ref.read(photosServiceProvider);
    try {
      final photoFromFavorites =
          ref.read(favoritePhotosProvider).favoritePhotos.firstWhereOrNull(
                (photo) => photo.id == photoId,
              );

      if (photoFromFavorites != null) {
        return photoFromFavorites;
      }

      final photoFromFetchedPhotos =
          ref.read(photosProvider).photos.firstWhereOrNull(
                (photo) => photo.id == photoId,
              );

      if (photoFromFetchedPhotos != null) {
        return photoFromFetchedPhotos;
      }

      final photo = await photoService.getPhoto(photoId: photoId);
      return photo;
    } catch (e, st) {
      ref.read(errorReportingServiceProvider).recordError(
            error: e,
            stackTrace: st,
            tag: _photoDetailTag,
          );
      throw const PhotoFailure(type: PhotoFailureType.photoDetailError);
    }
  },
);
