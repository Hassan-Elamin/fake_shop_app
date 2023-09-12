import 'package:fake_shop_app/business_logic/cubit/products_cubit/products_cubit.dart';
import 'package:fake_shop_app/data/data_sources/api/products_api.dart';
import 'package:fake_shop_app/data/repository/product_repository.dart';
import 'package:fake_shop_app/business_logic/cubit/cart_cubit/cart_cubit.dart';
import 'package:fake_shop_app/business_logic/cubit/search_cubit/search_cubit.dart';
//screens imports
import 'package:fake_shop_app/presentation/screens/about_us.dart';
import 'package:fake_shop_app/presentation/screens/auth_screens/sign_in_screen.dart';
import 'package:fake_shop_app/presentation/screens/auth_screens/reset_password_screen.dart';
import 'package:fake_shop_app/presentation/screens/auth_screens/sign_up_screen/sign_up_screen.dart';
import 'package:fake_shop_app/presentation/screens/dashboard_screen/dashboard_screen.dart';
import 'package:fake_shop_app/presentation/screens/favorite_list.dart';
import 'package:fake_shop_app/presentation/screens/help_and_support.dart';
import 'package:fake_shop_app/presentation/screens/offers_screen.dart';
import 'package:fake_shop_app/presentation/screens/onBoarding_screen.dart';
import 'package:fake_shop_app/presentation/screens/privacy_policy.dart';
import 'package:fake_shop_app/presentation/screens/products_view_screen/products_view_screen.dart';
import 'package:fake_shop_app/presentation/screens/settings_screen/settings_screen.dart';
import 'package:fake_shop_app/presentation/screens/splash_screen.dart';
import 'package:fake_shop_app/presentation/screens/user_data_screen/user_data_screen.dart';
import '../presentation/screens/purchase_history.dart';
// framework imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late final ProductRepository productRepository;
  late final ProductsCubit productsCubit;
  late final CartCubit cartCubit;
  late final SearchCubit searchCubit;

  AppRouter() {
    productRepository = ProductRepository(ProductsDataApi());
    productsCubit = ProductsCubit(productRepository);
    cartCubit = CartCubit();
    searchCubit = SearchCubit(productsCubit: productsCubit);
  }

  MaterialPageRoute _pageRoute({required Widget child}) =>
      MaterialPageRoute(builder: (context) => child);

  // ignore: body_might_complete_normally_nullable
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _pageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: productsCubit),
              BlocProvider.value(value: cartCubit),
              BlocProvider.value(value: searchCubit)
            ],
            child: const DashboardScreen(),
          ),
        );
      case '/products':
        return _pageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: productsCubit),
              BlocProvider.value(value: searchCubit),
              BlocProvider.value(value: cartCubit),
            ],
            child: const ProductsViewScreen(),
          ),
        );
      case "/splash":
        return _pageRoute(child: const SplashScreen());
      case "/onBoarding":
        return _pageRoute(child: const OnBoardingScreen());
      case '/sign-in':
        return _pageRoute(child: const SignInScreen());
      case '/sign-up':
        return _pageRoute(child: const SignUpScreen());
      case '/user':
        return _pageRoute(child: UserDataScreen());
      case '/favorite':
        return _pageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: searchCubit),
              BlocProvider.value(value: productsCubit),
            ],
            child: FavoriteProductsScreen(),
          ),
        );
      case '/reset_password':
        return _pageRoute(child: const ResetPasswordScreen());
      case '/orders_history':
        return _pageRoute(
          child: BlocProvider<ProductsCubit>(
            create: (context) => productsCubit,
            child: const PurchaseHistory(),
          ),
        );
      case '/settings':
        return _pageRoute(child: const SettingsScreen());
      case '/about-us':
        return _pageRoute(child: const AboutUsScreen());
      case '/offers':
        return _pageRoute(child: OffersScreen());
      case '/privacy_policy':
        return _pageRoute(child: const PrivacyPolicy());
      case '/help-support':
        return _pageRoute(child: const HelpAndSupport());
    }
  }
}
