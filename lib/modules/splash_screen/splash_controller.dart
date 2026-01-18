import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/routes/app_routes.dart';
import '../../app/constants/app_keys.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkLogin();
  }

  void _checkLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppKeys.isLoggedIn) ?? false;
    print("IS LOGGED IN: $isLoggedIn");

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.MAIN);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
