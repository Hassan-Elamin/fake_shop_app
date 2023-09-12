// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/dateTime_helper.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/core/helper/image_helper.dart';
import 'package:fake_shop_app/core/helper/text_field_validator.dart';
import 'package:fake_shop_app/data/models/user_model.dart';
import 'package:fake_shop_app/business_logic/cubit/user_cubit.dart/user_cubit.dart';
import 'package:fake_shop_app/business_logic/entities/user_entity.dart';
import 'package:fake_shop_app/presentation/screens/auth_screens/sign_up_screen/widgets.dart';
import 'package:fake_shop_app/presentation/widgets/app_snackbar.dart';
import 'package:fake_shop_app/presentation/widgets/auth_text_field.dart';
import 'package:fake_shop_app/presentation/widgets/borders.dart';
import 'package:fake_shop_app/presentation/widgets/gradient_button.dart';
import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin, DesignHelper {
  final TextEditingController emailField = TextEditingController();
  final TextEditingController usernameField = TextEditingController();
  final TextEditingController passwordField = TextEditingController();
  final TextEditingController passwordConfirmField = TextEditingController();

  final TextEditingController birthDateField = TextEditingController();

  final TextEditingController streetField = TextEditingController();
  final TextEditingController regionField = TextEditingController();
  final TextEditingController cityField = TextEditingController();

  File? image;
  DateTime? birthDate;
  Gender? gender;

  bool done = false;

  int _index = 0;

  final List<String> genders = ['male', 'female'];

  @override
  void dispose() {
    emailField.dispose();
    usernameField.dispose();
    passwordField.dispose();
    passwordConfirmField.dispose();
    birthDateField.dispose();
    streetField.dispose();
    regionField.dispose();
    cityField.dispose();
    super.dispose();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = DesignHelper.getTheSize(context);
    final ColorScheme scheme = DesignHelper.getScheme(context);
    AppBorders borders = AppBorders(context: context);
    UserCubit userCubit = BlocProvider.of<UserCubit>(context);

    SignUpWidgets widgets = SignUpWidgets(context: context);

    ImageProvider imageProvider() {
      if (image != null) {
        return FileImage(image!);
      } else {
        return const AssetImage(AssetsRes.NO_IMAGE_USER);
      }
    }

    Future<void> updateBirthDate() async => await showDatePicker(
                context: context,
                initialDate: DateTime(DateTime.now().year - 16),
                firstDate: DateTime(1950),
                lastDate: DateTime(2007))
            .then((date) {
          if (date != null) {
            setState(() {
              birthDate = date;
              birthDateField.text = DateTimeHelper.formatTheDate(date);
            });
          } else {
            const MessageSnackBar(message: 'please select a date')
                .showSnackBar(context);
          }
        });

    // ignore: no_leading_underscores_for_local_identifiers
    Widget _genderOption(String value) => Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: gender != null ? gender!.name : null,
              onChanged: (value) {
                setState(() =>
                    gender = value == 'male' ? Gender.male : Gender.female);
              },
            ),
            Text(value).tr(),
          ],
        );

    Widget genderOptions() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gender',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: borders.boxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  genders.length,
                  (index) => _genderOption(genders[index]),
                ),
              ),
            ),
          ],
        );

    Future<void> signUp() async {
      await userCubit
          .register(
            UserEntity(
              email: emailField.text,
              username: usernameField.text,
              password: passwordField.text,
              address: UserAddress(
                street: streetField.text,
                city: cityField.text,
                region: regionField.text,
              ),
              birthdate: birthDate,
              gender: gender,
              image: image,
            ),
          )
          .then((value) => Navigator.pop(context));
    }

    Widget OptionalDataForm() => Form(
          child: Container(
            height: size.height * 0.5,
            margin:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    ImageHelper pickerServices = ImageHelper();
                    File? pickedImage = await pickerServices.pickImage();
                    setState(() {
                      image = pickedImage;
                    });
                  },
                  borderRadius: BorderRadius.circular(55.0),
                  child: ClipOval(
                    clipBehavior: Clip.hardEdge,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imageProvider(),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        height: size.height,
                        width: size.width,
                        child: const Icon(Icons.edit),
                      ),
                    ),
                  ),
                ),
                widgets.dateSelectField(birthDateField, updateBirthDate),
                genderOptions(),
                GradientButton(name: 'confirm', onPressed: () => signUp()),
              ],
            ),
          ),
        );

    Widget SignUpForm() {
      return Form(
        key: formKey,
        child: Container(
          height: size.height * 0.65,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AuthTextField(
                  controller: usernameField,
                  hintText: 'username',
                  validator: Validator.usernameValidator,
                  textInputType: TextInputType.name),
              AuthTextField(
                  controller: emailField,
                  hintText: 'email',
                  validator: Validator.emailValidator,
                  textInputType: TextInputType.emailAddress),
              AuthTextField(
                  controller: passwordField,
                  hintText: 'password',
                  validator: Validator.passwordValidator,
                  textInputType: TextInputType.visiblePassword),
              AuthTextField(
                controller: passwordConfirmField,
                hintText: 'confirm password',
                textInputType: TextInputType.visiblePassword,
                validator: (String? value) {
                  if (!Validator.isPasswordConfirmValidated(
                      passwordField.text, value ?? '')) {
                    return "password confirm not the same as the first";
                  } else {
                    return null;
                  }
                },
              ),
              widgets.addressFormFields(streetField, regionField, cityField),
            ],
          ),
        ),
      );
    }

    TabController controller =
        TabController(length: 2, vsync: this, initialIndex: _index);

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: scheme.primary,
            toolbarHeight: 50.0,
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    widgets.tabHeader('1', _index == 0),
                    widgets.tabHeader('2', _index == 1)
                  ],
                )),
          ),
          body: Stack(
            children: [
              TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  children: [
                    Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                                color: scheme.primary,
                              ),
                            ).tr(),
                            SignUpForm(),
                            GradientButton(
                              name: 'next',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  controller.index = 1;
                                  setState(() => _index = 1);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: OptionalDataForm(),
                    ),
                  ]),
              state is UserDataLoading ? state.loadingDialog : SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
