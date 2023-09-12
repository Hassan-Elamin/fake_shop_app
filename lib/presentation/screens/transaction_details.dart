import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/dateTime_helper.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/core/services/pdf_creator.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/data/models/transaction_model.dart';
import 'package:fake_shop_app/business_logic/cubit/products_cubit/products_cubit.dart';
import 'package:fake_shop_app/presentation/widgets/app_snackbar.dart';
import 'package:fake_shop_app/presentation/widgets/borders.dart';
import 'package:fake_shop_app/presentation/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionDetails extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetails({required this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme scheme = DesignHelper.getScheme(context);

    Widget dataCell(String key, dynamic value) => Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.all(10.0),
          decoration: AppBorders(context: context).boxDecoration().copyWith(
                color: scheme.surface.withOpacity(0.5),
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                key.tr(),
                style: const TextStyle(
                  fontSize: 17.5,
                ),
              ),
              Text(value.toString()),
            ],
          ),
        );

    Widget purchasedProducts(List<ProductModel> products) =>
        BlocBuilder<ProductsCubit, ProductsDataState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: ExpansionTile(
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: scheme.surface.withOpacity(0.25),
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: const Text('Items').tr(),
                children: List.generate(products.length, (index) {
                  final TextStyle style = TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: scheme.background,
                  );
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: [
                        index == 0
                            ? Container(
                                color: scheme.onBackground,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 30.0,
                                      width: size.width * 0.5,
                                      child: Text(
                                        'Item',
                                        textAlign: TextAlign.center,
                                        style: style,
                                      ).tr(),
                                    ),
                                    SizedBox(
                                        height: 30.0,
                                        width: size.width * 0.2,
                                        child: Text('Price',
                                                textAlign: TextAlign.center,
                                                style: style)
                                            .tr()),
                                    SizedBox(
                                      height: 30.0,
                                      width: size.width * 0.2,
                                      child: Text('Quantity',
                                              textAlign: TextAlign.center,
                                              style: style)
                                          .tr(),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: size.width * 0.5,
                              child: Text(
                                products[index].title,
                              ),
                            ),
                            SizedBox(
                                width: size.width * 0.2,
                                child: Text(
                                  products[index].price.toString(),
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                              width: size.width * 0.2,
                              child: Text(
                                '${transaction.items.values.toList()[index]}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          },
        );

    Widget expandedDetails(Map data) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ExpansionTile(
            title: const Text('Invoice Details').tr(),
            collapsedBackgroundColor:
                Theme.of(context).colorScheme.surface.withOpacity(0.25),
            collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            children: List<Widget>.generate(
              data.length,
              (index) {
                List<MapEntry> entries = data.entries.toList();
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  color: index.isOdd
                      ? scheme.primary.withOpacity(0.05)
                      : scheme.primary.withOpacity(0.10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entries[index].key.toString().replaceFirst("_", " "),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ).tr(),
                      Text(
                        '${entries[index].value}\$',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title:
            Hero(tag: transaction.id, child: Text(transaction.id.toString())),
      ),
      body: BlocBuilder<ProductsCubit, ProductsDataState>(
        builder: (context, state) {
          var currentState = state as ProductsDataLoaded;
          List<ProductModel> products = [];
          for (String elementA in transaction.items.keys.toList()) {
            for (var elementB in currentState.products) {
              if (elementB.title == elementA) {
                products.add(elementB);
              }
            }
          }
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10.0),
                      child: Column(
                        children: [
                          dataCell('ID:', transaction.id),
                          dataCell(
                              'Payment Type:', transaction.paymentType.name),
                          dataCell(
                              'Date:',
                              DateTimeHelper.formatDateTime(
                                  transaction.purchaseDate)),
                          purchasedProducts(products),
                          expandedDetails(
                              transaction.priceDetails.priceDetailsMap()),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientButton(
                          name: 'export as PDF',
                          icon: Icons.import_export,
                          onPressed: () async {
                            Map<String, Map<int, int>> productsMap = {};
                            for (int index = 0;
                                index < products.length;
                                index++) {
                              var element = products[index];
                              int quant =
                                  transaction.items.values.toList()[index];
                              productsMap[element.title] = {
                                quant: element.price
                              };
                            }

                            await PdfCreator()
                                .createInvoice(transaction, productsMap)
                                .then((created) {
                              if (created) {
                                const MessageSnackBar(
                                        message:
                                            'file saved on download folder')
                                    .showSnackBar(context);
                              } else {
                                const MessageSnackBar(
                                        message:
                                            'something wrong , file didn\'t save')
                                    .showSnackBar(context);
                              }
                            });
                          }),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
