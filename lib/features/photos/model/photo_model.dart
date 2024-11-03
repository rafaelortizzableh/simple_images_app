import 'dart:convert';

class PhotoModel {
  final String smallPhotoUrl;
  final String regularPhotoUrl;
  final String largePhotoUrl;
  final PhotoAuthor photoAuthor;
  final String title;
  final int likes;
  final String id;

  const PhotoModel({
    required this.smallPhotoUrl,
    required this.regularPhotoUrl,
    required this.largePhotoUrl,
    required this.photoAuthor,
    required this.title,
    required this.likes,
    required this.id,
  });

  PhotoModel copyWith({
    String? smallPhotoUrl,
    String? regularPhotoUrl,
    String? largePhotoUrl,
    PhotoAuthor? photoAuthor,
    String? title,
    int? likes,
    String? id,
  }) {
    return PhotoModel(
      smallPhotoUrl: smallPhotoUrl ?? this.smallPhotoUrl,
      regularPhotoUrl: regularPhotoUrl ?? this.regularPhotoUrl,
      largePhotoUrl: largePhotoUrl ?? this.largePhotoUrl,
      photoAuthor: photoAuthor ?? this.photoAuthor,
      title: title ?? this.title,
      likes: likes ?? this.likes,
      id: id ?? this.id,
    );
  }

  factory PhotoModel.fromUnsplash(Map<String, dynamic> map) {
    return PhotoModel(
      id: map['id'],
      likes: (map['likes'] as int?) ?? 0,
      title: map['alt_description'] ?? 'No title',
      smallPhotoUrl: map['urls']?['small'],
      regularPhotoUrl: map['urls']?['regular'],
      largePhotoUrl: map['urls']?['full'],
      photoAuthor: PhotoAuthor.fromUnsplash(map['user']),
    );
  }

  @override
  String toString() {
    return 'PhotoModel(smallPhotoUrl: $smallPhotoUrl, regularPhotoUrl: $regularPhotoUrl, largePhotoUrl: $largePhotoUrl, photoAuthor: $photoAuthor, title: $title, likes: $likes, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhotoModel &&
        other.smallPhotoUrl == smallPhotoUrl &&
        other.regularPhotoUrl == regularPhotoUrl &&
        other.largePhotoUrl == largePhotoUrl &&
        other.photoAuthor == photoAuthor &&
        other.title == title &&
        other.likes == likes &&
        other.id == id;
  }

  @override
  int get hashCode {
    return smallPhotoUrl.hashCode ^
        regularPhotoUrl.hashCode ^
        largePhotoUrl.hashCode ^
        photoAuthor.hashCode ^
        title.hashCode ^
        likes.hashCode ^
        id.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'smallPhotoUrl': smallPhotoUrl,
      'regularPhotoUrl': regularPhotoUrl,
      'largePhotoUrl': largePhotoUrl,
      'photoAuthor': photoAuthor.toMap(),
      'title': title,
      'likes': likes,
      'id': id,
    };
  }

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    return PhotoModel(
      smallPhotoUrl: map['smallPhotoUrl'] ?? '',
      regularPhotoUrl: map['regularPhotoUrl'] ?? '',
      largePhotoUrl: map['largePhotoUrl'] ?? '',
      photoAuthor: PhotoAuthor.fromMap(map['photoAuthor']),
      title: map['title'] ?? '',
      likes: map['likes']?.toInt() ?? 0,
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PhotoModel.fromJson(String source) =>
      PhotoModel.fromMap(json.decode(source));
}

class PhotoAuthor {
  final String username;
  final String? name;
  final String? thumbnailProfilePicUrl;
  final String? profilePicUrl;
  final String? bio;

  const PhotoAuthor({
    required this.username,
    this.name,
    this.thumbnailProfilePicUrl,
    this.profilePicUrl,
    this.bio,
  });

  PhotoAuthor copyWith({
    String? username,
    String? name,
    String? thumbnailProfilePicUrl,
    String? profilePicUrl,
    String? bio,
  }) {
    return PhotoAuthor(
      username: username ?? this.username,
      name: name ?? this.name,
      thumbnailProfilePicUrl:
          thumbnailProfilePicUrl ?? this.thumbnailProfilePicUrl,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      bio: bio ?? this.bio,
    );
  }

  factory PhotoAuthor.fromUnsplash(
    Map<String, dynamic> map,
  ) {
    return PhotoAuthor(
      username: map['username'],
      name: map['name'],
      thumbnailProfilePicUrl: map['profile_image']?['small'],
      profilePicUrl: map['profile_image']?['medium'],
      bio: map['bio'],
    );
  }

  @override
  String toString() {
    return 'PhotoAuthor(username: $username, name: $name, thumbnailProfilePicUrl: $thumbnailProfilePicUrl, profilePicUrl: $profilePicUrl, bio: $bio)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhotoAuthor &&
        other.username == username &&
        other.name == name &&
        other.thumbnailProfilePicUrl == thumbnailProfilePicUrl &&
        other.profilePicUrl == profilePicUrl &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        name.hashCode ^
        thumbnailProfilePicUrl.hashCode ^
        profilePicUrl.hashCode ^
        bio.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'name': name,
      'thumbnailProfilePicUrl': thumbnailProfilePicUrl,
      'profilePicUrl': profilePicUrl,
      'bio': bio,
    };
  }

  factory PhotoAuthor.fromMap(Map<String, dynamic> map) {
    return PhotoAuthor(
      username: map['username'] ?? '',
      name: map['name'],
      thumbnailProfilePicUrl: map['thumbnailProfilePicUrl'],
      profilePicUrl: map['profilePicUrl'],
      bio: map['bio'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PhotoAuthor.fromJson(String source) =>
      PhotoAuthor.fromMap(json.decode(source));
}
