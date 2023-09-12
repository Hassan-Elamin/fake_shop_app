import 'package:fake_shop_app/business_logic/cubit/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';

class CustomWidgets {
  Widget customDivider({double thickness = 1.0}) => Divider(
        thickness: thickness,
        height: 15.0,
        indent: 15.0,
        endIndent: 15.0,
      );

  Widget offlineVisibility(
      {required SettingsState state, required Widget child}) {
    bool isOffline = state is OfflineSettings;
    return Visibility(
      visible: !isOffline,
      child: child,
    );
  }
}
