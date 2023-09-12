import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/business_logic/cubit/cart_cubit/cart_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/search_cubit/search_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/products_cubit/products_cubit.dart';
import 'package:fake_shop_app/presentation/screens/cart_screen/cart_screen.dart';
import 'package:fake_shop_app/presentation/screens/product_details/product_details.dart';
import 'package:fake_shop_app/presentation/screens/products_view_screen/widgets/products_screen_appBar.dart';
import 'package:fake_shop_app/presentation/screens/products_view_screen/widgets/sortBy_button.dart';
import 'package:fake_shop_app/presentation/screens/products_view_screen/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_shop_app/presentation/widgets/product_item.dart';

class ProductsViewScreen extends StatefulWidget {
  const ProductsViewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsViewScreen> createState() => _ProductsViewScreenState();
}

class _ProductsViewScreenState extends State<ProductsViewScreen> {
  void addNavEntry(BuildContext context) {
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    SearchCubit searchCubit = SearchCubit.of(context);

    CartCubit cartCubit = BlocProvider.of<CartCubit>(context);
    void navigate(
        {required ProductModel product, required LinearGradient gradient}) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<SearchCubit>.value(value: searchCubit),
                BlocProvider<CartCubit>.value(value: cartCubit),
              ],
              child: ProductDetails(product: product, gradient: gradient),
            ),
          ));
    }

    ProductsViewWidgets widgets = ProductsViewWidgets(context: context);

    return BlocBuilder<SearchCubit, SearchModeState>(
      builder: (context, aState) {
        return Scaffold(
          appBar: aState is SearchBarMode
              ? const ProductsAppBar.searchMode()
              : const ProductsAppBar(),
          body: BlocBuilder<ProductsCubit, ProductsDataState>(
            builder: (context, bState) {
              return ListView(
                children: [
                  bState is ProductsDataLoaded
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: size.height * 0.075,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //sort
                              SortByButton(searchCubit: searchCubit),
                              //filter
                              widgets.filterButton(searchCubit),
                            ],
                          ),
                        )
                      : Container(),
                  aState is SearchBarMode && aState.searched.isEmpty ||
                          aState is SearchFilterMode && aState.filtred.isEmpty
                      ? widgets.nothingFoundWidget()
                      : ProductViewBuilder(
                          onTap: (product, gradient) =>
                              navigate(product: product, gradient: gradient),
                          dataList: searchCubit.getCurrentList),
                ],
              );
            },
          ),
          floatingActionButton: Builder(
            builder: (context) {
              if (aState is SearchBarMode) {
                return const SizedBox();
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocBuilder<CartCubit, CartState>(
                      builder: (context, state) {
                        return FloatingActionButton(
                            onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                      value: cartCubit,
                                      child: const CartScreen(),
                                    ),
                                  ),
                                ),
                            child: state is CartHaveItems
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.shopping_cart_checkout),
                                      Text(state.items.length.toString()),
                                    ],
                                  )
                                : const Icon(Icons.shopping_cart_outlined));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: FloatingActionButton(
                        heroTag: 'search_button',
                        onPressed: () => BlocProvider.of<SearchCubit>(context)
                            .switchSearchMode(),
                        child: const Icon(Icons.search),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
