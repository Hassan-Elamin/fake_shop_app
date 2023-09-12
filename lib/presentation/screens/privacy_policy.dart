import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/data/models/language_model.dart';
import 'package:fake_shop_app/presentation/widgets/default_appBar.dart';
import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String> loadText() async {
      if (context.locale == ArabicLanguage.locale) {
        return await rootBundle.loadString(AssetsRes.PRIVACY_POLICY_AR);
      } else {
        return await rootBundle.loadString(AssetsRes.PRIVACY_POLICY_EN);
      }
    }

    return Scaffold(
      appBar: const DefaultAppBar(barTitle: 'Privacy Policy'),
      body: FutureBuilder<String>(
        future: loadText(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(snapshot.data ?? ''),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(AssetsRes.APP_LOGO, width: 75),
                            Image.asset(AssetsRes.MY_LOGO_PNG, width: 100),
                          ],
                        ),
                      ],
                    )));
          }
        },
      ),
    );
  }
}
