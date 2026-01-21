/// product_details_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:share_plus/share_plus.dart';
import '../../app/theme/app_colors.dart';
import '../Fav/favourite_controller.dart';
import '../cart/cart_controller.dart';
import 'product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = controller.product;
        final productId = product['id'];

        return Column(
          children: [
            /// ================= IMAGE SECTION (FIXED) =================
            Container(
              height: 35.h,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Stack(
                children: [
                  Center(
                    child: Image.network(
                      product['image'],
                      height: 25.h,
                      fit: BoxFit.contain,
                    ),
                  ),

                  /// BACK
                  Positioned(
                    top: 5.h,
                    left: 4.w,
                    child: _circleIcon(Icons.arrow_back_ios_new, () => Get.back()),
                  ),

                  /// FAVORITE
                  Positioned(
                    top: 5.h,
                    right: 4.w,
                    child: Obx(() {
                      final isFav = favoriteController.isFavorite(productId);
                      return _circleIcon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                            () => favoriteController.toggleFavorite(product),
                        color: isFav ? const Color(0xFFFF6B35) : Colors.black,
                      );
                    }),
                  ),

                  /// SHARE
                  Positioned(
                    top: 5.h,
                    right: 16.w,
                    child: _circleIcon(Icons.share_outlined, () => _shareProduct(product)),
                  ),
                ],
              ),
            ),

            /// ================= DETAILS SECTION (FIXED) =================
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE
                        Text(
                          product['title'],
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
                        ),

                        SizedBox(height: 1.h),

                        /// PRICE + SELLER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${product['price']}",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              "Seller: Syed Noman",
                              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                            ),
                          ],
                        ),

                        SizedBox(height: 1.5.h),

                        /// RATING
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFFFC107)),
                            SizedBox(width: 1.w),
                            Text(
                              product['rating']['rate'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              "(${product['rating']['count']} Reviews)",
                              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.5.h),

                        /// COLORS
                        Text("Color", style: const TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 1.h),

                        Obx(() => Row(
                          children: List.generate(
                            controller.colors.length,
                                (index) {
                              final selected = controller.selectedColor.value == index;
                              return GestureDetector(
                                onTap: () => controller.selectColor(index),
                                child: Container(
                                  margin: EdgeInsets.only(right: 3.w),
                                  padding: EdgeInsets.all(0.8.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected ? AppColors.primary : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Container(
                                    width: 6.w,
                                    height: 6.w,
                                    decoration: BoxDecoration(
                                      color: controller.colors[index],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )),

                        SizedBox(height: 3.h),

                        /// ================= TABS (FIXED) =================
                        Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            controller.tabs.length,
                                (i) {
                              final active = controller.selectedTab.value == i;
                              return GestureDetector(
                                onTap: () => controller.changeTab(i),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: active ? AppColors.primary : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    controller.tabs[i],
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w700,
                                      color: active ? Colors.white : Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )),

                        SizedBox(height: 2.h),

                        /// ================= TAB CONTENT (SCROLLABLE) =================
                        Expanded(
                          child: Obx(() {
                            return SingleChildScrollView(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (controller.selectedTab.value == 0)
                                  /// DESCRIPTION
                                    Text(
                                      product['description'] ?? 'No description available',
                                      style: const TextStyle(height: 1.6, color: Colors.black87),
                                    )
                                  else if (controller.selectedTab.value == 1)
                                  /// SPECIFICATION
                                    Text(
                                      product['title'] ?? 'No specification available',
                                      style: const TextStyle(height: 1.6, color: Colors.black87),
                                    )
                                  else
                                  /// REVIEW
                                    Text(
                                      product['description'] ?? 'No reviews available',
                                      style: const TextStyle(height: 1.6, color: Colors.black87),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  /// ================= ADD TO CART (FIXED AT BOTTOM) =================
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 10.h,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          /// QTY
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                IconButton(onPressed: controller.decreaseQty, icon: const Icon(Icons.remove)),
                                Obx(() => Text(controller.quantity.value.toString())),
                                IconButton(onPressed: controller.increaseQty, icon: const Icon(Icons.add)),
                              ],
                            ),
                          ),

                          SizedBox(width: 4.w),

                          /// ADD TO CART
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                padding: EdgeInsets.symmetric(vertical: 1.6.h),
                              ),
                              onPressed: controller.addToCart,
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
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

  Widget _circleIcon(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Icon(icon, color: color ?? Colors.black),
      ),
    );
  }

  void _shareProduct(Map product) {
    Share.share("${product['title']} - \$${product['price']}");
  }
}