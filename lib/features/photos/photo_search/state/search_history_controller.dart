import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

final searchHistoryProvider = StateNotifierProvider.autoDispose<
    SearchHistoryController, SearchHistoryState>(
  (ref) {
    final service = ref.read(photoSearchHistoryServiceProvider);
    final errorReportingService = ref.read(errorReportingServiceProvider);

    return SearchHistoryController(
      service: service,
      errorReportingService: errorReportingService,
    );
  },
);

class SearchHistoryController extends StateNotifier<SearchHistoryState> {
  SearchHistoryController({
    required PhotoSearchHistoryService service,
    required ErrorReportingService errorReportingService,
  })  : _service = service,
        _errorReportingService = errorReportingService,
        super(_getInitialSearchHistory(service));

  final PhotoSearchHistoryService _service;
  final ErrorReportingService _errorReportingService;

  static SearchHistoryState _getInitialSearchHistory(
    PhotoSearchHistoryService service,
  ) {
    final queries = service.getPreviousSearchQueries();
    return SearchHistoryState(searchQueries: queries);
  }

  Future<void> addSearchQuery(String searchQuery) async {
    try {
      if (state.queryBeingAdded == searchQuery) {
        return;
      }
      state = state.copyWith(queryBeingAdded: searchQuery);

      await _service.addSearchTerm(searchTerm: searchQuery);
      final newPhotos = {...state.searchQueries, searchQuery}.toList();
      final newState =
          state.copyWith(searchQueries: newPhotos).clearSearchQueryBeingAdded();
      state = newState;
    } catch (e, st) {
      _errorReportingService.recordError(
        error: e,
        stackTrace: st,
        tag: _tag,
      );
    }
  }

  Future<void> removeSearchQuery(String searchQuery) async {
    try {
      if (state.queryBeingRemoved == searchQuery) {
        return;
      }
      state = state.copyWith(queryBeingRemoved: searchQuery);
      await _service.removeSearchTerm(searchTerm: searchQuery);
      final newSearchQueries = state.searchQueries
          .where((photo) => searchQuery != searchQuery)
          .toList();
      final newState = state
          .copyWith(searchQueries: newSearchQueries)
          .clearSearchQueryBeingRemoved();
      state = newState;
    } catch (e, st) {
      _errorReportingService.recordError(
        error: e,
        stackTrace: st,
        tag: _tag,
      );
    }
  }

  static const _tag = 'SearchHistoryController';
}
