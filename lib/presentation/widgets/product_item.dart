import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final void Function() onPressed;

  final LinearGradient? gradient;
  final bool? withHero;

  const ProductItem(
      {required this.onPressed,
      required this.product,
      this.gradient,
      this.withHero,
      super.key});

  @override
  Widget build(BuildContext context) {
    Size size = DesignHelper.getTheSize(context);
    final ColorScheme colorScheme = DesignHelper.getScheme(context);

    Widget productImage() {
      return Container(
        height: 135.0,
        width: size.width,
        padding: const EdgeInsets.symmetric(vertical: 7.5),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            gradient: gradient),
        child: withHero == null || withHero == true
            ? Hero(
                tag: product.id,
                child: Image.asset(
                  AssetsRes.PRODUCT_ICON,
                  fit: BoxFit.scaleDown,
                ),
              )
            : Image.asset(
                AssetsRes.PRODUCT_ICON,
                fit: BoxFit.scaleDown,
              ),
      );
    }

    return Container(
      height: size.height * 0.25,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurStyle: BlurStyle.normal,
            blurRadius: 5,
            color: colorScheme.onBackground.withOpacity(0.1),
            spreadRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.onSecondary,
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            productImage(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 12.5),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            fontSize: 17.5,
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Color> primaries =
    Colors.primaries.toList() + Colors.primaries.reversed.toList();

List<Color> accents =
    Colors.accents.toList() + Colors.accents.reversed.toList();

class ProductViewBuilder extends StatelessWidget {
  final List<ProductModel> dataList;
  final bool? withHero;

  final void Function(ProductModel product, LinearGradient gradient) onTap;

  const ProductViewBuilder(
      {required this.dataList, required this.onTap, this.withHero, super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = DesignHelper.getTheSize(context);

    return Padding(
      padding: const EdgeInsets.only(top: 7.5, right: 7.5, left: 7.5),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: size.height * 0.275),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dataList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          LinearGradient gradient = LinearGradient(
            colors: [
              primaries[index],
              accents[index],
            ],
          );
          return ProductItem(
            product: dataList[index],
            onPressed: () => onTap(dataList[index], gradient),
            gradient: gradient,
            withHero: withHero,
          );
        },
      ),
    );
  }
}
