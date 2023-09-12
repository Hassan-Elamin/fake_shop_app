// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

const ColorScheme LightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF535EF8),
  secondary: Color(0XFF13134F),
  surface: Color(0XFF57D9FD),
  background: Color(0xffFFFFFF),
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.black,
  onBackground: Colors.black,
  error: Colors.red,
  onError: Colors.white,
);

const ColorScheme DarkScheme = ColorScheme(
  primary: Color(0xff8F17E5),
  secondary: Color(0xffF5E1FF),
  surface: Color(0xff3D0075),
  background: Color(0XFF2D2D2D),
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: Colors.white,
  onBackground: Colors.white,
  brightness: Brightness.dark,
  error: Colors.red,
  onError: Colors.black,
);
