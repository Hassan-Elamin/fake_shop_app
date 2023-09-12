import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/services/one_signal_services.dart';
import 'package:fake_shop_app/core/router.dart';
import 'package:fake_shop_app/core/themes.dart';
import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:fake_shop_app/business_logic/cubit/settings_cubit/settings_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/user_cubit.dart/user_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OneSignalServices.oneSignalInit();
  await HiveServices().hiveInitial();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en', 'EN'),
      Locale('ar', 'AR'),
    ],
    path: "assets/languages",
    child: MyApp(router: AppRouter()),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter router;

  const MyApp({required this.router, super.key});

  @override
  Widget build(BuildContext context) {
    // To prevent the screen from rotating will app is working
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SettingsCubit(context: context), lazy: false),
        BlocProvider(
          create: (context) => UserCubit(
            settingsCubit: BlocProvider.of<SettingsCubit>(context),
          ),
          lazy: false,
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Fake Shop',
            theme: state is DefaultSettings
                ? state.themeModel.themeData
                : state is OfflineSettings
                    ? state.currentTheme.themeData
                    : LightTheme.themeData,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            debugShowCheckedModeBanner: false,
            showSemanticsDebugger: false,
            initialRoute: '/splash',
            onGenerateRoute: router.generateRoute,
          );
        },
      ),
    );
  }
}
