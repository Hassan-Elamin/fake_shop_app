import 'package:fake_shop_app/business_logic/cubit/products_cubit/products_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/search_cubit/search_cubit.dart';
import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/presentation/widgets/default_appBar.dart';
import 'package:fake_shop_app/presentation/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteProductsScreen extends StatelessWidget {
  FavoriteProductsScreen({super.key});

  final List<String> products = HiveServices().getFavList;

  @override
  Widget build(BuildContext context) {
    SearchCubit searchCubit = SearchCubit.of(context);

    Widget blocBuildWidget() {
      return BlocBuilder<ProductsCubit, ProductsDataState>(
        builder: (context, state) {
          if (state is ProductsDataLoaded) {
            List<ProductModel> favList = [];
            for (ProductModel element in state.products) {
              if (products.contains(element.id)) {
                favList.add(element);
              }
            }
            return ProductViewBuilder(
              dataList: favList,
              onTap: (product, gradient) {
                searchCubit.getOneProduct(product.id);
                Navigator.of(context).pushNamed('/products');
              },
            );
          } else {
            return const Center(
              child: LinearProgressIndicator(),
            );
          }
        },
      );
    }

    return Scaffold(
      appBar: const DefaultAppBar(barTitle: 'Favorite'),
      body: blocBuildWidget(),
    );
  }
}
