import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/business_logic/cubit/search_cubit/search_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/products_cubit/products_cubit.dart';
import 'package:fake_shop_app/presentation/screens/products_view_screen/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsViewWidgets {
  final BuildContext context;
  late Size size;
  late ColorScheme scheme;
  late final ProductsCubit productsCubit;

  ProductsViewWidgets({required this.context}) {
    size = MediaQuery.of(context).size;
    scheme = Theme.of(context).colorScheme;
    productsCubit = BlocProvider.of<ProductsCubit>(context);
  }

  Widget filterButton(SearchCubit searchCubit) {
    return BlocBuilder<SearchCubit, SearchModeState>(
      builder: (context, state) {
        return FilledButton.tonalIcon(
          onPressed: () {
            if (searchCubit.state is SearchFilterMode) {
              searchCubit.closeSearchMode();
            } else {
              showDialog(
                context: context,
                builder: (contxt) {
                  return Builder(
                    builder: (context) {
                      return BlocProvider.value(
                        value: searchCubit,
                        child: FilterDialog(productsCubit: productsCubit),
                      );
                    },
                  );
                },
              );
            }
          },
          style: FilledButton.styleFrom(
              backgroundColor: searchCubit.state is SearchFilterMode
                  ? Colors.red
                  : scheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              )),
          label: Text(
            (searchCubit.state is SearchFilterMode ? "cancel" : "filter").tr(),
            style: const TextStyle(fontSize: 20),
          ),
          icon: Icon(
            searchCubit.state is SearchFilterMode
                ? Icons.cancel
                : Icons.filter_alt,
            size: 25,
          ),
        );
      },
    );
  }

  Widget nothingFoundWidget() {
    return SizedBox(
      height: size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_outlined,
            color: scheme.primary,
            size: size.height * 0.15,
          ),
          Text(
            'nothing found',
            style: TextStyle(
              fontSize: 25,
              color: scheme.primary,
            ),
          ).tr(),
        ],
      ),
    );
  }
}
