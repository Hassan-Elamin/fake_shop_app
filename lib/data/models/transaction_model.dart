import 'dart:convert';

enum PaymentType { credit, paypal }

class PriceDetails {
  final double subTotal;
  final double discountPercent;
  late double discount;

  final double taxPercent;
  late double tax;

  late double totalPrice;

  PriceDetails({
    required this.subTotal,
    this.discountPercent = 0.0,
    this.taxPercent = 0.14,
  }) {
    tax = (subTotal * taxPercent).toInt().toDouble();
    discount = (subTotal * discountPercent * -1);
    totalPrice = subTotal + tax + discount;
  }

  Map<String, dynamic> toJson() => {
        'sub_total': subTotal,
        'tax_percent': taxPercent,
        'discount_percent': discountPercent,
        'total_price': totalPrice,
      };

  Map<String, dynamic> priceDetailsMap() => {
        'sub_total': subTotal,
        'tax': tax,
        'discount': discount,
        'total_price': totalPrice,
      };

  factory PriceDetails.fromJson(Map<dynamic, dynamic> json) => PriceDetails(
        subTotal: json['sub_total'] ?? json['products_price'],
        discountPercent: json['discount_percent'] ?? 0.0,
        taxPercent: json['tax_percent'],
      );
}

class TransactionModel {
  final int id;
  final DateTime purchaseDate;
  final Map<String, int> items;
  final PriceDetails priceDetails;
  PaymentType paymentType;

  TransactionModel({
    required this.items,
    required this.id,
    required this.purchaseDate,
    required this.priceDetails,
    required this.paymentType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'purchase_date': purchaseDate.toString(),
        'items': json.encode(items),
        'price_details': priceDetails.toJson(),
        'payment_type': paymentType.name,
      };

  Map<String, dynamic> toFirebaseDocument() => {
        'id': id,
        'purchase_date': purchaseDate.toString(),
        'items': items,
        'price_details': priceDetails.toJson(),
        'payment_type': paymentType.name,
      };

  factory TransactionModel.fromFirebase(Map<dynamic, dynamic> data) =>
      TransactionModel(
        items: (data['items'] as Map<dynamic, dynamic>).cast(),
        id: data['id'],
        purchaseDate: DateTime.parse(data['purchase_date']),
        priceDetails: PriceDetails.fromJson(data['price_details']),
        paymentType: data['payment_type'] == 'credit'
            ? PaymentType.credit
            : PaymentType.paypal,
      );

  factory TransactionModel.fromJson(Map<dynamic, dynamic> jsonMap) =>
      TransactionModel(
        id: jsonMap['id'],
        purchaseDate: DateTime.parse(
            jsonMap['purchase_date'] ?? jsonMap['purchase_data']),
        priceDetails: PriceDetails.fromJson(jsonMap['price_details']),
        items: jsonMap['items'].runtimeType == String
            ? (json.decode(jsonMap['items']) as Map<String, dynamic>).cast()
            : (jsonMap['items'] as Map<dynamic, dynamic>).cast(),
        paymentType: jsonMap['payment_type'] == 'credit'
            ? PaymentType.credit
            : PaymentType.paypal,
      );
}
