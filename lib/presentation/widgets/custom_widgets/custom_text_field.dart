import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  final String? Function(String? input)? validator;

  final double? height;

  final double? width;

  final InputDecoration inputDecoration;

  final bool readOnly;

  final void Function()? onTap;

  const CustomTextField({
    required this.controller,
    required this.inputDecoration,
    this.readOnly = false,
    this.validator,
    this.height,
    this.width,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = DesignHelper.getScheme(context);
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.onBackground.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: scheme.onBackground.withOpacity(0.5),
            blurRadius: 2.5,
            spreadRadius: 0,
            blurStyle: BlurStyle.outer,
          )
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        readOnly: readOnly,
        decoration: inputDecoration,
        onTap: onTap,
      ),
    );
  }
}
