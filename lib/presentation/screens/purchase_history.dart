import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/dateTime_helper.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:fake_shop_app/data/models/transaction_model.dart';
import 'package:fake_shop_app/business_logic/cubit/products_cubit/products_cubit.dart';
import 'package:fake_shop_app/presentation/screens/transaction_details.dart';
import 'package:fake_shop_app/presentation/widgets/default_appBar.dart';
import 'package:fake_shop_app/presentation/widgets/gradient_button.dart';
import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({Key? key}) : super(key: key);

  @override
  State<PurchaseHistory> createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  Box purchaseBox = HiveServices.purchase_history;

  @override
  Widget build(BuildContext context) {
    ProductsCubit cubit = BlocProvider.of<ProductsCubit>(context);

    ColorScheme scheme = DesignHelper.getScheme(context);

    Widget transactionViewElement(TransactionModel transaction) =>
        OpenContainer(
          closedElevation: 0,
          closedShape: const RoundedRectangleBorder(),
          transitionDuration: const Duration(milliseconds: 500),
          closedBuilder: (context, action) {
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
              tileColor: scheme.background,
              style: ListTileStyle.list,
              subtitle: Text('\$${transaction.priceDetails.totalPrice}'),
              title: Text('ID: ${transaction.id}'),
              trailing:
                  Text(DateTimeHelper.formatTheDate(transaction.purchaseDate)),
            );
          },
          tappable: true,
          transitionType: ContainerTransitionType.fadeThrough,
          openBuilder: (context, action) {
            return BlocProvider.value(
              value: cubit,
              child: TransactionDetails(transaction: transaction),
            );
          },
        );

    return Scaffold(
      appBar: const DefaultAppBar(barTitle: 'orders history'),
      body: purchaseBox.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200.0,
                    child: Image.asset(AssetsRes.EMPTY_CART,
                        color: scheme.primary),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Text("No orders history yet",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.5))
                            .tr(),
                        const Text(
                          "check back after your next shopping trip",
                          textAlign: TextAlign.center,
                        ).tr(),
                      ],
                    ),
                  ),
                  GradientButton(
                      name: 'Back', onPressed: () => Navigator.pop(context))
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt,
                    color: scheme.onPrimary,
                    size: 100,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: purchaseBox.length,
                  itemBuilder: (context, index) {
                    List<Map<dynamic, dynamic>> transes =
                        purchaseBox.values.toList().cast();
                    TransactionModel model =
                        TransactionModel.fromJson(transes[index]);
                    return transactionViewElement(model);
                  },
                ),
              ],
            ),
    );
  }
}
