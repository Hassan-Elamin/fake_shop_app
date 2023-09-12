import 'dart:io';

import 'package:fake_shop_app/data/models/user_model.dart';

// An Input Model Created for the input method to separate between the input data which's have a password
// and the output data
class UserEntity {
  String username;
  String email;
  String password;
  File? image;
  UserAddress address;
  DateTime? birthdate;
  Gender? gender;

  UserEntity({
    required this.email,
    required this.username,
    required this.password,
    required this.address,
    this.birthdate,
    this.image,
    this.gender,
  });
}
