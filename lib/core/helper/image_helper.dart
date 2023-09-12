import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  late ImagePicker _picker;

  ImageHelper() {
    _picker = ImagePicker();
  }

  Future<File?> pickImage() async {
    try {
      XFile? xFile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 75);
      if (xFile != null) {
        return File(xFile.path);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  File decodeImage(String code) {
    Uint8List bytes = base64Decode(code);

    String appDocPath = HiveServices.app_settings.get('app_directory');
    File file = File('$appDocPath/profile_image');
    file.writeAsBytesSync(bytes);

    return file;
  }

  String encodeImage(File photo) {
    return base64.encode(photo.readAsBytesSync().toList());
  }
}
