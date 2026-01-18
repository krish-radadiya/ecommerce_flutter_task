// favourite_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../app/theme/app_colors.dart';
import 'favourite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({super.key});

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
          "My Favorites",
          style: TextStyle(color: Colors.black87, fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: Obx(() {
        if (controller.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 60.sp, color: Colors.grey.shade300),
                SizedBox(height: 2.h),
                Text(
                  "No Favorite Products",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Add products to your favorites",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(4.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 3.w,
            childAspectRatio: 0.68,
          ),
          itemCount: controller.favorites.length,
          itemBuilder: (_, index) {
            final product = controller.favorites[index];
            final productId = product['id'];

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with Remove Icon
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Image.network(
                                product['image'],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.image_not_supported, size: 40.sp, color: Colors.grey.shade400);
                                },
                              ),
                            ),
                          ),

                          // Remove Favorite Icon - Top Right
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                controller.removeFavorite(productId);

                                // Get.snackbar(
                                //   'Removed',
                                //   'Product removed from favorites',
                                //   snackPosition: SnackPosition.BOTTOM,
                                //   backgroundColor: Colors.black87,
                                //   colorText: Colors.white,
                                //   duration: Duration(seconds: 2),
                                //   margin: EdgeInsets.all(4.w),
                                //   borderRadius: 10,
                                // );
                              },
                              child: Container(
                                padding: EdgeInsets.all(1.8.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, spreadRadius: 1)],
                                ),
                                child: Icon(Icons.favorite, size: 16.sp, color: Color(0xFFFF6B35)),
                              ),
                            ),
                          ),

                          // Discount Badge
                          if (product['price'] > 100)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
                                decoration: BoxDecoration(color: Color(0xFFFF6B35), borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  '20%',
                                  style: TextStyle(fontSize: 8.sp, color: Colors.white, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Product Details
                  Padding(
                    padding: EdgeInsets.all(2.8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          product['title'].length > 28 ? '${product['title'].substring(0, 28)}...' : product['title'],
                          style: TextStyle(fontSize: 9.5.sp, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.8.h),

                        // Color Options
                        Row(
                          children: [
                            _buildColorDot(Color(0xFFFF6B35)),
                            SizedBox(width: 1.5.w),
                            _buildColorDot(Color(0xFF4ECDC4)),
                            SizedBox(width: 1.5.w),
                            _buildColorDot(Color(0xFF95E1D3)),
                            SizedBox(width: 1.5.w),
                            _buildColorDot(Color(0xFFFFC107)),
                          ],
                        ),
                        SizedBox(height: 1.h),

                        // Price and Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${product['price']}',
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900, color: Colors.black),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                              decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                children: [
                                  Icon(Icons.star, color: Color(0xFFFFC107), size: 11.sp),
                                  SizedBox(width: 0.5.w),
                                  Text(
                                    product['rating']['rate'].toString(),
                                    style: TextStyle(fontSize: 9.sp, color: Colors.grey.shade800, fontWeight: FontWeight.w600),
                                  ),
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
        );
      }),
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      width: 4.5.w,
      height: 4.5.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 3, spreadRadius: 0.5)],
      ),
    );
  }
}
