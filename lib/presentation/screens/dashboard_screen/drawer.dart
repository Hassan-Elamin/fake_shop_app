import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/business_logic/cubit/settings_cubit/settings_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/user_cubit.dart/user_cubit.dart';
import 'package:fake_shop_app/presentation/screens/user_data_screen/user_data_screen.dart';
import 'package:fake_shop_app/presentation/widgets/account_img_view.dart';
import 'package:fake_shop_app/presentation/widgets/custom_widgets/custom_widgets.dart';
import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardDrawer extends Drawer {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CustomWidgets widgets = CustomWidgets();

    Widget drawerNavigateButton(IconData icon, String routeName) {
      String btnName = routeName.substring(1).toString();
      btnName = btnName.replaceFirst('_', " ");
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 0.25,
                    color: Theme.of(context).colorScheme.onBackground)),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(5),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                btnName.tr(),
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      );
    }

    Widget userProfileView(SettingsState settingsState) {
      return BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (settingsState is OfflineSettings) {
            return const SizedBox();
          } else {
            if (state is UserSignedIn) {
              var user = state.userData;
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return UserDataScreen();
                    },
                  ));
                },
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(AssetsRes.DRAWER_PROFILE_BANNER),
                    fit: BoxFit.fill,
                    opacity: 0.75,
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccountImageViewer(
                        size: 35,
                        imageFile: user.userOtherData.photo,
                      ),
                      Text(
                        user.display_name.toString(),
                        style: const TextStyle(
                            fontSize: 17.5, color: Colors.white),
                      ),
                      Text(
                        user.email.toString(),
                        style: const TextStyle(
                            fontSize: 12.5, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }
        },
      );
    }

    ColorScheme scheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: scheme.background,
      child: SafeArea(
        child: Center(
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return Column(
                children: [
                  userProfileView(state),
                  widgets.offlineVisibility(
                      state: state,
                      child: drawerNavigateButton(
                          Icons.shopping_bag, '/products')),
                  widgets.offlineVisibility(
                      state: state,
                      child: drawerNavigateButton(Icons.favorite, '/favorite')),
                  widgets.offlineVisibility(
                      state: state,
                      child: drawerNavigateButton(Icons.discount, '/offers')),
                  drawerNavigateButton(Icons.receipt, '/orders_history'),
                  drawerNavigateButton(Icons.settings, '/settings'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
