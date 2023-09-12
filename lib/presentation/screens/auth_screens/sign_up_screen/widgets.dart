import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/core/helper/text_field_validator.dart';
import 'package:fake_shop_app/presentation/widgets/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import '../../../widgets/borders.dart';

class SignUpWidgets {
  final BuildContext context;

  late final Size _size;

  late final ColorScheme _scheme;
  late final AppBorders _borders;

  SignUpWidgets({required this.context}) {
    _size = DesignHelper.getTheSize(context);
    _scheme = DesignHelper.getScheme(context);
    _borders = AppBorders(context: context);
  }

  final List<String> genders = ['male', 'female'];

  Widget dateSelectField(
      TextEditingController controller, void Function() onTap) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _scheme.onBackground.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: _scheme.onBackground.withOpacity(0.5),
            blurRadius: 1.5,
            spreadRadius: 0,
            blurStyle: BlurStyle.outer,
          )
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        validator: (value) {
          if (Validator.isBirthDateValidated(
              DateTime.tryParse(value ?? '') ?? DateTime.now())) {
            return 'please enter your birthdate';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: "${"birth date".tr()} ${"[optional]".tr()}",
          prefixIcon: const Icon(Icons.date_range_outlined),
          border: _borders.inputDecoration('hint').border,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget tabHeader(String num, bool selected) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: CircleAvatar(
          backgroundColor: selected ? _scheme.primary : Colors.transparent,
          radius: 20.0,
          child: Text(num,
              style: TextStyle(
                color: selected ? _scheme.onPrimary : _scheme.onBackground,
              )),
        ),
      );

  Widget addressFormFields(
    TextEditingController streetField,
    TextEditingController regionField,
    TextEditingController cityField,
  ) =>
      SizedBox(
        height: 225.0,
        width: _size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Address',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: _scheme.primary),
              ),
            ),
            CustomTextField(
              controller: streetField,
              inputDecoration: _borders.inputDecoration('street'),
              validator: (value) {
                if (!Validator.nullSafetyValidate(value)) {
                  return 'you did not enter the street name'.tr();
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              width: _size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextField(
                    controller: regionField,
                    width: _size.width * 0.45,
                    inputDecoration: _borders.inputDecoration('region'),
                    validator: (value) {
                      if (!Validator.nullSafetyValidate(value)) {
                        return "you did not enter the region name".tr();
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomTextField(
                    width: _size.width * 0.45,
                    controller: cityField,
                    validator: (value) {
                      if (!Validator.nullSafetyValidate(value)) {
                        return 'you did not enter the city name'.tr();
                      } else {
                        return null;
                      }
                    },
                    inputDecoration: _borders.inputDecoration('city'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
