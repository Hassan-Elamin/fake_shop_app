import 'package:flutter/material.dart';

//mixin used to give the constant variables used in every screen
mixin DesignHelper {
  static Size getTheSize(BuildContext context) => MediaQuery.of(context).size;

  static ColorScheme getScheme(BuildContext context) =>
      Theme.of(context).colorScheme;
}
