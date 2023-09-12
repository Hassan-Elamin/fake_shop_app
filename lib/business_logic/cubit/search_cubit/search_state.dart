// ignore_for_file: camel_case_types, must_be_immutable

part of 'search_cubit.dart';

@immutable
abstract class SearchModeState {}

class SearchModeInitial extends SearchModeState {}

class SearchBarMode extends SearchModeState {
  List<ProductModel> searched;
  List<String> selectedCategories;
  SearchBarMode({required this.searched, required this.selectedCategories});
}

class NonSearchMode extends SearchModeState {}

class SearchFilterMode extends SearchModeState {
  List<String> categories;
  List<ProductModel> filtred;
  SearchFilterMode({required this.categories, this.filtred = const []});

  copyWith([List<ProductModel>? filtred, List<String>? categories]) {
    return SearchFilterMode(
      categories: categories ?? this.categories,
      filtred: filtred ?? this.filtred,
    );
  }
}
