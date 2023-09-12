import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String name;
  final void Function() onPressed;
  final double minWidth;
  final IconData? icon;

  const GradientButton({
    required this.name,
    required this.onPressed,
    this.icon,
    this.minWidth = 100.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0.0),
          elevation: 5,
          minimumSize: Size.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          )),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            colors: [scheme.primary.withOpacity(0.5), scheme.primary],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(minWidth: minWidth),
          child: icon != null
              ? Row(
                  children: [
                    Icon(
                      icon,
                      color: scheme.onPrimary,
                    ),
                    Text(
                      name.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onPrimary),
                    ),
                  ],
                )
              : Text(
                  name.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: scheme.onPrimary),
                ),
        ),
      ),
    );
  }
}
