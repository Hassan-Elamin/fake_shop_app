import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/business_logic/cubit/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';

class ProductsDetailsWidgets {
  final BuildContext context;
  final ProductModel product;

  late final SettingsCubit _settingsCubit;

  ProductsDetailsWidgets({required this.context, required this.product}) {
    _settingsCubit = SettingsCubit.of(context);
  }

  Widget favProductIconButton() {
    bool isFav = _settingsCubit.favoriteProducts.contains(product.id);
    return IconButton(
      onPressed: () {
        _settingsCubit.productInFavorites(product);
      },
      iconSize: 25,
      icon: Icon(
        isFav ? Icons.favorite_outlined : Icons.favorite_border_outlined,
      ),
    );
  }
}
