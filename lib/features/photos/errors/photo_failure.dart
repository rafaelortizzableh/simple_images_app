import '../../../core/core.dart';

class PhotoFailure implements Failure {
  const PhotoFailure({required this.type});

  final PhotoFailureType type;

  @override
  String get message => _failureMessages[type.code] ?? 'Unknown error';

  @override
  int? get code => type.code;

  @override
  Exception? get exception => null;

  Map<int, String> get _failureMessages {
    return {
      200: 'Oops! Something went wrong. Please try again later.',
      201:
          'Looks like you are not connected to the internet. Please check your connection and try again.',
      202:
          'Oops! Something went wrong when finding photos. Please try again later.',
      203:
          'Oops! Something went wrong when processing photos. Please try again later.',
      204: 'No photos found. Please try again with a different query.',
      205:
          'Oops! Something went wrong when getting photo details. Please try again later.',
      206: 'Photo Rate limit exceeded. Please try again later.',
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhotoFailure && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() => 'PhotoFailure(type: $type)';
}

enum PhotoFailureType {
  noInternetConnection(201),
  serverError(202),
  serializationError(203),
  noPhotosFound(204),
  photoDetailError(205),
  rateLimitExceeded(206),
  unknown(200);

  const PhotoFailureType(this.code);

  final int code;
}
