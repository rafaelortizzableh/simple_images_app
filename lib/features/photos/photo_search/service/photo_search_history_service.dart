import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';

final photoSearchHistoryServiceProvider =
    Provider.autoDispose<PhotoSearchHistoryService>(
  (ref) => SharedPreferencesPhotoSearchHistoryService(
    sharedPreferencesService: ref.read(sharedPreferencesServiceProvider),
  ),
);

class PhotoSearchHistoryService {
  Future<void> addSearchTerm({required String searchTerm}) async {}
  List<String> getPreviousSearchQueries() {
    return [];
  }

  Future<void> removeSearchTerm({required String searchTerm}) async {}
}

class SharedPreferencesPhotoSearchHistoryService
    implements PhotoSearchHistoryService {
  final SharedPreferencesService _sharedPreferencesService;
  SharedPreferencesPhotoSearchHistoryService({
    required SharedPreferencesService sharedPreferencesService,
  }) : _sharedPreferencesService = sharedPreferencesService;

  static const _storageKey = 'photo_search_history';

  @override
  Future<void> addSearchTerm({required String searchTerm}) async {
    final searchTermsSet = {
      ...getPreviousSearchQueries(),
      searchTerm,
    };
    final searchTerms = searchTermsSet.toList();

    await _sharedPreferencesService.save(_storageKey, searchTerms);
  }

  @override
  List<String> getPreviousSearchQueries() {
    final searchTerms = _sharedPreferencesService
        .getListOfStringsFromSharedPreferences(_storageKey);
    if (searchTerms == null) {
      return [];
    }
    return searchTerms;
  }

  @override
  Future<void> removeSearchTerm({required String searchTerm}) async {
    final searchTerms =
        getPreviousSearchQueries().where((term) => term != searchTerm).toList();

    await _sharedPreferencesService.save(_storageKey, searchTerms);
  }
}
