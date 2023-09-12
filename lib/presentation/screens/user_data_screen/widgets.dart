import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/business_logic/cubit/user_cubit.dart/user_cubit.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/presentation/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataScreenWidgets {
  final BuildContext context;
  late final Size size;

  UserDataScreenWidgets({required this.context}) {
    size = DesignHelper.getTheSize(context);
  }

  Widget dataRow(String labelName, String data, void Function()? onEdit) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labelName.tr(),
            style: const TextStyle(
              fontSize: 22.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data,
                  style: const TextStyle(fontSize: 17.5),
                ),
              ),
              onEdit != null
                  ? GestureDetector(
                      onTap: onEdit, child: const Icon(Icons.edit))
                  : const SizedBox(),
            ],
          ),
          Divider(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
    );
  }

  Widget logOutButton() {
    return MaterialButton(
      onPressed: () => showDialog(
          context: context,
          builder: (context) => ConfirmDialog(onPressedYes: () async {
                await BlocProvider.of<UserCubit>(context)
                    .logOut()
                    .then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/sign-in', (route) => false);
                });
              })),
      minWidth: size.width * 0.35,
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1.0,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(15)),
      child: const Text(
        'log out',
        style: TextStyle(color: Colors.red, fontSize: 20),
      ).tr(),
    );
  }
}
