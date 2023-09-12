import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:fake_shop_app/business_logic/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  late FirebaseAuth _firebaseAuth;

  FirebaseAuthServices() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  Future<User> login(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user!;
  }

  Future<String?> register(UserEntity entity) async {
    try {
      late UserCredential userCredential;
      await _firebaseAuth
          .createUserWithEmailAndPassword(
              email: entity.email, password: entity.password)
          .then((credential) async {
        User userRes = credential.user!;
        await userRes.updateDisplayName(entity.username);
        userCredential = credential;
      });
      return userCredential.user!.uid;
    } catch (exception) {
      return null;
    }
  }

  Future<void> sendPasswordRestMessage(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<void> updateDisplayName({required String name}) async =>
      await _firebaseAuth.currentUser!.updateDisplayName(name);

  Future<void> logOut() async {
    await _firebaseAuth.signOut().then((value) async {
      await HiveServices().clearUserData();
    });
  }
}
