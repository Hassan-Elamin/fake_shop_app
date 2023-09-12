// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/core/helper/text_field_validator.dart';
import 'package:fake_shop_app/data/data_sources/firebase/firebase_auth.dart';
import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:fake_shop_app/business_logic/cubit/settings_cubit/settings_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/user_cubit.dart/user_cubit.dart';
import 'package:fake_shop_app/presentation/widgets/app_snackbar.dart';
import 'package:fake_shop_app/presentation/widgets/auth_text_field.dart';
import 'package:fake_shop_app/presentation/widgets/custom_widgets/custom_widgets.dart';
import 'package:fake_shop_app/presentation/widgets/default_appBar.dart';
import 'package:fake_shop_app/presentation/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  FirebaseAuthServices authServices = FirebaseAuthServices();

  InputDecoration textField_decor() {
    return const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 8));
  }

  Widget textField() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextField(
        decoration: textField_decor(),
      ),
    );
  }

  void fakeNav() {
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry());
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = DesignHelper.getTheSize(context);
    final Box settingsBox = HiveServices.app_settings;
    UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    SettingsCubit settingsCubit = SettingsCubit.of(context);
    void showMessage(String message) =>
        MessageSnackBar(message: message).showSnackBar(context);

    final NavigatorState navigator = Navigator.of(context);

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          appBar: const DefaultAppBar(
            barTitle: 'Sign in',
          ),
          body: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: size.height * 0.35,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AuthTextField(
                                controller: emailController,
                                hintText: 'email',
                                textInputType: TextInputType.emailAddress,
                                validator: Validator.usernameValidator,
                              ),
                              AuthTextField(
                                controller: passwordController,
                                hintText: 'password',
                                textInputType: TextInputType.visiblePassword,
                                validator: Validator.passwordValidator,
                              ),
                              TextButton(
                                  onPressed: () =>
                                      navigator.pushNamed('/reset_password'),
                                  child: Text(
                                    'Forget password ?'.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  )),
                              GradientButton(
                                onPressed: () async {
                                  String? message;
                                  if (state is UserSignedIn) {
                                    message = await userCubit.changeAccount(
                                        emailController.text,
                                        passwordController.text);
                                  } else {
                                    message = await userCubit.login(
                                        emailController.text,
                                        passwordController.text);
                                  }
                                  if (message != null) {
                                    showMessage(message);
                                  } else {
                                    settingsCubit.emitState = DefaultSettings(
                                      settingsBox.get('theme'),
                                      settingsBox.get('lang'),
                                      const [],
                                    );
                                    navigator.pushNamedAndRemoveUntil(
                                        '/', (route) => false);
                                  }
                                },
                                name: 'confirm',
                              ),
                            ],
                          ),
                        ),
                        CustomWidgets().customDivider(),
                        TextButton(
                          child: const Text(
                            'Create new account',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ).tr(),
                          onPressed: () => navigator.pushNamed('/sign-up'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              state is UserDataLoading ? state.loadingDialog : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
