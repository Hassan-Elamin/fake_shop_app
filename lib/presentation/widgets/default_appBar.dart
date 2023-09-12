import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? barTitle;

  @override
  final Size preferredSize;
  const DefaultAppBar({
    super.key,
    this.barTitle,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return AppBar(
      title: barTitle != null
          ? Text(
              barTitle!,
              style: const TextStyle(),
            ).tr()
          : null,
      elevation: 0,
      centerTitle: true,
      backgroundColor: scheme.background,
      foregroundColor: scheme.primary,
    );
  }
}
