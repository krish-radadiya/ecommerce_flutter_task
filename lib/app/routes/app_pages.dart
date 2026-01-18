import 'package:get/get.dart';
import '../../modules/bottom_nav/bottom_nav_binding.dart';
import '../../modules/bottom_nav/bottom_nav_view.dart';
import '../../modules/cart/cart_binding.dart';
import '../../modules/cart/cart_view.dart';
import '../../modules/dashboard_screen/dashboard_binding.dart';
import '../../modules/dashboard_screen/dashboard_view.dart';
import '../../modules/login_screen/login_binding.dart';
import '../../modules/login_screen/login_view.dart';
import '../../modules/product_details/product_details_binding.dart';
import '../../modules/product_details/product_details_view.dart';
import '../../modules/product_list/product_list_binding.dart';
import '../../modules/product_list/product_list_view.dart';
import '../../modules/splash_screen/splash_binding.dart';
import '../../modules/splash_screen/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () =>  DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.MAIN,
      page: () => const BottomNavView(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: AppRoutes.PRODUCT_LIST,
      page: () => const ProductListView(),
      binding: ProductListBinding(),
    ),
    GetPage(
      name: AppRoutes.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
  ];
}

