import 'package:flutter/foundation.dart';

import '../../features.dart';

class PhotosState {
  const PhotosState({
    required this.photos,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.failure,
  });

  final List<PhotoModel> photos;
  final bool isLoading;
  final int page;
  final bool isLoadingMore;
  final bool hasMore;
  final PhotoFailure? failure;

  PhotosState copyWith({
    List<PhotoModel>? photos,
    bool? isLoading,
    int? page,
    bool? isLoadingMore,
    bool? hasMore,
    PhotoFailure? failure,
  }) {
    return PhotosState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      failure: failure ?? this.failure,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhotosState &&
        listEquals(other.photos, photos) &&
        other.isLoading == isLoading &&
        other.page == page &&
        other.isLoadingMore == isLoadingMore &&
        other.hasMore == hasMore &&
        other.failure == failure;
  }

  @override
  int get hashCode {
    return photos.hashCode ^
        isLoading.hashCode ^
        page.hashCode ^
        isLoadingMore.hashCode ^
        hasMore.hashCode ^
        failure.hashCode;
  }

  @override
  String toString() {
    return 'PhotosState(photos: $photos, isLoading: $isLoading, page: $page, isLoadingMore: $isLoadingMore, hasMore: $hasMore, failure: $failure)';
  }
}
