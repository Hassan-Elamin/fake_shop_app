import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:fake_shop_app/data/models/category_model.dart';
import 'package:fake_shop_app/business_logic/cubit/search_cubit/search_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/products_cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

// ignore: must_be_immutable
class ProductsAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const ProductsAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  const ProductsAppBar.searchMode({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight * 1.75);

  @override
  State<ProductsAppBar> createState() => _ProductsAppBarState();
}

class _ProductsAppBarState extends State<ProductsAppBar> {
  final Box settingsBox = HiveServices.app_settings;

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = DesignHelper.getTheSize(context);
    final ColorScheme scheme = DesignHelper.getScheme(context);

    final SearchCubit searchCubit = BlocProvider.of<SearchCubit>(context);

    closeSearch() => BlocProvider.of<SearchCubit>(context).switchSearchMode();

    AppBar defaultAppBar() {
      return AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: scheme.background,
        foregroundColor: scheme.primary,
        title: const Text('Products').tr(),
      );
    }

    Widget categoryButton(Category category, SearchBarMode searchState) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: MaterialButton(
            onPressed: () {
              if (searchState.selectedCategories.contains(category.name)) {
                searchCubit.removeTheSelectedCategory(category.name);
              } else {
                searchCubit.addCategory = category.name;
              }
              searchCubit.searchOnProducts();
            },
            color: searchState.selectedCategories.contains(category.name)
                ? scheme.onPrimary
                : scheme.primary,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              category.name,
              style: TextStyle(
                color: searchState.selectedCategories.contains(category.name)
                    ? scheme.primary
                    : scheme.onPrimary,
              ),
            )),
      );
    }

    Widget categoriesListBuilder(
        ProductsCubit productCubit, SearchBarMode searchBarMode) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: productCubit.categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Category category = productCubit.categories[index];
          return categoryButton(category, searchBarMode);
        },
      );
    }

    Widget searchField(TextEditingController controller) {
      return TextField(
        decoration: InputDecoration(
          hintText: 'enter product name'.tr(),
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 2.5),
        ),
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          searchCubit.searchOnProducts(value);
        },
      );
    }

    Widget searchBar() {
      return SizedBox(
        width: size.width,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                closeSearch();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            Expanded(child: searchField(searchController)),
            IconButton(
                onPressed: () {
                  if (searchController.text.isEmpty) {
                    closeSearch();
                  } else {
                    searchController.clear();
                  }
                },
                icon: const Icon(
                  Icons.clear,
                )),
          ],
        ),
      );
    }

    AppBar searchAppBar() {
      return AppBar(
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight * 1.1),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: BlocBuilder<SearchCubit, SearchModeState>(
                builder: (context, state) {
                  ProductsCubit productCubit =
                      BlocProvider.of<ProductsCubit>(context);
                  if (state is SearchBarMode) {
                    return Column(
                      children: [
                        searchBar(),
                        SizedBox(
                            height: 50,
                            child: categoriesListBuilder(productCubit, state)),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ));
    }

    return BlocBuilder<SearchCubit, SearchModeState>(
      builder: (context, state) {
        if (state is SearchBarMode) {
          return searchAppBar();
        } else {
          return defaultAppBar();
        }
      },
    );
  }
}
