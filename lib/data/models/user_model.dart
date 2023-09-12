// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:fake_shop_app/core/helper/image_helper.dart';
import 'package:fake_shop_app/core/themes.dart';
import 'package:fake_shop_app/data/data_sources/firebase/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Gender { male, female }

class UserSettings {
  String theme;
  DateTime last_update;
  String lang;

  UserSettings({
    required this.theme,
    required this.last_update,
    required this.lang,
  });

  factory UserSettings.fromJson(Map<dynamic, dynamic> json) => UserSettings(
      theme: json['theme'],
      last_update: DateTime.parse(json['last_update']),
      lang: json['lang']);

  ThemeModel get currentTheme {
    if (theme == 'dark') {
      return DarkTheme;
    } else {
      return LightTheme;
    }
  }

  Map<String, dynamic> toJson() => {
        'theme': theme,
        'lang': lang,
        'last_update': last_update.toString(),
      };
}

class UserOtherData {
  DateTime? birthdate;
  File? photo;
  String? gender;
  List<String>? favoriteProducts;
  UserSettings userSettings;
  UserAddress address;

  late ImageHelper _pickerServices;

  UserOtherData({
    required this.address,
    this.birthdate,
    this.photo,
    this.gender,
    this.favoriteProducts,
    required this.userSettings,
  }) {
    _pickerServices = ImageHelper();
  }

  factory UserOtherData.fromJson(Map<dynamic, dynamic> json) => UserOtherData(
        address: UserAddress.fromJson(json['address']),
        birthdate: json['birthdate'] != null
            ? DateTime.parse(json['birthdate'])
            : null,
        photo: json['photo'] != null
            ? ImageHelper().decodeImage(json['photo']!)
            : null,
        gender: json['gender'],
        favoriteProducts: List<String>.from(json['favorites'] ?? []),
        userSettings: UserSettings.fromJson(json['settings']),
      );

  String? get getEncodedBirthdate {
    if (birthdate != null) {
      return birthdate.toString();
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'address': address.toJson(),
        'birthdate': getEncodedBirthdate,
        'photo': getEncodedImage,
        'favorites': favoriteProducts,
        'settings': userSettings.toJson(),
        'gender': gender,
      };

  Gender? userGender(String? gender) {
    if (gender != null) {
      if (gender == 'male') {
        return Gender.male;
      } else {
        return Gender.female;
      }
    } else {
      return null;
    }
  }

  String? get getEncodedImage {
    if (photo != null) {
      return _pickerServices.encodeImage(photo!);
    } else {
      return null;
    }
  }
}

class UserAddress {
  String street;
  String region;
  String city;

  UserAddress({
    required this.street,
    required this.city,
    required this.region,
  });

  factory UserAddress.fromJson(Map<dynamic, dynamic> json) => UserAddress(
        street: json['street'],
        city: json['city'],
        region: json['region'],
      );

  Map<String, dynamic> toJson() =>
      {'street': street, 'city': city, 'region': region};
}

class UserModel {
  String uid;
  String email;
  String display_name;
  UserOtherData userOtherData;

  UserModel({
    required this.uid,
    required this.email,
    required this.display_name,
    required this.userOtherData,
  });

  static Future<UserModel> fromFirebase(User user) async {
    return UserModel(
        uid: user.uid,
        email: user.email!,
        display_name: user.displayName ?? 'user${user.uid}',
        userOtherData: UserOtherData.fromJson(
            await FirestoreServices().getUserSettingsData(user.uid) ?? {}));
  }

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
        uid: json['uid'],
        email: json['email'],
        display_name: json['display_name'],
        userOtherData: UserOtherData.fromJson(json['other_data']),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'display_name': display_name.toString(),
        'other_data': userOtherData.toJson(),
      };
}
