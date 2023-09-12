import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:flutter/material.dart';

class CustomMaterialButton extends MaterialButton {
  final String text;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool transparent;

  const CustomMaterialButton({
    required this.text,
    required super.onPressed,
    this.transparent = false,
    this.textStyle,
    this.icon,
    super.minWidth,
    super.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = DesignHelper.getScheme(context);
    Widget buttonName() => Text(text.tr(),
        style: textStyle != null
            ? textStyle!.copyWith(color: colorScheme.onPrimary, fontSize: 15)
            : transparent
                ? TextStyle(
                    color: colorScheme.primary,
                  )
                : TextStyle(color: colorScheme.onPrimary, fontSize: 15));

    return MaterialButton(
      onPressed: super.onPressed,
      color: transparent ? colorScheme.background : colorScheme.primary,
      shape: RoundedRectangleBorder(
          side: transparent
              ? BorderSide(
                  width: 1,
                  color: colorScheme.primary,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.circular(15)),
      padding: super.padding,
      minWidth: minWidth,
      child: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  icon,
                  color: colorScheme.onPrimary,
                ),
                buttonName(),
              ],
            )
          : buttonName(),
    );
  }
}
