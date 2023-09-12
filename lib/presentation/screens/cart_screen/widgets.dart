import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/data/models/language_model.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/business_logic/cubit/cart_cubit/cart_cubit.dart';
import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreenWidgets {
  final BuildContext context;
  late final CartCubit cartCubit;
  late final Size size;
  late final ColorScheme scheme;

  CartScreenWidgets({required this.context}) {
    size = MediaQuery.of(context).size;
    scheme = DesignHelper.getScheme(context);
    cartCubit = BlocProvider.of<CartCubit>(context);
  }

  Widget _itemDetails(ProductModel product, int quantity) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(product.title),
              Text("unit price: \$${product.price}"),
              Text("total price: \$${product.price * quantity}"),
            ],
          ),
        ),
      );

  Widget _itemImage(String id) => Container(
      height: size.height,
      width: size.width * 0.25,
      padding: const EdgeInsets.all(12.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: context.locale == ArabicLanguage.locale
              ? [
                  scheme.background,
                  scheme.primary,
                ]
              : [
                  scheme.primary,
                  scheme.background,
                ],
        ),
      ),
      child: Hero(
        tag: id,
        child: Image.asset(
          AssetsRes.PRODUCT_ICON,
          fit: BoxFit.contain,
        ),
      ));

  Widget _quantityControl(String id, int quantity) => Container(
      height: size.height,
      width: size.width * 0.1,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.add),
            ),
            onTap: () =>
                BlocProvider.of<CartCubit>(context).addItemQuantity(id),
          ),
          CircleAvatar(
            radius: 15.0,
            child: Text(quantity.toString()),
          ),
          InkWell(
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.remove),
            ),
            onTap: () =>
                BlocProvider.of<CartCubit>(context).minusItemQuantity(id),
          ),
        ],
      ));

  Widget cartItem(ProductModel product, int quantity) {
    return Container(
      height: size.height * 0.15,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: scheme.background,
          boxShadow: [
            BoxShadow(
              blurStyle: BlurStyle.solid,
              blurRadius: 1.5,
              spreadRadius: 0.05,
              color: scheme.onBackground,
            ),
          ],
          borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _itemImage(product.id),
          _itemDetails(product, quantity),
          _quantityControl(product.title, quantity),
        ],
      ),
    );
  }
}
