import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/business_logic/cubit/user_cubit.dart/user_cubit.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/presentation/widgets/app_snackbar.dart';
import 'package:fake_shop_app/presentation/widgets/borders.dart';
import 'package:fake_shop_app/presentation/widgets/custom_widgets/custom_text_field.dart';
import 'package:fake_shop_app/presentation/widgets/default_appBar.dart';
import 'package:fake_shop_app/presentation/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ResetState { notSent, sent }

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController controller = TextEditingController();
  ResetState resetState = ResetState.notSent;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final ColorScheme scheme = DesignHelper.getScheme(context);
    void showMessage(String message) =>
        MessageSnackBar(message: message).showSnackBar(context);
    return Scaffold(
      appBar: const DefaultAppBar(barTitle: 'password reset'),
      backgroundColor: scheme.background,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Center(
            child: resetState == ResetState.sent
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.done, size: 75),
                      const Text('Message sent to your email').tr(),
                    ],
                  )
                : Container(
                    height: size.height * 0.4,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: scheme.primary,
                          radius: 50.0,
                          child: Icon(
                            Icons.password,
                            size: 75.0,
                            color: scheme.onPrimary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                                  "Enter the email address associated with your account and we'll send you a link to reset your password",
                                  textAlign: TextAlign.center)
                              .tr(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: CustomTextField(
                            controller: controller,
                            inputDecoration: AppBorders(context: context)
                                .inputDecoration('enter the email'),
                          ),
                        ),
                        GradientButton(
                          name: 'confirm',
                          onPressed: () async {
                            String? value = controller.text;
                            if (value.isNotEmpty) {
                              if (value.contains('@') &&
                                  value.contains('.com')) {
                                await BlocProvider.of<UserCubit>(context)
                                    .resetPassword(controller.text)
                                    .then((sent) {
                                  setState(() {
                                    if (sent) {
                                      resetState = ResetState.sent;
                                    } else {
                                      resetState = ResetState.notSent;
                                    }
                                  });
                                });
                              } else {
                                showMessage('email format not correct');
                              }
                            } else {
                              showMessage("you didn't type anything");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
