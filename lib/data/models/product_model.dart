// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fake_shop_app/data/models/category_model.dart';

class ProductModel extends Equatable {
  final String id;
  final String title;
  final int price;
  final String description;
  final DateTime createdAt;
  final CreateDetailsModel createdBy;
  final Category category;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['_id'],
        title: json['title'],
        price: json['price'],
        description: json['description'] ?? 'no description found'.tr(),
        createdAt: DateTime.parse(json['createdAt']),
        createdBy: CreateDetailsModel.fromJson(json['createdBy']),
        category: Category.fromJson(json['category']),
      );

  @override
  List<Object?> get props => [id];
}

class CreateDetailsModel {
  String id;
  String name;
  String role;

  CreateDetailsModel({
    required this.id,
    required this.name,
    required this.role,
  });

  factory CreateDetailsModel.fromJson(Map<String, dynamic> json) =>
      CreateDetailsModel(
          id: json["_id"], name: json["name"], role: json["role"]);
}
