import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fake_shop_app/business_logic/cubit/search_cubit/search_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/products_cubit/products_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/user_cubit.dart/user_cubit.dart';
import 'package:fake_shop_app/core/helper/design_helper.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/presentation/widgets/custom_widgets/custom_text_field.dart';
import 'package:fake_shop_app/presentation/widgets/product_item.dart';
import 'package:fake_shop_app/res/assets_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardWidgets {
  final BuildContext context;
  late final Size size;
  late final ColorScheme scheme;
  late final ProductsCubit productsCubit;
  late final SearchCubit _searchCubit;
  late final NavigatorState _navigator;

  DashboardWidgets({required this.context}) {
    size = MediaQuery.of(context).size;
    scheme = DesignHelper.getScheme(context);
    productsCubit = BlocProvider.of<ProductsCubit>(context);
    _searchCubit = SearchCubit.of(context);
    _navigator = Navigator.of(context);
  }

  Widget _sliderItem(String asset) {
    return InkWell(
      onTap: () => _navigator.pushNamed('/offers'),
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          asset,
          fit: BoxFit.fill,
          width: size.width,
        ),
      ),
    );
  }

  Widget _slider() {
    return Container(
      padding: EdgeInsets.only(top: size.height * 0.025),
      height: size.height * 0.35,
      width: size.width,
      child: CarouselSlider(
        options: CarouselOptions(
          padEnds: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          enableInfiniteScroll: false,
        ),
        items: [
          _sliderItem(AssetsRes.BLACK_FRIDAY_SALE),
          _sliderItem(AssetsRes.FLAT_SALE_BANNER),
          _sliderItem(AssetsRes.MEGA_SALE_BANNER),
          _sliderItem(AssetsRes.RAMDAN_SALE_BANNER),
          _sliderItem(AssetsRes.SALES80S_BACKGROUND),
        ],
      ),
    );
  }

  PreferredSize _dashboardAppBarBottom() => PreferredSize(
      preferredSize: Size.fromHeight(size.height * 0.075),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomTextField(
          controller: TextEditingController(),
          inputDecoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Looking for something ?'.tr(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              hintStyle: const TextStyle(
                color: Colors.white,
              )),
          readOnly: true,
          onTap: () {
            BlocProvider.of<SearchCubit>(context).switchSearchMode();
            _navigator.pushNamed('/products');
          },
        ),
      ));

  Widget dashboardAppBar() => SliverAppBar(
        expandedHeight: size.height * 0.5,
        flexibleSpace: FlexibleSpaceBar(
          background: _slider(),
        ),
        forceElevated: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15.0),
        )),
        elevation: 5,
        toolbarHeight: size.height * 0.075,
        pinned: true,
        title: BlocBuilder<UserCubit, UserState>(
          builder: (context, currentState) {
            if (currentState is UserSignedIn) {
              File? image = currentState.userData.userOtherData.photo;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.antiAlias,
                    child: image != null
                        ? Image.file(image)
                        : Image.asset(AssetsRes.NO_IMAGE_USER),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "Welcome Back".tr(),
                          style: const TextStyle(
                              fontSize: 17.5, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "\n ${currentState.userData.display_name}",
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ]))),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        centerTitle: true,
        titleSpacing: 0,
        bottom: _dashboardAppBarBottom(),
      );

  Widget cusButton(String name, IconData icon, Color color,
      [void Function()? onTap]) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50.0),
      child: Container(
        height: size.height * 0.105,
        width: size.height * 0.105,
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: scheme.onBackground.withOpacity(0.5),
              blurRadius: 5,
              blurStyle: BlurStyle.normal,
              offset: const Offset(1.5, 1.5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: size.height * 0.035, color: Colors.white),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ).tr(),
          ],
        ),
      ),
    );
  }

  Widget options() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cusButton(
              'favorite',
              Icons.favorite,
              const Color(0xFFFF006F),
              () => _navigator.pushNamed('/favorite'),
            ),
            cusButton(
              'orders history',
              Icons.receipt,
              const Color(0xFF0059FF),
              () => _navigator.pushNamed('/orders_history'),
            ),
            cusButton(
              'offers',
              Icons.discount,
              const Color(0xFF00FF73),
              () => _navigator.pushNamed('/offers'),
            ),
          ],
        ),
      );

  Widget categories() {
    return BlocBuilder<ProductsCubit, ProductsDataState>(
      builder: (context, state) {
        if (state is ProductsDataLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                height: size.height * 0.05,
                width: size.width,
                child: const Text(
                  'Categories',
                  style: TextStyle(fontSize: 25.0),
                ).tr(),
              ),
              SizedBox(
                height: size.height * 0.25,
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: size.height * 0.065,
                        crossAxisSpacing: 7.5,
                        mainAxisSpacing: 15.0),
                    itemCount: state.categories.length,
                    padding: const EdgeInsets.all(5),
                    itemBuilder: (context, index) {
                      return FilledButton.tonal(
                        onPressed: () {
                          _searchCubit.addCategory =
                              state.categories[index].name;
                          _searchCubit.searchOnProducts();
                          _navigator.pushNamed('/products');
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(5.0),
                        ),
                        child: Text(
                          state.categories[index].name,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget topProducts(List<ProductModel> dataList) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          height: MediaQuery.of(context).size.height * 0.05,
          width: double.infinity,
          child: const Text(
            'Trending',
            style: TextStyle(fontSize: 25.0),
          ).tr(),
        ),
        ProductViewBuilder(
            dataList: dataList,
            withHero: false,
            onTap: (product, gradient) {
              _searchCubit.getOneProduct(product.id);
              _navigator.pushNamed('/products');
            }),
      ],
    );
  }
}
