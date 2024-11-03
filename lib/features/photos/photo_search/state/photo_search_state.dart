import 'package:flutter/foundation.dart';

import '../../../features.dart';

class PhotoSearchState {
  final bool isLoading;
  final List<PhotoModel> photos;
  final int page;
  final PhotoFailure? failure;
  final bool hasMore;
  final String query;
  final bool isLoadingMore;

  const PhotoSearchState({
    this.isLoading = false,
    this.photos = const [],
    this.page = 1,
    this.failure,
    this.hasMore = true,
    this.query = '',
    this.isLoadingMore = false,
  });

  PhotoSearchState copyWith({
    bool? isLoading,
    List<PhotoModel>? photos,
    int? page,
    PhotoFailure? failure,
    bool? hasMore,
    String? query,
    bool? isLoadingMore,
  }) {
    return PhotoSearchState(
      isLoading: isLoading ?? this.isLoading,
      photos: photos ?? this.photos,
      page: page ?? this.page,
      failure: failure ?? this.failure,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  String toString() {
    return 'PhotoSearchState(isLoading: $isLoading, photos: $photos, page: $page, failure: $failure, hasMore: $hasMore, query: $query, isLoadingMore: $isLoadingMore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhotoSearchState &&
        other.isLoading == isLoading &&
        listEquals(other.photos, photos) &&
        other.page == page &&
        other.failure == failure &&
        other.hasMore == hasMore &&
        other.query == query &&
        other.isLoadingMore == isLoadingMore;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        photos.hashCode ^
        page.hashCode ^
        failure.hashCode ^
        hasMore.hashCode ^
        query.hashCode ^
        isLoadingMore.hashCode;
  }
}
