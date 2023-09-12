part of 'products_cubit.dart';

abstract class ProductsDataState {}

class ProductsCubitInitial extends ProductsDataState {}

class ProductsDataLoaded extends ProductsDataState {
  final List<ProductModel> products;
  final List<Category> categories;

  ProductsDataLoaded({required this.products, required this.categories});
}

class ProductsDataLoading extends ProductsDataState {}

class ProductsDataFailed extends ProductsDataState {}
