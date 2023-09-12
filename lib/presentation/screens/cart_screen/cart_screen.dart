import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/business_logic/cubit/cart_cubit/cart_cubit.dart';
import 'package:fake_shop_app/presentation/screens/cart_screen/checkout_bottom_sheet.dart';
import 'package:fake_shop_app/presentation/screens/cart_screen/widgets.dart';
import 'package:fake_shop_app/presentation/widgets/default_appBar.dart';
import 'package:fake_shop_app/presentation/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  final bool inViewMode;

  const CartScreen({this.inViewMode = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartCubit cartCubit = BlocProvider.of<CartCubit>(context);
    Size size = DesignHelper.getTheSize(context);

    CartScreenWidgets widgets = CartScreenWidgets(context: context);

    return Scaffold(
      appBar: const DefaultAppBar(barTitle: 'cart'),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartHaveItems) {
            List<ProductModel> products = cartCubit.products;
            List<int> quantities = state.items.values.toList();
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: size.height * 0.825,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        return widgets.cartItem(
                            products[index], quantities[index]);
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: GradientButton(
                    name: 'Checkout',
                    minWidth: 125.0,
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isDismissible: false,
                        context: context,
                        builder: (context) => CheckOutBottomSheet(
                            cartCubit: cartCubit,
                            transaction: state.getTheTransaction()),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is CartEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart,
                      color: Theme.of(context).colorScheme.primary,
                      size: 100.0),
                  const Text(
                    'Cart Empty',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ).tr(),
                ],
              ),
            );
          } else if (state is CartCheckOut) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ErrorWidget('something wrong here');
          }
        },
      ),
    );
  }
}
