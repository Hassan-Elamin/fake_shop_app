import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/business_logic/cubit/settings_cubit/settings_cubit.dart';
import 'package:fake_shop_app/core/helper/dateTime_helper.dart';
import 'package:fake_shop_app/core/helper/image_helper.dart';
import 'package:fake_shop_app/data/data_sources/firebase/cloud_firestore.dart';
import 'package:fake_shop_app/data/data_sources/firebase/firebase_auth.dart';
import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:fake_shop_app/data/models/user_model.dart';
import 'package:fake_shop_app/data/repository/user_data_repository.dart';
import 'package:fake_shop_app/business_logic/entities/user_entity.dart';
import 'package:fake_shop_app/presentation/widgets/loading_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  late final UserDataRepository _userRepository;
  late final FirebaseAuthServices _authServices;
  late final FirestoreServices _firestoreServices;
  late final Box _userDataBox;
  late final Box _settingsBox;
  late final Box _purchaseBox;
  late UserModel currentUser;
  final SettingsCubit settingsCubit;

  UserCubit({required this.settingsCubit}) : super(UserInitial()) {
    _userRepository = UserDataRepository();
    _authServices = FirebaseAuthServices();
    _firestoreServices = FirestoreServices();
    //hive boxes
    _settingsBox = HiveServices.app_settings;
    _userDataBox = HiveServices.user_data;
    _purchaseBox = HiveServices.purchase_history;
    if (_userDataBox.isNotEmpty) {
      currentUser = UserModel.fromJson(_userDataBox.toMap());
      emit(UserSignedIn(userData: currentUser));
      checkWeeklyBackup();
    } else {
      emit(UserNotSigned());
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      emit(UserDataLoading());
      currentUser = await _userRepository.login(email, password);
      bool hasStorage =
          await _firestoreServices.isUserHasStorage(currentUser.uid);
      if (hasStorage) {
        currentUser.userOtherData = await restoreUserOtherData();
        List<dynamic> transactions =
            await _firestoreServices.getUserPurchaseHistory(currentUser.uid);
        Map map = {};
        for (Map<dynamic, dynamic> mapElement in transactions) {
          map[mapElement['id']] = mapElement;
        }
        await _purchaseBox.putAll(map);
      } else {
        await backupUserOtherData();
      }
      await _userDataBox.putAll(currentUser.toJson());
      await _settingsBox
          .putAll(currentUser.userOtherData.userSettings.toJson());
      settingsCubit.updateUserSettings();
      emit(UserSignedIn(userData: currentUser));
      return null;
    } catch (exception) {
      String e = exception.toString();
      emit(UserNotSigned());
      if (e.contains('The password is invalid')) {
        return 'password is wrong'.tr();
      } else if (e.contains('There is no user')) {
        return 'there is no user  connected with that email'.tr();
      } else {
        return exception.toString();
      }
    }
  }

  Future<String?> changeAccount(String email, String password) async {
    try {
      emit(UserDataLoading());
      UserModel userModel = await _userRepository.login(email, password);
      bool hasStorage =
          await _firestoreServices.isUserHasStorage(userModel.uid);
      if (hasStorage) {
        userModel.userOtherData = await restoreUserOtherData(userModel.uid);
        List<dynamic> transactions =
            await _firestoreServices.getUserPurchaseHistory(userModel.uid);
        Map map = {};
        for (Map<dynamic, dynamic> mapElement in transactions) {
          map[mapElement['id']] = mapElement;
        }
        await _purchaseBox.putAll(map);
      } else {
        await backupUserOtherData(
          UserOtherData(
            address: userModel.userOtherData.address,
            userSettings: UserSettings(
              theme: currentUser.userOtherData.userSettings.theme,
              lang: currentUser.userOtherData.userSettings.lang,
              last_update: DateTime.now(),
            ),
          ),
        );
      }
      currentUser = userModel;
      final UserSettings settings = currentUser.userOtherData.userSettings;
      await _userDataBox.putAll(userModel.toJson());
      await _settingsBox.putAll(userModel.userOtherData.userSettings.toJson());
      settingsCubit.changeTheme(settings.theme);
      settingsCubit.changeLang(settings.lang);
      emit(UserSignedIn(userData: userModel));
      return null;
    } catch (exception) {
      emit(UserSignedIn(userData: currentUser));
      print(exception.toString());
      return exception.toString();
    }
  }

  Future<String> register(UserEntity entity) async {
    try {
      await FirebaseAuthServices().register(entity).then(
        (String? uid) async {
          if (uid != null) {
            await _firestoreServices.createUserDataStorage(
              uid: uid,
              otherData: UserOtherData(
                address: entity.address,
                birthdate: entity.birthdate,
                gender: entity.gender != null ? entity.gender!.name : null,
                photo: entity.image,
                favoriteProducts: [],
                userSettings: UserSettings(
                  theme: _settingsBox.get('theme') ?? 'light',
                  last_update: DateTime.now(),
                  lang: _settingsBox.get('lang'),
                ),
              ),
            );
            await _firestoreServices.addUserTransactionsHistory(uid: uid);
          } else {
            return ('something wrong with register');
          }
        },
      );
      return 'success ! now you need to login';
    } catch (exception) {
      print(exception.toString());
      return exception.toString();
    }
  }

  Future<bool> resetPassword(String email) async {
    bool sent = false;
    await _authServices.sendPasswordRestMessage(email).whenComplete(() {
      sent = true;
    });
    return sent;
  }

  Future<String> backupUserOtherData([UserOtherData? newData]) async {
    try {
      UserOtherData data;
      if (newData == null) {
        UserOtherData otherData =
            UserOtherData.fromJson(_userDataBox.toMap()['other_data']);
        otherData.userSettings = UserSettings(
            theme: _settingsBox.get('theme'),
            last_update: DateTime.now(),
            lang: _settingsBox.get('lang'));
        data = otherData;
      } else {
        data = newData;
      }
      await _firestoreServices.updateData(currentUser.uid, data);
      return 'backup success';
    } catch (exception) {
      return 'backup failed : ${exception.toString()}';
    }
  }

  Future<UserOtherData> restoreUserOtherData([String? uid]) async {
    try {
      Map<String, dynamic> data = await _firestoreServices
              .getUserSettingsData(uid ?? currentUser.uid) ??
          {};
      final userData = UserOtherData.fromJson(data);
      return userData;
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<void> checkWeeklyBackup() async {
    try {
      DateTime lastBackupDate = DateTime.parse(
          _userDataBox.get('other_data')['settings']['last_update']);
      if (DateTimeHelper.isBeforeWeek(lastBackupDate)) {
        await _firestoreServices.updateData(_userDataBox.get('uid'),
            UserOtherData.fromJson(_userDataBox.get('other_data')));
      }
    } catch (exception) {
      throw (exception.toString());
    }
  }

  Future<void> updateUserData({
    String? username,
    DateTime? birthdate,
    File? img,
    String? gender,
  }) async {
    try {
      if (username != null) {
        await _authServices.updateDisplayName(name: username).then((value) {
          currentUser.display_name = username;
        });
      }
      if (birthdate != null) {
        await _firestoreServices.updateSingleData(_userDataBox.get('uid'),
            {'birthdate': birthdate.toString()}).then((value) {
          currentUser.userOtherData.birthdate = birthdate;
        });
      }
      if (img != null) {
        String baseCode = ImageHelper().encodeImage(img);
        await _firestoreServices.updateSingleData(
            currentUser.uid, {'photo': baseCode}).then((value) {
          currentUser.userOtherData.photo = img;
        });
      }
      if (gender != null) {
        await _firestoreServices
            .updateSingleData(currentUser.uid, {'gender': gender});
        currentUser.userOtherData.gender = gender;
      }
      _userDataBox.putAll(currentUser.toJson());
      emit(UserSignedIn(userData: currentUser));
    } catch (exception) {
      if (username == null && birthdate == null) {
        throw ('error:there is no data to update');
      } else {
        throw (exception.toString());
      }
    }
  }

  Future<void> logOut() async {
    await _authServices.logOut();
    emit(UserNotSigned());
  }
}
