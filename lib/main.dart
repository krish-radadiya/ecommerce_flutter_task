import 'package:ecommerce_flutter_task/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'app/routes/app_pages.dart';
import 'app/bindings/initial_binding.dart';
import 'app/theme/app_strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          initialBinding: InitialBinding(),
          initialRoute: AppRoutes.SPLASH,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
