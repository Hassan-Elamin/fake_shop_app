import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_shop_app/data/models/transaction_model.dart';
import 'package:fake_shop_app/data/models/user_model.dart';

class FirestoreServices {
  late FirebaseFirestore _firestore;

  FirestoreServices() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> createUserDataStorage(
      {required String uid, required UserOtherData otherData}) async {
    await _firestore
        .collection('users-other-data')
        .doc(uid)
        .set(otherData.toJson());
  }

  Future<void> addUserTransactionsHistory({required String uid}) async {
    await _firestore.collection('users_transactions').doc(uid).set({
      'uid': uid,
      'transactions': [],
    });
  }

  Future<Map<String, dynamic>?> getUserSettingsData(String id) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await _firestore.collection('users-other-data').doc(id).get();
    return data.data();
  }

  Future<List<dynamic>> getUserPurchaseHistory(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users_transactions').doc(uid).get();
    Map data = snapshot.data() as Map;
    return (data['transactions'] as List);
  }

  Future<void> updateData(String id, UserOtherData userOtherData) async {
    await _firestore
        .collection('users-other-data')
        .doc(id)
        .update(userOtherData.toJson());
  }

  Future<void> updateSingleData(String id, Map<Object, Object> json) async =>
      await _firestore.collection('users-other-data').doc(id).update(json);

  Future<bool> isUserHasStorage(String uid) async {
    var quer = await _firestore.collection('users-other-data').doc(uid).get();
    if (quer.data()!.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> insertNewTransaction(
      String id, TransactionModel transactionModel) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await _firestore.collection('users_transactions').doc(id).get();

    Map<String, dynamic> dataMap = data.data() ?? {};
    if (dataMap.containsKey('transactions')) {
    } else {
      dataMap['transactions'] = [];
    }
    List transactions = dataMap['transactions'];
    transactions.add(transactionModel.toFirebaseDocument());
    dataMap.update('transactions', (value) => value = transactions);

    await _firestore
        .collection('users_transactions')
        .doc(id)
        .update({'transactions': transactions});
  }
}
