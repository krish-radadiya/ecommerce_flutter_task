import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../app/theme/app_colors.dart';
import '../bottom_nav/bottom_nav_controller.dart';
import 'cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      /// 🔥 CUSTOM APP BAR (MATCH IMAGE)
      body: Obx(() {
        return Column(
          children: [
            SizedBox(height: 6.h),

            /// HEADER
            Row(
              children: [
                SizedBox(width: 1.w),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
                  splashColor: Colors.grey[200],
                  highlightColor: Colors.grey[300],
                ),
                SizedBox(width: 25.w,),
                Center(
                  child: Text(
                    "My Cart",
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900),
                  ),
                ),
                // controller.cartItems.isNotEmpty
                //     ? GestureDetector(
                //   onTap: controller.clearCart,
                //   child: const Icon(Icons.delete_outline, color: Colors.red),
                // )
                //     : const SizedBox(width: 24),
              ],
            ),

            SizedBox(height: 1.h),

            /// EMPTY CART
            if (controller.cartItems.isEmpty) emptyCartUI(),

            /// CART CONTENT
            if (controller.cartItems.isNotEmpty)
              Expanded(
                child: Stack(
                  children: [
                    /// CART LIST
                    ListView.builder(
                      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 40.h),
                      itemCount: controller.cartItems.length,
                      itemBuilder: (_, index) {
                        final item = controller.cartItems[index];

                        return Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -5))],
                          ),
                          child: Row(
                            children: [
                              /// IMAGE
                              Container(
                                width: 22.w,
                                height: 22.w,
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                                child: Image.network(item['image'], fit: BoxFit.contain),
                              ),

                              SizedBox(width: 4.w),

                              /// INFO
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['title'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        IconButton(
                                          onPressed: () => controller.removeItem(index),
                                          icon: Icon(Icons.delete_outline, color: Colors.orange),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\$${item['price']}",
                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                                          child: Row(
                                            children: [
                                              _qtyBtn(Icons.remove, () => controller.decrement(index)),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                                child: Text(
                                                  item['quantity'].toString(),
                                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 1.8.h),
                                                ),
                                              ),
                                              _qtyBtn(Icons.add, () => controller.increment(index)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    /// 🔥 BOTTOM CHECKOUT SECTION
                    Positioned(left: 0, right: 0, bottom: bottomPadding, child: _checkoutSection()),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }

  /// 🔥 CHECKOUT SECTION (MATCH IMAGE)
  Widget _checkoutSection() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          /// DISCOUNT CODE
          Container(
            height: 6.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: Text("Enter Discount Code", style: TextStyle(color: Colors.grey.shade600)),
                ),
                Text(
                  "Apply",
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          SizedBox(height: 1.h),

          _row("Subtotal", controller.totalAmount),

          // _row("Delivery", 5),
          Divider(),

          _row("Total", controller.totalAmount, isTotal: true),

          SizedBox(height: 1.5.h),

          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                controller.clearCart();

                Get.snackbar(
                  "Checkout Successful 🎉",
                  "Your order has been placed successfully",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              child: Text(
                "Checkout",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// EMPTY CART UI
  Widget _emptyCartUI() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80.sp, color: Colors.grey.shade300),
          SizedBox(height: 2.h),
          Text(
            "Your Cart is Empty",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 1.h),
          Text("Add products to get started", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 3.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Get.find<BottomNavController>().changeIndex(0);
              Get.until((route) => route.isFirst, id: 1);
            },
            child: const Text("Start Shopping"),
          ),
        ],
      ),
    );
  }

  Widget emptyCartUI() {
    return Expanded(
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
              // 2️⃣ Reset Home tab navigation
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

  Widget _qtyBtn(IconData icon, VoidCallback onTap, {bool primary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 6.w,
        height: 6.w,
        decoration: BoxDecoration(color: primary ? AppColors.primary : Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, color: primary ? Colors.white : Colors.black54),
      ),
    );
  }

  Widget _row(String title, double value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
          ),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(fontSize: isTotal ? 18.sp : 13.sp, fontWeight: FontWeight.bold, color: isTotal ? AppColors.primary : Colors.black),
          ),
        ],
      ),
    );
  }
}
