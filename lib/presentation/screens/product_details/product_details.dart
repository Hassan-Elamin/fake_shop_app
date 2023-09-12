import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/business_logic/cubit/cart_cubit/cart_cubit.dart';
import 'package:fake_shop_app/presentation/screens/product_details/widgets.dart';
import 'package:fake_shop_app/presentation/widgets/gradient_button.dart';
import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;
  final CartCubit? cubit;
  final LinearGradient? gradient;

  const ProductDetails(
      {required this.product, this.gradient, this.cubit, Key? key})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    Size size = DesignHelper.getTheSize(context);
    ColorScheme scheme = DesignHelper.getScheme(context);
    CartCubit cartCubit = widget.cubit ?? BlocProvider.of<CartCubit>(context);

    Widget updateNumButton(void Function() onPressed, IconData icon) =>
        MaterialButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: scheme.onBackground,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          minWidth: 0,
          padding: const EdgeInsets.all(7.5),
          child: Icon(icon),
        );

    ProductsDetailsWidgets widgets =
        ProductsDetailsWidgets(context: context, product: widget.product);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.background.withOpacity(0),
            scheme.background.withOpacity(0.25),
            scheme.background.withOpacity(0.5),
            scheme.background.withOpacity(0.75),
            scheme.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.gradient!.colors..add(scheme.background),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height * 0.1),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.05, right: 15, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 25,
                        icon: const Icon(Icons.arrow_back),
                      ),
                      widgets.favProductIconButton(),
                    ],
                  ),
                )),
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: widget.product.id,
                    child: Image.asset(
                      AssetsRes.PRODUCT_ICON,
                      width: size.width * 0.55,
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.45,
                  width: size.width,
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        scheme.background.withOpacity(0),
                        scheme.background.withOpacity(0.25),
                        scheme.background.withOpacity(0.5),
                        scheme.background.withOpacity(0.75),
                        scheme.background,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.title,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.product.description,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${"Total".tr()}: \$${quantity * widget.product.price}',
                              style: const TextStyle(fontSize: 25.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                updateNumButton(() {
                                  setState(() {
                                    if (quantity != 1) {
                                      quantity--;
                                    }
                                  });
                                }, Icons.remove),
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    quantity.toString(),
                                    style: const TextStyle(
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                updateNumButton(
                                    () => setState(() => quantity++),
                                    Icons.add),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${widget.product.price}',
                              style: const TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                            GradientButton(
                              name: 'Add to cart',
                              onPressed: () {
                                cartCubit.addToCart(widget.product, quantity);
                                Navigator.pop(context);
                              },
                              minWidth: size.width * 0.65,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
