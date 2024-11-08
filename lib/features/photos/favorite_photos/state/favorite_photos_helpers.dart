import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class FavoritePhotosHelpers {
  static Future<void> toggleFavoritePhoto({
    required FavoritePhotosController controller,
    required List<PhotoModel> favoritePhotos,
    required PhotoModel photo,
    required BuildContext context,
  }) async {
    if (!favoritePhotos.contains(photo)) {
      unawaited(controller.addFavoritePhoto(photo));
      HapticFeedback.mediumImpact().ignore();
      return;
    }

    _onRemovePhotoFromFavorites(
      context: context,
      controller: controller,
      favoritePhotos: favoritePhotos,
      photo: photo,
    );
  }

  static Future<void> _onRemovePhotoFromFavorites({
    required BuildContext context,
    required FavoritePhotosController controller,
    required List<PhotoModel> favoritePhotos,
    required PhotoModel photo,
  }) async {
    HapticFeedback.lightImpact().ignore();
    final shouldRemove = await showConfirmationDialog(
      context: context,
      content: 'Are you sure you want to remove this photo from favorites?',
      title: 'Remove from favorites',
      rightButtonText: 'Remove',
    );
    if (!shouldRemove) return;
    if (!context.mounted) return;

    HapticFeedback.mediumImpact().ignore();
    unawaited(
      controller.removeFavoritePhoto(photo.id),
    );
  }
}
