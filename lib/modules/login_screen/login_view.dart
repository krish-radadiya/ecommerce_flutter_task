import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../app/theme/app_strings.dart';
import '../../app/theme/app_colors.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 12.h),

              // "Hello Again!" - Matches the exact text from image
              Text(
                "Hello Again!", // Changed from AppStrings.helloAgain
                style: TextStyle(
                  fontSize: 20.sp, // Slightly larger as shown in image
                  fontWeight: FontWeight.w900, // Bolder font
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 0.5.h), // Reduced spacing
              // "Welcome back you've been missed!" - Matches the exact text from image
              Text(
                "Welcome back you've \n        been missed!", // Changed from AppStrings.welcomeBack
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black, // Darker grey
                  height: 1.4,
                  fontWeight: FontWeight.w500, // Bolder font
                ),
              ),

              SizedBox(height: 6.h), // Increased spacing
              /// EMAIL FIELD - "Enter email" as shown in image
              TextFormField(
                controller: controller.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Email required";
                  if (!GetUtils.isEmail(v)) return "Invalid email";
                  return null;
                },
                decoration: _decoration("Enter email"), // Changed hint text
              ),

              SizedBox(height: 2.5.h),

              /// PASSWORD FIELD - "Password" as shown in image
              Obx(() {
                return TextFormField(
                  controller: controller.password,
                  obscureText: controller.isHidden.value,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Password required";
                    if (v.length < 6) return "Minimum 6 characters";
                    return null;
                  },
                  decoration: _decoration(
                    "Password", // Changed hint text
                    suffix: IconButton(
                      icon: Icon(controller.isHidden.value ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade600),
                      onPressed: controller.togglePassword,
                    ),
                  ),
                );
              }),

              SizedBox(height: 1.h),

              /// RECOVERY PASSWORD - "Recovery Password" as shown in image
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Recovery Password", // Changed from AppStrings.recoveryPassword
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.primary, // Should be primary color
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              /// SIGN IN BUTTON - "Sign In" as shown in image
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Slightly less rounded
                    ),
                    elevation: 2, // Added subtle shadow
                  ),
                  onPressed: controller.login,
                  child: Text(
                    "Sign In", // Changed from AppStrings.signIn
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              /// OR CONTINUE WITH - "or continue with" as shown in image
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.black, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Text(
                        "or continue with", // Changed from AppStrings.orContinue
                        style: TextStyle(fontSize: 12.sp, color: Colors.black),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.black, thickness: 1)),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              /// SOCIAL ICONS - Exactly as shown in image
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Icon(Icons.g_mobiledata, size: 32, color: Colors.red),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Icon(Icons.apple, size: 28, color: Colors.black),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Icon(Icons.facebook, size: 28, color: Colors.blue),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              /// NOT A MEMBER? REGISTER NOW - As shown in image
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?", // Changed from AppStrings.notMember
                      style: TextStyle(fontSize: 11.sp, color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Register now", // Added "Register now" as shown in image
                        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp),
      filled: true,
      fillColor: Colors.grey.shade50,
      suffixIcon: suffix,
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.5.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
