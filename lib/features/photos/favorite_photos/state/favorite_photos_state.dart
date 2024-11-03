import 'package:flutter/foundation.dart';

import '../../../features.dart';

class FavoritePhotosState {
  final List<PhotoModel> favoritePhotos;
  final String? photoBeingRemoved;
  final String? photoBeingAdded;

  const FavoritePhotosState({
    required this.favoritePhotos,
    this.photoBeingRemoved,
    this.photoBeingAdded,
  });

  FavoritePhotosState copyWith({
    List<PhotoModel>? favoritePhotos,
    String? photoBeingRemoved,
    String? photoBeingAdded,
  }) {
    return FavoritePhotosState(
      favoritePhotos: favoritePhotos ?? this.favoritePhotos,
      photoBeingRemoved: photoBeingRemoved ?? this.photoBeingRemoved,
      photoBeingAdded: photoBeingAdded ?? this.photoBeingAdded,
    );
  }

  FavoritePhotosState clearPhotoBeingAdded() {
    return FavoritePhotosState(
      favoritePhotos: favoritePhotos,
      photoBeingRemoved: photoBeingRemoved,
      photoBeingAdded: null,
    );
  }

  FavoritePhotosState clearPhotoBeingRemoved() {
    return FavoritePhotosState(
      favoritePhotos: favoritePhotos,
      photoBeingRemoved: null,
      photoBeingAdded: photoBeingAdded,
    );
  }

  @override
  String toString() =>
      'FavoritePhotosState(favoritePhotos: $favoritePhotos, photoBeingRemoved: $photoBeingRemoved, photoBeingAdded: $photoBeingAdded)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FavoritePhotosState &&
        listEquals(other.favoritePhotos, favoritePhotos) &&
        other.photoBeingRemoved == photoBeingRemoved &&
        other.photoBeingAdded == photoBeingAdded;
  }

  @override
  int get hashCode =>
      favoritePhotos.hashCode ^
      photoBeingRemoved.hashCode ^
      photoBeingAdded.hashCode;

  Set<String> get favoritePhotoIds =>
      favoritePhotos.map((photo) => photo.id).toSet();
}
