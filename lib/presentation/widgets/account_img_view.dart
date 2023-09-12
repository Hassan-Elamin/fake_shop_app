import 'dart:io';

import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AccountImageViewer extends CircleAvatar {
  final File? imageFile;
  late ImageProvider imageProvider;
  void Function()? onPressed;
  double size;

  AccountImageViewer(
      {super.key, this.imageFile, required this.size, this.onPressed}) {
    if (imageFile != null) {
      imageProvider = FileImage(imageFile!);
    } else {
      imageProvider = const AssetImage(AssetsRes.NO_IMAGE_USER);
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Hero(
        tag: 'user_image',
        child: CircleAvatar(
          radius: size,
          backgroundImage: imageProvider,
        ),
      ),
    );
  }
}
