import 'package:get/get.dart';
import '../Fav/favourite_controller.dart';
import '../cart/cart_controller.dart';
import '../dashboard_screen/dashboard_controller.dart';
import 'bottom_nav_controller.dart';


class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavController());

    Get.put(DashboardController(), permanent: true);
    Get.put(CartController(), permanent: true);

    // 🔥 FAVORITE CONTROLLER
    Get.put(FavoriteController(), permanent: true);
  }
}

