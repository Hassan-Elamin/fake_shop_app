import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/data/models/transaction_model.dart';
import 'package:fake_shop_app/business_logic/cubit/cart_cubit/cart_cubit.dart';
import 'package:fake_shop_app/presentation/widgets/custom_button.dart';
import 'package:fake_shop_app/presentation/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOutBottomSheet extends StatefulWidget {
  final CartCubit cartCubit;
  final TransactionModel transaction;

  const CheckOutBottomSheet(
      {required this.cartCubit, required this.transaction, super.key});

  @override
  State<CheckOutBottomSheet> createState() => _CheckOutBottomSheetState();
}

class _CheckOutBottomSheetState extends State<CheckOutBottomSheet> {
  TableRow _tableRow(String name, String value) => TableRow(
        children: [
          Text(name.tr(),
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          Text(
            '$value\$',
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 20.0),
          ),
        ],
      );

  Widget _priceDetails(PriceDetails priceDetails) => Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        child: Table(
          children: [
            _tableRow('sub total', priceDetails.subTotal.toString()),
            _tableRow('tax', priceDetails.tax.toString()),
            _tableRow('discount', priceDetails.discountPercent.toString()),
            _tableRow('Total', priceDetails.totalPrice.toString()),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = DesignHelper.getScheme(context);

    Widget paymentOptionRadio(String name, IconData icon, PaymentType value) {
      return Container(
        height: 50.0,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
            color: scheme.background,
            border: Border.all(width: 0.5),
            borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(icon),
                ),
                Text(name).tr(),
              ],
            ),
            BlocBuilder<CartCubit, CartState>(
              bloc: widget.cartCubit,
              builder: (context, state) {
                return Radio(
                  value: value,
                  groupValue: widget.transaction.paymentType,
                  onChanged: (value) {
                    setState(() {
                      widget.transaction.paymentType = value!;
                    });
                  },
                );
              },
            )
          ],
        ),
      );
    }

    Widget paymentOptions() => Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 1.5,
                spreadRadius: .5,
                blurStyle: BlurStyle.outer,
                color: scheme.onBackground.withOpacity(0.2),
              ),
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Payment Options'.tr(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 22.5,
              ),
            ),
            paymentOptionRadio(
                'Credit Card', Icons.credit_card, PaymentType.credit),
            paymentOptionRadio('Pay pal', Icons.paypal, PaymentType.paypal),
          ]),
        );

    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: scheme.background,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: BlocBuilder<CartCubit, CartState>(
        bloc: widget.cartCubit,
        builder: (context, state) {
          if (state is CartCheckOut) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CartEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 125.0,
                    color: Colors.green,
                  ),
                  const Text(
                    'Done',
                    style: TextStyle(fontSize: 30.0),
                  ).tr(),
                  CustomMaterialButton(
                      text: 'close',
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      })
                ],
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  'Checkout Details',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
                _priceDetails(widget.transaction.priceDetails),
                paymentOptions(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GradientButton(
                        name: 'cancel',
                        onPressed: () {
                          Navigator.pop(context);
                          widget.cartCubit.clearCart();
                        }),
                    GradientButton(
                      name: 'Buy Now',
                      onPressed: () async => await widget.cartCubit
                          .startCheckout(widget.transaction),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
