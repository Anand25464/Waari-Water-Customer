
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:waari_water/features/auth/data/models/user_model.dart';
import 'package:waari_water/features/auth/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tUserModel = UserModel(
    phone: '1234567890',
    isVerified: true,
    pin: '1234',
  );

  test('should be a subclass of User entity', () async {
    // assert
    expect(tUserModel, isA<User>());
  });

  group('fromJson', () {
    test('should return a valid model', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('user.json'));

      // act
      final result = UserModel.fromJson(jsonMap);

      // assert
      expect(result, tUserModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      // act
      final result = tUserModel.toJson();

      // assert
      final expectedMap = {
        'phone': '1234567890',
        'isVerified': true,
        'pin': '1234',
      };
      expect(result, expectedMap);
    });
  });
}
