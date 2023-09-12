import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/constants/strings.dart';
import 'package:fake_shop_app/presentation/widgets/app_snackbar.dart';
import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> openTheLink(String url) async {
      Uri link = Uri.parse(url);
      bool canLaunch = await canLaunchUrl(link);
      if (!canLaunch) {
        const MessageSnackBar(
                message: "sorry for this, there's a problem in the link")
            .showSnackBar(context);
      } else {
        await launchUrl(link);
      }
    }

    Widget socialMediaNavBtn(String url, IconData icon) {
      return InkWell(
        onTap: () => openTheLink(url),
        borderRadius: BorderRadius.circular(50),
        child: CircleAvatar(
          radius: 30,
          child: Icon(icon),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsRes.DEV_INFO_SCREEN_BACKGROUND),
          opacity: 0.75,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Center(
          child: SizedBox(
            height: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Developed By',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ).tr(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(AssetsRes.APP_LOGO, width: 125),
                    Image.asset(AssetsRes.MY_LOGO_PNG, width: 150),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    socialMediaNavBtn(GITHUB_EMAIL, Icons.developer_mode),
                    socialMediaNavBtn('mailto:$DEV_GMAIL', Icons.email),
                  ],
                ),
                Text(
                  '${'version:'.tr()}1.0.0+1',
                  style: const TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
