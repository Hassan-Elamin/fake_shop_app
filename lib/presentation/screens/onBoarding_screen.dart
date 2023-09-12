import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = DesignHelper.getScheme(context);
    ButtonStyle btnStyle() => FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        );
    PageDecoration pageDecoration =
        const PageDecoration(bodyAlignment: Alignment.center);

    Text pageTitle(String title) => Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25),
        ).tr();
    return SafeArea(
      child: Scaffold(
        body: IntroductionScreen(
          showDoneButton: true,
          showNextButton: true,
          done: const Icon(Icons.done),
          doneStyle: btnStyle(),
          onDone: () {
            HiveServices.app_settings.put('first_time', false);
            Navigator.pushNamedAndRemoveUntil(
                context, '/sign-in', (route) => false);
          },
          next: const Icon(Icons.keyboard_arrow_right),
          nextStyle: btnStyle(),
          pages: [
            PageViewModel(
                titleWidget: pageTitle(
                    'welcome to the first version of fake shop app !'),
                decoration: pageDecoration,
                bodyWidget: Image.asset(AssetsRes.APP_LOGO)),
            PageViewModel(
              titleWidget:
                  pageTitle('follow our news and get a lot of discounts'),
              decoration: pageDecoration,
              bodyWidget: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Image.asset(AssetsRes.MOBILE_MARKETING_AMICO),
              ),
            ),
            PageViewModel(
              titleWidget: pageTitle('Up to 10 Categories of Products'),
              decoration: pageDecoration,
              bodyWidget: Image.asset(AssetsRes.SHOPPING_ILLUSTION),
            ),
            PageViewModel(
              titleWidget: pageTitle('Up to 10 Categories of Products'),
              decoration: pageDecoration,
              bodyWidget: Image.asset(AssetsRes.PRINTING_INVOICES),
            ),
            PageViewModel(
              titleWidget: pageTitle("that's all for this version"),
              decoration: pageDecoration,
              bodyWidget: Image.asset(AssetsRes.APP_LOGO),
            ),
          ],
        ),
      ),
    );
  }
}
