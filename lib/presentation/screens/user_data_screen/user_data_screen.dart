import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/dateTime_helper.dart';
import 'package:fake_shop_app/core/helper/image_helper.dart';
import 'package:fake_shop_app/core/helper/text_field_validator.dart';
import 'package:fake_shop_app/data/models/user_model.dart';
import 'package:fake_shop_app/business_logic/cubit/user_cubit.dart/user_cubit.dart';
import 'package:fake_shop_app/presentation/screens/user_data_screen/widgets.dart';
import 'package:fake_shop_app/presentation/widgets/account_img_view.dart';
import 'package:fake_shop_app/presentation/widgets/app_snackbar.dart';
import 'package:fake_shop_app/presentation/widgets/gradient_button.dart';
import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/auth_text_field.dart';

class UserDataScreen extends StatelessWidget {
  UserDataScreen({Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme scheme = Theme.of(context).colorScheme;
    UserCubit userCubit = BlocProvider.of<UserCubit>(context);

    Future<void> editUserName() async {
      if (controller.text.length >= 4) {
        await userCubit.updateUserData(username: controller.text).then((value) {
          controller.clear();
          Navigator.pop(context);
        });
      }
    }

    AlertDialog editingDialog(Function() onPressed) => AlertDialog(
          title: const Text('enter the new name').tr(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: SizedBox(
            height: 60.0,
            child: AuthTextField(
              controller: controller,
              hintText: 'username',
              validator: Validator.usernameValidator,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          elevation: 5,
          actions: [
            GradientButton(
              name: 'ok',
              onPressed: onPressed,
            )
          ],
        );

    Future<void> updateUserData() async {
      await showDialog(
        context: context,
        builder: (context) {
          return editingDialog(editUserName);
        },
      );
    }

    Future<void> selectGender() async {
      showDialog(
        context: context,
        builder: (context) {
          List<String> genders = ['male', 'female'];
          return AlertDialog(
            title: const Text('select gender').tr(),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: List<Widget>.generate(
              genders.length,
              (index) => TextButton(
                onPressed: () async {
                  await userCubit
                      .updateUserData(gender: genders[index])
                      .then((value) => Navigator.pop(context));
                },
                child: Text(genders[index]).tr(),
              ),
            ),
          );
        },
      );
    }

    void updateImage() async {
      await ImageHelper().pickImage().then((img) async {
        if (img != null) {
          await userCubit.updateUserData(img: img);
        } else {
          const MessageSnackBar(message: 'you did not pick an image')
              .showSnackBar(context);
        }
      });
    }

    Widget imageOptionsDialog(File? image) {
      return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 40.0),
          alignment: Alignment.center,
          elevation: 5.0,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  child: const Text('change image').tr(),
                  onPressed: () {
                    updateImage();
                  },
                ),
                FilledButton.tonal(
                  child: const Text('view image').tr(),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: image != null
                              ? Image.file(image, width: 100)
                              : Image.asset(AssetsRes.NO_IMAGE_USER),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ));
    }

    UserDataScreenWidgets widgets = UserDataScreenWidgets(context: context);

    Future<void> updateBirthdate() async {
      DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime(2007),
        firstDate: DateTime(1960),
        lastDate: DateTime(2007),
      );
      if (date != null) {
        await userCubit.updateUserData(birthdate: date);
      } else {
        // ignore: use_build_context_synchronously
        const MessageSnackBar(message: 'enter a date').showSnackBar(context);
      }
    }

    Widget insertButton(String name, void Function() onPressed) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: MaterialButton(
            onPressed: onPressed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: scheme.background,
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            minWidth: size.width * 0.9,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add),
                Text(name).tr(),
              ],
            ),
          ),
        );

    return Scaffold(
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserSignedIn) {
            UserModel user = state.userData;
            UserOtherData otherData = user.userOtherData;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: size.height * 0.25,
                  centerTitle: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      height: size.height,
                      width: size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            scheme.primary,
                            scheme.primary,
                            scheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: CircleAvatar(
                              radius: 50,
                              child: AccountImageViewer(
                                size: 45,
                                imageFile: state.userData.userOtherData.photo,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        imageOptionsDialog(otherData.photo),
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Hello!",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ).tr(),
                                Text(
                                  user.display_name,
                                  style: const TextStyle(fontSize: 20.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pinned: true,
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widgets.dataRow('Email', user.email, null),
                        widgets.dataRow('Username', user.display_name,
                            () async => await updateUserData()),
                        widgets.dataRow(
                            'Address',
                            '${otherData.address.street} \n ${otherData.address.region} , ${otherData.address.city}',
                            null),
                        otherData.gender != null
                            ? widgets.dataRow(
                                'Gender', otherData.gender!.tr(), null)
                            : insertButton('Add your Gender',
                                () async => await selectGender()),
                        otherData.birthdate != null
                            ? widgets.dataRow(
                                'Date of birth',
                                DateTimeHelper.formatTheDate(
                                    otherData.birthdate!),
                                updateBirthdate)
                            : insertButton('Add your Birthdate',
                                () async => await updateBirthdate()),
                        Center(
                          child: widgets.logOutButton(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return ErrorWidget('screen should not working now'.tr());
          }
        },
      ),
    );
  }
}
