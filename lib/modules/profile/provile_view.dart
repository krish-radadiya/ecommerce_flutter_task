import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../app/constants/app_keys.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Future<Map<String, String>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(AppKeys.userName) ?? "User",
      'email': prefs.getString(AppKeys.userEmail) ?? "example@mail.com",
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: Column(
            children: [
              /// 🔥 TOP PROFILE HEADER
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 6.h),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    /// AVATAR
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Text(
                        user['name']![0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    /// NAME
                    Text(
                      user['name']!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 0.5.h),

                    /// EMAIL
                    Text(
                      user['email']!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5.h),

              /// INFO CARD
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      _infoRow(Icons.person, "Name", user['name']!),
                      Divider(height: 4.h),
                      _infoRow(Icons.email, "Email", user['email']!),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              /// 🔴 LOGOUT BUTTON
              Padding(
                padding: EdgeInsets.all(6.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 7.h,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      final prefs =
                      await SharedPreferences.getInstance();
                      await prefs.clear();

                      Get.offAllNamed(AppRoutes.LOGIN);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔹 INFO ROW WIDGET
  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        SizedBox(width: 4.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
