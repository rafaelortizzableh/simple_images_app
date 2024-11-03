class PhotoDetailNotFoundFailure implements Exception {
  const PhotoDetailNotFoundFailure();

  @override
  String toString() => 'Photo detail not found';
}
