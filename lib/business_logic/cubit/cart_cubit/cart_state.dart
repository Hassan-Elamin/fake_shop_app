part of 'cart_cubit.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartEmpty extends CartState {}

class CartCheckOut extends CartState {}

class CartHaveItems extends CartState {
  final Map<String, int> items;
  final List<ProductModel> products;
  late final List<int> prices;
  late final double subTotal;

  final double taxPercentage = 0.15;

  CartHaveItems({required this.items, required this.products}) {
    prices = List.generate(items.length,
        (index) => products[index].price * items[products[index].title]!);
    subTotal = prices.reduce((value, element) => value + element).toDouble();
  }

  TransactionModel getTheTransaction() => TransactionModel(
      items: items,
      id: Random().nextInt(100000),
      purchaseDate: DateTime.now(),
      paymentType: PaymentType.credit,
      priceDetails: PriceDetails(subTotal: subTotal, discountPercent: 0));
}
