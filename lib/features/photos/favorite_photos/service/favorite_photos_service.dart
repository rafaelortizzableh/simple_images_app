import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

final favoritePhotosServiceProvider =
    Provider.autoDispose<FavoritePhotosService>(
  (ref) => SharedPreferencesFavoritePhotosService(
    ref.read(sharedPreferencesServiceProvider),
  ),
);

abstract class FavoritePhotosService {
  Future<void> addFavoritePhoto({required PhotoModel photo});

  Future<void> removeFavoritePhoto({required String photoId});

  List<PhotoModel> getFavoritePhotos();
}

class SharedPreferencesFavoritePhotosService implements FavoritePhotosService {
  SharedPreferencesFavoritePhotosService(this._sharedPreferencesService);

  final SharedPreferencesService _sharedPreferencesService;

  @override
  Future<void> addFavoritePhoto({required PhotoModel photo}) async {
    final favoritePhotosSet = {
      ...getFavoritePhotos(),
      photo,
    };
    final favoritePhotos =
        favoritePhotosSet.map((photo) => photo.toJson()).toList();

    await _sharedPreferencesService.save(_storageKey, favoritePhotos);
  }

  @override
  Future<void> removeFavoritePhoto({required String photoId}) async {
    final favoritePhotos =
        getFavoritePhotos().where((photo) => photo.id != photoId).map((photo) {
      return photo.toJson();
    }).toList();

    await _sharedPreferencesService.save(_storageKey, favoritePhotos);
  }

  @override
  List<PhotoModel> getFavoritePhotos() {
    final favoritePhotosAsStrings = _sharedPreferencesService
        .getListOfStringsFromSharedPreferences(_storageKey);
    if (favoritePhotosAsStrings == null) {
      return [];
    }
    final photos = favoritePhotosAsStrings
        .map((photo) => PhotoModel.fromJson(photo))
        .toList();
    return photos;
  }

  static const _storageKey = 'favorite_photos';
}
