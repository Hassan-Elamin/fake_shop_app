// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatefulWidget {
  final Function() onPressedYes;
  final void Function()? onPressedNo;
  String? dialogTitle;
  String? warning;
  String? onPressYes;

  ConfirmDialog(
      {this.dialogTitle,
      this.warning,
      this.onPressYes,
      required this.onPressedYes,
      this.onPressedNo,
      super.key});

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;

    Widget actionBtn(String name, void Function() onPressed) {
      return TextButton(
        onPressed: onPressed,
        child: Text(name.tr(),
            style: TextStyle(color: scheme.primary, fontSize: 20.0)),
      );
    }

    if (loading) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const Text(
                'loading',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.5),
              ).tr(),
            ],
          ),
        ),
      );
    } else {
      return AlertDialog(
        title: Text(
          widget.dialogTitle ?? ('Are you sure'),
          style: const TextStyle(fontSize: 22.5, fontWeight: FontWeight.w500),
        ).tr(),
        content: widget.warning == null
            ? const SizedBox()
            : Text(
                (widget.warning!),
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300,
                ),
              ).tr(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.end,
        actionsPadding: const EdgeInsets.all(10.0),
        titlePadding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        buttonPadding: const EdgeInsets.all(10.0),
        iconPadding: EdgeInsets.zero,
        actions: [
          actionBtn(
            'cancel',
            widget.onPressedNo ?? () => Navigator.pop(context),
          ),
          actionBtn(widget.onPressYes ?? 'yes', () async {
            setState(() => loading = true);
            await widget.onPressedYes();
          }),
        ],
      );
    }
  }
}
