import 'package:flutter_test/flutter_test.dart';
import 'package:simple_images_app/features/features.dart';

import '../../../fixtures.dart';

void main() {
  group('PhotoModel', () {
    test('Should be able to serialize and deserialize', () {
      // Given
      const photoModel = samplePhotoModel;

      // When
      final json = photoModel.toJson();
      final deserializedPhotoModel = PhotoModel.fromJson(json);

      // Then
      expect(deserializedPhotoModel, photoModel);
    });
  });
}
