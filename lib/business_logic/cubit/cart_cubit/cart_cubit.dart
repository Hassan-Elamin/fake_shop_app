import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:fake_shop_app/data/data_sources/firebase/cloud_firestore.dart';
import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/data/models/transaction_model.dart';
import 'package:hive/hive.dart';

part 'cart_state.dart';

// made to manage the the cart and payment methods and widgets
class CartCubit extends Cubit<CartState> {
  late final FirestoreServices _firestore;
  late final Box userData;

  CartCubit() : super(CartInitial()) {
    _firestore = FirestoreServices();
    userData = HiveServices.user_data;
    if (items.isNotEmpty) {
      emit(CartHaveItems(items: items, products: products));
    } else {
      emit(CartEmpty());
    }
  }

  Map<String, int> items = {};
  List<ProductModel> products = [];

  void addToCart(ProductModel product, int quantity) {
    MapEntry<String, int> cartItem = MapEntry(product.title, quantity);
    if (items.containsKey(cartItem.key)) {
      items[cartItem.key] = (items[cartItem.key]! + quantity);
    } else {
      items[cartItem.key] = cartItem.value;
    }
    products.add(product);
    emit(CartHaveItems(items: items, products: products));
  }

  void removeFromCart(String name) {
    items.removeWhere((key, value) => key == name);
    products.removeWhere((element) => element.title == name);
    if (items.isEmpty) {
      emit(CartEmpty());
    } else {
      emit(CartHaveItems(items: items, products: products));
    }
  }

  void minusItemQuantity(String name) {
    items.update(name, (value) => value - 1);
    emit(CartHaveItems(items: items, products: products));
    if (items[name] == 0) {
      removeFromCart(name);
    }
  }

  void addItemQuantity(String name) {
    items.update(name, (value) => value + 1);
    emit(CartHaveItems(items: items, products: products));
  }

  void clearCart() {
    items.clear();
    products.clear();
    emit(CartEmpty());
  }

  Future<void> startCheckout(TransactionModel transaction) async {
    emit(CartCheckOut());
    await _firestore
        .insertNewTransaction(userData.get('uid'), transaction)
        .then((value) {
      HiveServices.purchase_history.put(transaction.id, transaction.toJson());
      clearCart();
    });
  }
}
