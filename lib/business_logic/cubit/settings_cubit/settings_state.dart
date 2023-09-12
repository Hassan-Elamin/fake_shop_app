// ignore_for_file: must_be_immutable

part of 'settings_cubit.dart';

@immutable
abstract class SettingsState {}

class SettingsCubitInitial extends SettingsState {}

class FirstTimeSettings extends SettingsState {
  bool firstTime;

  FirstTimeSettings({required this.firstTime});
}

class DefaultSettings extends SettingsState {
  final String lang;
  final List<String> favoriteProducts;
  late ThemeModel themeModel;

  DefaultSettings(String themeName, this.lang, this.favoriteProducts) {
    themeModel = getTheTheme(themeName);
  }
}

class OfflineSettings extends SettingsState {
  late final Box userDataBox;

  late final UserModel user;

  late UserSettings userSettings;
  late ThemeModel currentTheme;

  OfflineSettings([String? theme, String? lang]) {
    userDataBox = HiveServices.user_data;
    user = UserModel.fromJson(userDataBox.toMap());
    userSettings = user.userOtherData.userSettings;
    if (theme != null) {
      userSettings.theme = theme;
    }
    if (lang != null) {
      userSettings.lang = lang;
    }
    currentTheme = getTheTheme(userSettings.theme);
  }

  Widget connectionErrorWidget() => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.signal_cellular_connected_no_internet_0_bar_outlined,
                size: 125.0,
              ),
              Text(
                '${"We're sorry, but your're currently offline".tr()}\n${"Please check your internet connection and try again later".tr()}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15.0),
              ),
            ],
          ),
        ),
      );
}
