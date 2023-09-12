import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/data/models/category_model.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/business_logic/cubit/search_cubit/search_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/products_cubit/products_cubit.dart';
import 'package:fake_shop_app/presentation/widgets/custom_widgets/custom_widgets.dart';
import 'package:fake_shop_app/presentation/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterDialog extends StatefulWidget {
  final ProductsCubit productsCubit;

  const FilterDialog({required this.productsCubit, super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  RangeValues getPriceRanges(List<ProductModel> products) {
    products.sort(
      (a, b) => a.price.compareTo(b.price),
    );
    int minPrice = products.first.price;
    int maxPrice = products.last.price;
    return RangeValues(minPrice.toDouble(), maxPrice.toDouble());
  }

  RangeValues rangeValues = const RangeValues(0, 0);

  @override
  initState() {
    super.initState();
  }

  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    SearchCubit searchCubit = BlocProvider.of<SearchCubit>(context);
    ColorScheme scheme = Theme.of(context).colorScheme;
    CustomWidgets customWidgets = CustomWidgets();

    Widget filterDialogLabel(String name) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          name.tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }

    Widget priceRangeSlider(double min, double max) {
      return Row(
        children: [
          Text(rangeValues.start.toInt().toString()),
          Expanded(
            child: RangeSlider(
              values: rangeValues,
              onChanged: (value) {
                setState(() => rangeValues = value);
              },
              min: 0,
              max: max,
            ),
          ),
          Text(rangeValues.end.toInt().toString()),
        ],
      );
    }

    Widget categoryBtn(String category) {
      return BlocBuilder<SearchCubit, SearchModeState>(
        builder: (context, state) {
          return MaterialButton(
            onPressed: () {
              if (selected.contains(category)) {
                setState(() =>
                    selected.removeWhere((element) => element == category));
              } else {
                setState(() => selected.add(category));
              }
            },
            color: selected.contains(category) ? scheme.primary : null,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              category,
              style: TextStyle(
                  fontSize: 15.0,
                  color: selected.contains(category) ? scheme.onPrimary : null),
            ),
          );
        },
      );
    }

    Widget categoriesList(List<Category> categories) {
      return BlocBuilder<SearchCubit, SearchModeState>(
        builder: (context, state) {
          return GridView.builder(
            itemCount: categories.length,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 3, mainAxisExtent: 50),
            itemBuilder: (context, index) {
              Category category = categories[index];
              return categoryBtn(category.name);
            },
          );
        },
      );
    }

    return Dialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: BlocBuilder<ProductsCubit, ProductsDataState>(
        bloc: widget.productsCubit,
        builder: (context, state) {
          state = (state as ProductsDataLoaded);
          List<String> allCategories =
              List.generate(state.categories.length, (index) {
            return (state as ProductsDataLoaded).categories[index].name;
          });
          final priceRanges = getPriceRanges(state.products);
          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'Filter'.tr(),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                filterDialogLabel('categories'),
                categoriesList(state.categories),
                customWidgets.customDivider(),
                filterDialogLabel('price'),
                priceRangeSlider(priceRanges.start, priceRanges.end),
                customWidgets.customDivider(),
                Center(
                  child: GradientButton(
                    name: 'confirm',
                    onPressed: () {
                      searchCubit.filterTheProducts(
                          priceRanges: rangeValues,
                          selectedCategories:
                              selected.isNotEmpty ? selected : allCategories);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
