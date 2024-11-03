class PhotosRateLimitExceeded implements Exception {
  const PhotosRateLimitExceeded();
  @override
  String toString() {
    return 'PhotosRateLimitExceeded';
  }
}
