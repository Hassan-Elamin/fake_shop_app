import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/presentation/widgets/app_snackbar.dart';
import 'package:fake_shop_app/presentation/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    void errorMessage() => const MessageSnackBar(
            message: "sorry for this, there's a problem in the link")
        .showSnackBar(context);

    Future<void> openTheLink(String url) async {
      Uri link = Uri.parse(url);
      bool canLaunch = await canLaunchUrl(link);
      if (canLaunch) {
        launchUrl(link);
      } else {
        errorMessage();
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
      ),
      body: Center(
        child: Container(
          height: 400.0,
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const CircleAvatar(
                radius: 50.0,
                child: Icon(
                  Icons.support_agent_outlined,
                  size: 75,
                ),
              ),
              const Text(
                'if you have any problem or if you want to report about something contact us',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ).tr(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          "this is a test version , so there's no contact number yet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17.5,
                          ),
                        ).tr(),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          GradientButton(
                              name: 'close',
                              onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                    ),
                    icon: const Icon(Icons.call),
                    label: const Text('contact us').tr(),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () =>
                        openTheLink('mailto:hehelpandservices@gmail.com'),
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('send email').tr(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
