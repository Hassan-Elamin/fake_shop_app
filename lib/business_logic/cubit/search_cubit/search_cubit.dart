import 'package:fake_shop_app/business_logic/cubit/products_cubit/products_cubit.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

enum SortTypes { ascending, descending }

// ignore: constant_identifier_names
enum SortBy { price, alphabet, release_date }

class SearchCubit extends Cubit<SearchModeState> {
  ProductsCubit productsCubit;

  SearchCubit({required this.productsCubit}) : super(SearchModeInitial()) {
    if (state is SearchModeInitial) {
      emit(NonSearchMode());
    }
  }

  static SearchCubit of(BuildContext context) =>
      BlocProvider.of<SearchCubit>(context);

  // ignore: prefer_final_fields
  List<String> _selectedCategories = [];

  List<String> get selectedCategories => _selectedCategories;

  set addCategory(String category) => _selectedCategories.add(category);

  removeTheSelectedCategory(String category) =>
      _selectedCategories.removeWhere((element) => element == category);

  List<ProductModel> get currentProductsList {
    if (state is SearchFilterMode) {
      return (state as SearchFilterMode).filtred;
    } else if (state is SearchBarMode) {
      return (state as SearchBarMode).searched;
    } else {
      return productsCubit.products;
    }
  }

  void switchSearchMode() {
    if (state is SearchBarMode) {
      closeSearchMode();
    } else {
      emit(SearchBarMode(searched: const [], selectedCategories: const []));
    }
  }

  void closeSearchMode() {
    selectedCategories.clear();
    emit(NonSearchMode());
  }

  void searchOnProducts([String? input]) {
    List<ProductModel> searched = [];
    List<String> categories = selectedCategories;
    String text = input ?? '';
    if (text.isNotEmpty && categories.isEmpty) {
      searched = searchByText(text);
    } else if (text.isEmpty && categories.isNotEmpty) {
      searched = searchByCategories();
    } else {
      searched = searchByText(text);
      searched = searchByCategories(searched);
    }
    emit(SearchBarMode(
        searched: searched, selectedCategories: selectedCategories));
  }

  List<ProductModel> searchByText(String text,
          [List<ProductModel>? otherList]) =>
      (otherList ?? getCurrentList)
          .where((element) => element.title.contains(text))
          .toList();

  List<ProductModel> searchByCategories([List<ProductModel>? otherList]) {
    List<ProductModel> searched = [];
    final List<ProductModel> products = (otherList ?? productsCubit.products);
    List<String> categories = selectedCategories;

    if (categories.length == 1) {
      searched = products
          .where((element) => element.category.name == categories.first)
          .toList();
    } else {
      for (var category in categories) {
        searched.addAll(
            products.where((element) => element.category.name == category));
      }
    }
    return searched;
  }

  bool allInCategory(String category, List<ProductModel> searched) {
    if (searched.every((element) => element.category.name == category)) {
      return true;
    } else {
      return false;
    }
  }

  void filterTheProducts(
      {required RangeValues priceRanges,
      required List<String> selectedCategories}) {
    List<ProductModel> filteredList = [];
    List<ProductModel>? priceRangeList;

    if (priceRanges != const RangeValues(0, 0)) {
      priceRangeList = filterByPrice(productsCubit.products, priceRanges);
    }
    if (selectedCategories.isNotEmpty) {
      for (String category in selectedCategories) {
        for (ProductModel product in priceRangeList ?? productsCubit.products) {
          if (product.category.name == category) {
            filteredList.add(product);
          }
        }
      }
    }

    emit(SearchFilterMode(
        categories: selectedCategories, filtred: filteredList));
  }

  List<ProductModel> filterByPrice(
      List<ProductModel> products, RangeValues priceRanges) {
    List<ProductModel> priceRangeList = [];
    for (ProductModel product in products) {
      if (product.price >= priceRanges.start &&
          product.price <= priceRanges.end) {
        priceRangeList.add(product);
      }
    }
    return priceRangeList;
  }

  List<ProductModel> filterByCategory(
      List<ProductModel> products, List<String> selectedCategories) {
    List<ProductModel> filteredList = [];
    for (String category in selectedCategories) {
      for (ProductModel product in products) {
        if (product.category.name == category) {
          filteredList.add(product);
        }
      }
    }
    return filteredList;
  }

  List<ProductModel> get getCurrentList {
    if (state is SearchBarMode &&
        (state as SearchBarMode).searched.isNotEmpty) {
      return (state as SearchBarMode).searched;
    } else if (state is SearchFilterMode) {
      return (state as SearchFilterMode).filtred;
    } else {
      return productsCubit.products;
    }
  }

  void getOneProduct(String id) {
    ProductModel product =
        productsCubit.products.where((element) => element.id == id).first;
    emit(SearchBarMode(
        searched: [product], selectedCategories: selectedCategories));
  }

  set sort(List<ProductModel> list) {
    if (state is SearchFilterMode) {
      emit((state as SearchFilterMode).copyWith(list));
    } else {
      emit(SearchFilterMode(categories: selectedCategories, filtred: list));
    }
  }

  List<ProductModel> sortTheList(
      List<ProductModel> products, SortBy sortBy, SortTypes sortType) {
    products.sort(sortMethod(sortBy, sortType));
    return products;
  }

  int Function(ProductModel a, ProductModel b) sortMethod(
      SortBy sortBy, SortTypes sortType) {
    if (sortType == SortTypes.descending) {
      switch (sortBy) {
        case SortBy.alphabet:
          return (b, a) => a.title.compareTo(b.title);

        case SortBy.price:
          return (b, a) => a.price.compareTo(b.price);

        case SortBy.release_date:
          return (b, a) => a.createdAt.compareTo(b.createdAt);
      }
    } else {
      switch (sortBy) {
        case SortBy.alphabet:
          return (a, b) => a.title.compareTo(b.title);

        case SortBy.price:
          return (a, b) => a.price.compareTo(b.price);

        case SortBy.release_date:
          return (a, b) => a.createdAt.compareTo(b.createdAt);
      }
    }
  }
}
