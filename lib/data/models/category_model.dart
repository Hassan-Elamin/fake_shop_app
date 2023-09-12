import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String slug;

  const Category({
    required this.id,
    required this.name,
    required this.slug
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(
        id: json["_id"],
        name: json["name"],
        slug: json['slug'],
      );

  @override
  List<Object?> get props => [id];
}
