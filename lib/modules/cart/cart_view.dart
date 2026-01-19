// cart_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../bottom_nav/bottom_nav_controller.dart';
import 'cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "My Cart",
          style: TextStyle(color: Colors.black87, fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        actions: [
          // Clear Cart Button
          Obx(() {
            if (controller.cartItems.isEmpty) return SizedBox.shrink();

            return IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red, size: 20.sp),
              onPressed: () {
                Get.defaultDialog(
                  title: "Clear Cart",
                  middleText: "Are you sure you want to clear all items?",
                  textConfirm: "Yes",
                  textCancel: "No",
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  onConfirm: () {
                    controller.clearCart();
                    Get.back();
                  },
                );
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 80.sp, color: Colors.grey.shade300),
                SizedBox(height: 2.h),
                Text(
                  "Your Cart is Empty",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Add products to get started",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
                ),
                SizedBox(height: 3.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final bottomController = Get.find<BottomNavController>();

                    // 1️⃣ Switch to Home tab
                    bottomController.changeIndex(0);

                    // 2️⃣ Reset Home tab navigation stack (Dashboard)
                    Get.until((route) => route.isFirst, id: 1);
                  },

                  child: Text(
                    "Start Shopping",
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            /// CART LIST - SIMPLE DESIGN LIKE IMAGE
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                itemCount: controller.cartItems.length,
                itemBuilder: (_, index) {
                  final item = controller.cartItems[index];

                  return Container(
                    margin: EdgeInsets.only(bottom: 2.5.h),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Row(
                      children: [
                        /// IMAGE - SIMPLE SQUARE
                        Container(
                          width: 22.w,
                          height: 22.w,
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                          child: Image.network(
                            item['image'],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(Icons.image_not_supported, size: 24.sp, color: Colors.grey.shade400),
                              );
                            },
                          ),
                        ),

                        SizedBox(width: 4.w),

                        /// PRODUCT INFO - SIMPLE VERTICAL LAYOUT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                item['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,

                                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: Colors.black87),
                              ),

                              SizedBox(height: 0.5.h),

                              // Category/Subtitle
                              Text(
                                "Mini Pod", // You can replace with item['category'] if available
                                style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
                              ),

                              SizedBox(height: 1.h),

                              // Price
                              Text(
                                "\$${item['price']}",
                                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: Colors.black),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 5.w),

                        /// QUANTITY CONTROLS - SIMPLE AND CLEAN
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // DELETE BUTTON (Top)
                            GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                  title: "Remove Item",
                                  middleText: "Remove this item from cart?",
                                  textConfirm: "Yes",
                                  textCancel: "No",
                                  confirmTextColor: Colors.white,
                                  buttonColor: Colors.red,
                                  onConfirm: () {
                                    controller.removeItem(index);
                                    Get.back();
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(1.5.w),
                                decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                                child: Icon(Icons.delete_outline, color: Colors.grey.shade600, size: 16.sp),
                              ),
                            ),

                            SizedBox(height: 2.h),

                            // QUANTITY CONTROLS
                            Container(
                              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  // Minus Button
                                  GestureDetector(
                                    onTap: () => controller.decrement(index),
                                    child: Container(
                                      width: 9.w,
                                      height: 9.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                      ),
                                      child: Center(
                                        child: Icon(Icons.remove, size: 12.sp, color: Colors.black87),
                                      ),
                                    ),
                                  ),

                                  // Quantity
                                  Container(
                                    width: 12.w,
                                    height: 9.w,
                                    color: Colors.grey.shade100,
                                    alignment: Alignment.center,
                                    child: Text(
                                      item['quantity'].toString(),
                                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                                    ),
                                  ),

                                  // Plus Button
                                  GestureDetector(
                                    onTap: () => controller.increment(index),
                                    child: Container(
                                      width: 9.w,
                                      height: 9.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                                      ),
                                      child: Center(
                                        child: Icon(Icons.add, size: 12.sp, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// TOTAL + CHECKOUT SECTION - SIMPLE DESIGN
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10, offset: Offset(0, -5))],
              ),
              child: Column(
                children: [
                  // Subtotal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Subtotal",
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "\$${controller.totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 13.sp, color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Delivery
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery",
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "\$5.00",
                        style: TextStyle(fontSize: 13.sp, color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  SizedBox(height: 0.5.h),

                  Divider(color: Colors.grey.shade300, thickness: 1),

                  SizedBox(height: 0.5.h),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.black87),
                      ),
                      Text(
                        "\$${(controller.totalAmount + 5.0).toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.5.h),

                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    height: 5.5.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // Show success message directly
                        Get.snackbar(
                          'Checkout Successfully!',
                          'Order placed for \$${(controller.totalAmount + 5.0).toStringAsFixed(2)}',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 3),
                          icon: Icon(Icons.check_circle, color: Colors.white),
                        );
                      },
                      child: Text(
                        "Checkout",
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
