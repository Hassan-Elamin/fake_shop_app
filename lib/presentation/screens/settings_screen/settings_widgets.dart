import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/business_logic/cubit/settings_cubit/settings_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/user_cubit.dart/user_cubit.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/data/models/language_model.dart';
import 'package:fake_shop_app/presentation/widgets/account_img_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsWidgets {
  final BuildContext context;

  late final Size size;
  late final ColorScheme scheme;
  late final SettingsCubit _settingsCubit;

  SettingsWidgets({required this.context}) {
    size = DesignHelper.getTheSize(context);
    scheme = DesignHelper.getScheme(context);
    _settingsCubit = SettingsCubit.of(context);
  }

  Widget widgetBody(
          {double marginV = 0,
          double marginH = 0,
          Widget child = const SizedBox()}) =>
      Container(
        margin: EdgeInsets.symmetric(vertical: marginV, horizontal: marginH),
        padding: const EdgeInsets.all(5),
        child: Material(
          color: scheme.background,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          clipBehavior: Clip.hardEdge,
          child: child,
        ),
      );

  Widget listButton(IconData icon, String name, [void Function()? onTap]) {
    return MaterialButton(
      onPressed: onTap ?? () {},
      padding: const EdgeInsets.all(0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.symmetric(
          horizontal: BorderSide(
            width: 0.1,
            color: scheme.background,
          ),
        )),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: Icon(
                icon,
                size: 20,
              ),
            ),
            Text(
              name.tr(),
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget navigateButton(IconData icon, String btnName, String route) {
    return widgetBody(
      marginV: 2.5,
      child: MaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        padding: const EdgeInsets.all(0),
        elevation: 2,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(icon),
            ),
            Text(btnName).tr(),
          ],
        ),
      ),
    );
  }

  Widget themeSwitch(SettingsState state) {
    return widgetBody(
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.dark_mode),
                ),
                Text(
                  'dark mode'.tr(),
                  style: const TextStyle(fontSize: 17.5),
                ),
              ],
            ),
            Switch(
              value: state is DefaultSettings
                  ? state.themeModel.name == 'dark'
                  : state is OfflineSettings
                      ? state.currentTheme.name == 'dark'
                      : false,
              onChanged: (value) => _settingsCubit.themeSwitch(),
            )
          ],
        ),
      ),
    );
  }

  Widget langDialogBtn(LanguageModel languageModel) {
    bool selected = _settingsCubit.currentLang == languageModel.langCode;
    return MaterialButton(
      onPressed: () {
        Navigator.pop(context);
        _settingsCubit.changeLang(languageModel.langCode);
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(
            width: 1,
            color: scheme.onBackground,
          )),
      minWidth: 0,
      padding: const EdgeInsets.all(15.0),
      color: selected ? scheme.primary : null,
      child: SizedBox(
        height: 50.0,
        width: 50.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language_outlined,
              size: 30,
              color: selected ? scheme.onPrimary : null,
            ),
            Text(
              languageModel.languageName,
              style: TextStyle(
                fontSize: 12.5,
                color: selected ? scheme.onPrimary : null,
              ),
            ).tr(),
          ],
        ),
      ),
    );
  }

  Widget userViewWidget(void Function() onTap) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return MaterialButton(
          height: 100,
          color: scheme.secondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 1,
          onPressed: onTap,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: state is UserSignedIn
                  ? <Widget>[
                      AccountImageViewer(
                          size: 35,
                          imageFile: state.userData.userOtherData.photo),
                      Container(
                        width: size.width * .6,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          state.userData.display_name,
                          style: TextStyle(
                              fontSize: 20,
                              overflow: TextOverflow.ellipsis,
                              color: scheme.onSecondary),
                        ),
                      ),
                    ]
                  : <Widget>[
                      AccountImageViewer(size: 35),
                      Center(
                        child: const Text('you are not signed in yet').tr(),
                      ),
                      const Icon(Icons.arrow_right_alt),
                    ]),
        );
      },
    );
  }
}
