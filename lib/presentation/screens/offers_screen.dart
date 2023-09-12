import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/presentation/widgets/default_appBar.dart';
import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  OffersScreen({super.key});

  final List<String> banners = [
    AssetsRes.BLACK_FRIDAY_SALE,
    AssetsRes.FLAT_SALE_BANNER,
    AssetsRes.MEGA_SALE_BANNER,
    AssetsRes.RAMDAN_SALE_BANNER,
    AssetsRes.SALES80S_BACKGROUND,
  ];

  final List<String> bannerTitles = [
    'black friday sales! up to 50% on all our products',
    'sales up to 50% on the fashion categories',
    'mega sale , up to 60% on all electronics',
    'ramadan kareem , offers until 27 jul 2022',
    'super sale 50% off on all smart phones'
  ];

  @override
  Widget build(BuildContext context) {
    Size size = DesignHelper.getTheSize(context);
    ColorScheme scheme = DesignHelper.getScheme(context);
    return Scaffold(
      appBar: const DefaultAppBar(barTitle: 'Offers'),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                color: scheme.onBackground,
                borderRadius: BorderRadius.circular(10.0)),
            margin:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(banners[index])),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10.0),
                  child: Text(
                    bannerTitles[index],
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15.0, color: scheme.background),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
