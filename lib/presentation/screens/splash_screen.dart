import 'dart:async';

import 'package:fake_shop_app/business_logic/cubit/settings_cubit/settings_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/user_cubit.dart/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool finished = false;

  double marginR = 450;
  double marginB = 225;
  double _opacity = 0;

  @override
  void initState() {
    var settingsCubit = SettingsCubit.of(context);
    Timer(
        const Duration(milliseconds: 500),
        () => setState(() {
              marginR = 0;
              marginB = 0;
            }));
    Timer(
        const Duration(milliseconds: 1500), () => setState(() => _opacity = 1));
    Timer(const Duration(seconds: 2), () async {
      if (settingsCubit.state is FirstTimeSettings) {
        Navigator.pushNamed(context, '/onBoarding');
      } else {
        BlocProvider.of<UserCubit>(context).state is UserSignedIn
            ? Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false)
            : Navigator.pushNamedAndRemoveUntil(
                context, '/sign-in', (route) => false);
      }
    });
    super.initState();
  }

  Future<void> setUp() async {}

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {},
      child: Scaffold(
        body: Center(
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: 200,
            width: 200,
            margin: EdgeInsets.only(right: marginR, bottom: marginB),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/app_logo.png',
                  fit: BoxFit.cover,
                ),
                Text(
                  'Fake Shop',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(_opacity)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
