// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/business_logic/cubit/search_cubit/search_cubit.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:flutter/material.dart';

class SortByButton extends StatefulWidget {
  final SearchCubit searchCubit;

  const SortByButton({required this.searchCubit, super.key});

  @override
  State<SortByButton> createState() => _SortByButtonState();
}

class _SortByButtonState extends State<SortByButton> {
  List<SortBy> sortList = SortBy.values.toList();
  List<SortTypes> sortTypes = SortTypes.values.toList();

  PopupMenuItem<SortTypes> sortTypeElement(SortTypes type, SortBy sortBy) =>
      PopupMenuItem(
          value: type,
          onTap: () {
            final cubit = widget.searchCubit;
            cubit.sort =
                cubit.sortTheList(cubit.currentProductsList, sortBy, type);
          },
          child: Text(type.name).tr());

  PopupMenuButton<SortTypes> sortTypesList(SortBy sortBy) => PopupMenuButton(
        itemBuilder: (context) {
          return List.generate(sortTypes.length,
              (index) => sortTypeElement(sortTypes[index], sortBy));
        },
        elevation: 2.5,
        child: ListTile(
          title: Text(sortBy.name).tr(),
        ),
      );

  PopupMenuItem<SortBy> sortMenuItem(SortBy value) => PopupMenuItem<SortBy>(
        value: value,
        padding: const EdgeInsets.all(0),
        child: sortTypesList(value),
      );

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = DesignHelper.getScheme(context);
    return PopupMenuButton<SortBy>(
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      itemBuilder: (context) {
        return List.generate(
            sortList.length,
            (index) => sortMenuItem(
                  sortList[index],
                ));
      },
      child: Material(
        color: scheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 1,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            children: [
              Icon(Icons.sort, size: 25, color: scheme.onSecondary),
              Text('sort by'.tr(),
                  style: TextStyle(fontSize: 20.0, color: scheme.onSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
