import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppBorders {
  final BuildContext _context;
  late ColorScheme _colorScheme;

  AppBorders({required BuildContext context}) : _context = context {
    _colorScheme = Theme.of(_context).colorScheme;
  }

  BoxDecoration boxDecoration() => BoxDecoration(
        border: Border.all(
          width: 1,
          color: _colorScheme.onBackground,
        ),
        borderRadius: BorderRadius.circular(15.0),
      );

  RoundedRectangleBorder roundedRectangleBorder() => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
      side: BorderSide(
        width: 1,
        style: BorderStyle.solid,
        color: _colorScheme.onBackground,
      ));

  InputDecoration inputDecoration(String hint) => InputDecoration(
      border: InputBorder.none,
      hintText: hint.tr(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5.0));
}
