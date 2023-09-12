// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/themes.dart';
import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:fake_shop_app/data/models/language_model.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/data/models/user_model.dart';
import 'package:fake_shop_app/business_logic/cubit/user_cubit.dart/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:restart_app/restart_app.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  late ThemeModel theme;
  late String currentLang;

  late Connectivity _connectivity;

  // ignore: unused_field
  late StreamSubscription _streamSubscription;
  late ConnectivityResult connectivityResult;

  late final Box _userDataBox;
  late final Box _settingsBox;

  final BuildContext context;

  SettingsCubit({required this.context}) : super(SettingsCubitInitial()) {
    _settingsBox = HiveServices.app_settings;
    _userDataBox = HiveServices.user_data;
    theme = getTheme;
    favoriteProducts = HiveServices().getFavList;
    currentLang = _settingsBox.get('lang') ?? 'en';
    _connectivity = Connectivity();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(checkConnectionState);

    settingsInitialize();
  }

  List<String> favoriteProducts = [];

  bool isFirstUse() => _settingsBox.get('first_time') ?? true;

  Future<void> settingsInitialize() async {
    connectivityResult = await _connectivity.checkConnectivity();
    bool isFirstTime = isFirstUse();
    if (isFirstTime) {
      emit(FirstTimeSettings(firstTime: true));
      firstUseInitial();
    } else {
      settingsInit();
    }
  }

  void settingsInit() {
    String theme = _settingsBox.get('theme');
    List<String> favorites = getFavoriteList();
    emitCurrentState(theme, currentLang, favorites);
  }

  Future<void> firstUseInitial() async {
    await _settingsBox.putAll({
      'theme': 'light',
      'lang': 'en',
      'first_time': false,
    });
    emit(FirstTimeSettings(firstTime: _settingsBox.get('first_time')));
  }

  checkConnectionState(ConnectivityResult connectivity) {
    if (connectivity == ConnectivityResult.wifi ||
        connectivity == ConnectivityResult.mobile) {
      if (state is OfflineSettings) {
        Restart.restartApp();
      } else {
        emit(DefaultSettings(theme.name, currentLang, favoriteProducts));
      }
    } else {
      emit(OfflineSettings());
    }
    connectivityResult = connectivity;
  }

  ThemeModel get getTheme {
    if (_settingsBox.get('theme') == 'dark') {
      return DarkTheme;
    } else {
      return LightTheme;
    }
  }

  static SettingsCubit of(BuildContext context) =>
      BlocProvider.of<SettingsCubit>(context);

  set emitState(SettingsState newState) {
    emit(newState);
  }

  void updateUserSettings() {
    var userOtherData = _userDataBox.get('other_data');
    var userSettings = userOtherData['settings'];
    UserSettings currentSettings = UserSettings.fromJson(userSettings);
    currentSettings.theme = theme.name;
    currentSettings.lang = currentLang;
    userOtherData['settings'] = currentSettings.toJson();
    _userDataBox.put('other_data', userOtherData);
  }

  Future<void> settingsDataReload(UserCubit userCubit) async {
    UserOtherData userOtherData = await userCubit.restoreUserOtherData();
    UserSettings settings = userOtherData.userSettings;
    currentLang = userOtherData.userSettings.lang;
    theme = userOtherData.userSettings.currentTheme;
    changeLang(currentLang);
    changeTheme(theme.name);

    await _userDataBox.put('other_data', userOtherData.toJson());
    await _settingsBox.putAll(settings.toJson());
  }

  void emitCurrentState(String theme, String lang, List<String>? favorites) {
    if (connectivityResult == ConnectivityResult.none) {
      emit(OfflineSettings(theme, lang));
    } else {
      emit(DefaultSettings(theme, lang, favorites ?? favoriteProducts));
    }
  }

  void changeTheme(String theme) {
    if (theme == 'dark') {
      this.theme = DarkTheme;
    } else {
      this.theme = LightTheme;
    }
    _settingsBox.put('theme', theme);
    updateUserSettings();
    emit(DefaultSettings(theme, currentLang, favoriteProducts));
  }

  void themeSwitch() {
    String themeName;
    if (theme == LightTheme) {
      theme = DarkTheme;
      themeName = 'dark';
    } else if (theme == DarkTheme) {
      theme = LightTheme;
      themeName = 'light';
    } else {
      theme = LightTheme;
      themeName = 'light';
    }
    updateUserSettings();
    _settingsBox.put('theme', themeName);
    emitCurrentState(themeName, currentLang, favoriteProducts);
  }

  void changeLang(String lang) {
    Locale locale;
    if (lang == 'ar') {
      locale = ArabicLanguage.locale;
    } else {
      locale = EnglishLanguage.locale;
    }
    currentLang = lang;
    context.setLocale(locale);
    updateUserSettings();
  }

  List<String> getFavoriteList() {
    List<String> productsCode = HiveServices().getFavList;
    return productsCode;
  }

  void productInFavorites(ProductModel product) {
    if (favoriteProducts.contains(product.id)) {
      removeFromFavorite(product);
    } else {
      addToFavorite(product);
    }
  }

  void addToFavorite(ProductModel product) {
    favoriteProducts.add(product.id);
    emit(DefaultSettings(theme.name, currentLang, favoriteProducts));
    HiveServices().putFavList(favoriteProducts);
  }

  void removeFromFavorite(ProductModel product) {
    favoriteProducts.removeWhere((element) => element == product.id);
    emit(DefaultSettings(theme.name, currentLang, favoriteProducts));
    HiveServices().putFavList(favoriteProducts);
  }

  Future<void> restSettings() async {
    String themeName = 'light';
    currentLang = 'en';
    await _settingsBox.putAll({
      'lang': 'en',
      'theme': 'light',
    });
    changeLang(currentLang);
    emit(DefaultSettings(themeName, currentLang, favoriteProducts));
  }
}
