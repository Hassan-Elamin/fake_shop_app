import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/business_logic/cubit/search_cubit/search_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/settings_cubit/settings_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/products_cubit/products_cubit.dart';
import 'package:fake_shop_app/presentation/screens/dashboard_screen/drawer.dart';
import 'package:fake_shop_app/presentation/screens/dashboard_screen/widgets.dart';
import 'package:fake_shop_app/presentation/widgets/default_appBar.dart';
import 'package:fake_shop_app/presentation/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  Widget blocBuildWidget() {
    return BlocBuilder<ProductsCubit, ProductsDataState>(
      builder: (context, state) {
        if (state is ProductsDataLoaded) {
          List<ProductModel> products = state.products;
          return ProductViewBuilder(
            dataList: products,
            onTap: (product, gradient) {
              BlocProvider.of<SearchCubit>(context).getOneProduct(product.id);
              Navigator.pushNamed(context, '/products');
            },
            withHero: false,
          );
        } else {
          return const Center(
            child: LinearProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DashboardWidgets widgets = DashboardWidgets(context: context);
    DashboardDrawer drawer = const DashboardDrawer();
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state is OfflineSettings) {
          return Scaffold(
            appBar: const DefaultAppBar(),
            drawer: drawer,
            body: Center(
              child: state.connectionErrorWidget(),
            ),
          );
        } else {
          return Scaffold(
            drawer: drawer,
            body: BlocBuilder<ProductsCubit, ProductsDataState>(
              builder: (context, state) {
                if (state is ProductsDataLoaded) {
                  List<ProductModel> someProducts = [];
                  for (int index = 0; index <= 5; index++) {
                    someProducts.add(state.products[index]);
                  }
                  return CustomScrollView(
                    shrinkWrap: true,
                    slivers: [
                      widgets.dashboardAppBar(),
                      SliverToBoxAdapter(
                        child: widgets.options(),
                      ),
                      SliverToBoxAdapter(
                        child: widgets.categories(),
                      ),
                      SliverToBoxAdapter(
                          child: widgets.topProducts(someProducts)),
                      SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: OutlinedButton(
                                child: const Text('show more').tr(),
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/products')),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          );
        }
      },
    );
  }
}
