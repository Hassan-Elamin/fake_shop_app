import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final String? Function(String? value)? validator;
  final bool optional;

  const AuthTextField(
      {required this.controller,
      required this.hintText,
      required this.validator,
      this.textInputType = TextInputType.text,
      this.optional = false,
      Key? key})
      : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool isVisible = false;

  Icon _prefix() {
    switch (widget.hintText) {
      case 'email':
        return const Icon(Icons.email);
      case 'password':
        return const Icon(Icons.password);
      case 'confirm password':
        return const Icon(Icons.password);
      case 'username':
        return const Icon(Icons.person);
      default:
        return const Icon(Icons.verified_user);
    }
  }

  Widget _suffix() {
    if (widget.hintText == 'password' ||
        widget.hintText == 'confirm password') {
      return TextButton(
          onPressed: () {
            setState(() {
              if (isVisible) {
                isVisible = false;
              } else {
                isVisible = true;
              }
            });
          },
          style: const ButtonStyle(
              padding: MaterialStatePropertyAll(EdgeInsets.zero),
              minimumSize: MaterialStatePropertyAll(Size.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Text(isVisible ? 'show' : 'hide'));
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = DesignHelper.getScheme(context);

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.onBackground.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: scheme.onBackground.withOpacity(0.5),
            blurRadius: .5,
            spreadRadius: 0,
            blurStyle: BlurStyle.outer,
          )
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
            hintText: widget.optional
                ? widget.hintText.tr() + '[optional]'.tr()
                : widget.hintText.tr(),
            border: InputBorder.none,
            prefixIcon: _prefix(),
            suffix: _suffix(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0)),
        validator: widget.validator,
        obscureText: isVisible,
        keyboardType: widget.textInputType,
        controller: widget.controller,
      ),
    );
  }
}
