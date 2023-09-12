// ignore_for_file: non_constant_identifier_names
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveServices {
  Future<void> hiveInitial() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    await Hive.openBox('app_settings').then((box) {
      box.put('app_directory', appDocumentDirectory.path);
    });
    await Hive.openBox('user_data');
    await Hive.openBox('purchase_history')
        .then((value) => print(value.toMap()));
  }

  static Box get app_settings => Hive.box('app_settings');

  static Box get user_data => Hive.box('user_data');

  static Box get purchase_history =>
      Hive.box('purchase_history');

  void putFavList(List<String> products) {
    Map<dynamic, dynamic> otherDataMap = user_data.get('other_data');
    otherDataMap['favorites'] = products;
    user_data.put('other_data', otherDataMap);
  }

  List<String> get getFavList {
    if (user_data.isEmpty) {
      return [];
    } else {
      return (user_data.get('other_data')['favorites']);
    }
  }

  Future<void> clearUserData() async {
    app_settings.delete('last_update');
    await user_data.clear();
    await purchase_history.clear();
  }
}
