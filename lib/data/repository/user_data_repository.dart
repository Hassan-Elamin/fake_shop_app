import 'package:fake_shop_app/data/data_sources/firebase/firebase_auth.dart';
import 'package:fake_shop_app/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataRepository {
  late FirebaseAuthServices _authServices;

  UserDataRepository() {
    _authServices = FirebaseAuthServices();
  }

  Future<UserModel> login(String email, String password) async {
    late User userData;
    userData = await _authServices.login(email, password);
    return await UserModel.fromFirebase(userData);
  }
}
