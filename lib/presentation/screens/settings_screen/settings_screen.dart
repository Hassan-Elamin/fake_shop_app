import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:fake_shop_app/data/models/language_model.dart';
import 'package:fake_shop_app/business_logic/cubit/settings_cubit/settings_cubit.dart'
// ignore: library_prefixes
    as sCubit;
import 'package:fake_shop_app/business_logic/cubit/user_cubit.dart/user_cubit.dart';
import 'package:fake_shop_app/presentation/screens/settings_screen/settings_widgets.dart';
import 'package:fake_shop_app/presentation/widgets/app_snackbar.dart';
import 'package:fake_shop_app/presentation/widgets/confirm_dialog.dart';
import 'package:fake_shop_app/presentation/widgets/custom_widgets/custom_widgets.dart';
import 'package:fake_shop_app/presentation/widgets/default_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:restart_app/restart_app.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Box settingsBox = HiveServices.app_settings;

  @override
  Widget build(BuildContext context) {
    SettingsWidgets widgets = SettingsWidgets(context: context);
    CustomWidgets customWidgets = CustomWidgets();
    sCubit.SettingsCubit settingsCubit = sCubit.SettingsCubit.of(context);
    UserCubit userCubit = BlocProvider.of<UserCubit>(context);

    void showLangSelectDialog() {
      List<LanguageModel> langs = [EnglishLanguage, ArabicLanguage];
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Languages',
              textAlign: TextAlign.center,
            ).tr(),
            content: SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      2, (index) => widgets.langDialogBtn(langs[index])),
                )),
          );
        },
      );
    }

    void backupData() => showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
              onPressedYes: () async {
                Navigator.pop(context);
                MessageSnackBar(message: await userCubit.backupUserOtherData());
              },
              dialogTitle: 'Backup Settings'),
        );

    void restoreData() => showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
            onPressedYes: () async {
              await userCubit.restoreUserOtherData().then(
                (value) async {
                  await settingsCubit
                      .settingsDataReload(userCubit)
                      .whenComplete(() => Navigator.pop(context));
                },
              );
            },
            dialogTitle: 'Restore Settings',
          ),
        );

    Future<void> resetSettings() async {
      await showDialog(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            onPressedYes: () async {
              await settingsCubit.restSettings().then(
                (none) async {
                  await Restart.restartApp();
                },
              );
            },
            warning:
                'current settings will return to the default \nyou can get it back later from the backup settings',
          );
        },
      );
    }

    return Scaffold(
      appBar: const DefaultAppBar(barTitle: 'Settings'),
      body: BlocBuilder<sCubit.SettingsCubit, sCubit.SettingsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: ListView(
              children: [
                customWidgets.offlineVisibility(
                  state: state,
                  child: widgets.widgetBody(
                    child: Column(
                      children: [
                        widgets.userViewWidget(
                            () => Navigator.pushNamed(context, '/user')),
                        widgets.listButton(
                            Icons.change_circle_outlined,
                            'Change account',
                            () => Navigator.pushNamed(context, '/sign-in')),
                        widgets.listButton(
                          Icons.logout_outlined,
                          'Log out',
                          () async => showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog(
                              onPressedYes: () async =>
                                  await BlocProvider.of<UserCubit>(context)
                                      .logOut()
                                      .then(
                                        (value) =>
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/sign-in',
                                                (route) => false),
                                      ),
                              dialogTitle: 'log out',
                              onPressYes: 'log out',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                customWidgets.customDivider(),
                widgets.widgetBody(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widgets.listButton(Icons.language, 'Language',
                          () => showLangSelectDialog()),
                      widgets.listButton(
                          Icons.history,
                          'orders history',
                          () =>
                              Navigator.pushNamed(context, '/orders_history')),
                      widgets.listButton(Icons.help_outline, 'Help and support',
                          () => Navigator.pushNamed(context, '/help-support')),
                    ],
                  ),
                ),
                customWidgets.offlineVisibility(
                  state: state,
                  child: widgets.widgetBody(
                    marginV: 10.0,
                    child: Column(
                      children: [
                        widgets.listButton(
                            Icons.restart_alt, 'Reset Settings', resetSettings),
                        widgets.listButton(Icons.backup, 'Backup Settings',
                            () => backupData()),
                        widgets.listButton(Icons.restore, 'Restore Settings',
                            () => restoreData()),
                      ],
                    ),
                  ),
                ),
                widgets.themeSwitch(state),
                widgets.navigateButton(
                    Icons.developer_mode_outlined, 'About Us', '/about-us'),
                widgets.navigateButton(
                    Icons.info_outline, 'Privacy Policy', '/privacy_policy'),
              ],
            ),
          );
        },
      ),
    );
  }
}
