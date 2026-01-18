import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/routes/app_routes.dart';
import '../../app/constants/app_keys.dart';

class LoginController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  final isHidden = true.obs;
  final formKey = GlobalKey<FormState>();

  void togglePassword() {
    isHidden.value = !isHidden.value;
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();

      // ✅ SAVE LOGIN + USER INFO
      await prefs.setBool(AppKeys.isLoggedIn, true);
      await prefs.setString(AppKeys.userEmail, email.text);
      await prefs.setString(
        AppKeys.userName,
        email.text.split('@').first.capitalizeFirst ?? "User",
      );

      Get.offAllNamed(AppRoutes.MAIN);
    }
  }
}
