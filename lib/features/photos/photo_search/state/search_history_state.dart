import 'package:flutter/foundation.dart';

class SearchHistoryState {
  final List<String> searchQueries;
  final String? queryBeingRemoved;
  final String? queryBeingAdded;

  const SearchHistoryState({
    required this.searchQueries,
    this.queryBeingRemoved,
    this.queryBeingAdded,
  });

  SearchHistoryState copyWith({
    List<String>? searchQueries,
    String? queryBeingRemoved,
    String? queryBeingAdded,
  }) {
    return SearchHistoryState(
      searchQueries: searchQueries ?? this.searchQueries,
      queryBeingRemoved: queryBeingRemoved ?? this.queryBeingRemoved,
      queryBeingAdded: queryBeingAdded ?? this.queryBeingAdded,
    );
  }

  SearchHistoryState clearSearchQueryBeingAdded() {
    return SearchHistoryState(
      searchQueries: searchQueries,
      queryBeingRemoved: queryBeingRemoved,
      queryBeingAdded: null,
    );
  }

  SearchHistoryState clearSearchQueryBeingRemoved() {
    return SearchHistoryState(
      searchQueries: searchQueries,
      queryBeingRemoved: null,
      queryBeingAdded: queryBeingAdded,
    );
  }

  @override
  String toString() =>
      'SearchHistoryState(searchQueries: $searchQueries, queryBeingRemoved: $queryBeingRemoved, queryBeingAdded: $queryBeingAdded)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchHistoryState &&
        listEquals(other.searchQueries, searchQueries) &&
        other.queryBeingRemoved == queryBeingRemoved &&
        other.queryBeingAdded == queryBeingAdded;
  }

  @override
  int get hashCode =>
      searchQueries.hashCode ^
      queryBeingRemoved.hashCode ^
      queryBeingAdded.hashCode;
}
