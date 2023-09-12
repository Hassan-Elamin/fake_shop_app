import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum MessageState { error, warning }

class MessageSnackBar extends StatelessWidget {
  final String message;
  final MessageState? messageState;

  const MessageSnackBar({super.key, required this.message, this.messageState});

  @override
  SnackBar build(BuildContext context) {
    Color backColor() {
      if (messageState != null) {
        if (messageState == MessageState.error) {
          return Theme.of(context).colorScheme.error;
        } else {
          return Colors.yellowAccent;
        }
      } else {
        return Theme.of(context).colorScheme.onBackground;
      }
    }

    return SnackBar(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      content: Text(message, style: const TextStyle(fontSize: 15.0)).tr(),
      backgroundColor: backColor(),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 2,
      margin: const EdgeInsets.all(10.0),
      showCloseIcon: true,
      duration: const Duration(seconds: 4),
    );
  }

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(build(context));
  }
}
