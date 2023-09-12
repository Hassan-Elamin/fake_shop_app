// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:fake_shop_app/constants/color_scheme.dart';
import 'package:fake_shop_app/res/i_font_res.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  ThemeData call({required ColorScheme colorScheme}) {
    return ThemeData(
      fontFamily: FontRes.NOTOSANSARABIC_REGULAR,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(),
      ),
      cardColor: colorScheme.surface,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
      ),
      useMaterial3: true,
      shadowColor: colorScheme.onBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
      ),
    );
  }
}

class ThemeModel extends Equatable {
  final String name;
  final Brightness brightness;
  final ColorScheme scheme;
  final Color borderColor;

  late final ThemeData themeData;

  final AppThemeData _themeData = AppThemeData();

  ThemeModel(
      {required this.name,
      required this.scheme,
      required this.borderColor,
      required this.brightness}) {
    themeData = _themeData(colorScheme: scheme);
  }

  @override
  List<Object?> get props => [brightness, name];
}

ThemeModel LightTheme = ThemeModel(
  name: 'light',
  brightness: Brightness.light,
  scheme: LightScheme,
  borderColor: Colors.black,
);

ThemeModel DarkTheme = ThemeModel(
  name: 'dark',
  brightness: Brightness.dark,
  scheme: DarkScheme,
  borderColor: Colors.white,
);

ThemeModel getTheTheme(String themeName) =>
    themeName == 'dark' ? DarkTheme : LightTheme;
