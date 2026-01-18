// product_details_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:share_plus/share_plus.dart';
import '../../app/theme/app_colors.dart';
import '../Fav/favourite_controller.dart';
import 'product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get FavoriteController
    final FavoriteController favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        final product = controller.product;
        final productId = product['id'];

        return Column(
          children: [
            // ================= IMAGE SECTION =================
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.grey.shade50,
                child: Stack(
                  children: [
                    // Product Image
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        child: Image.network(
                          product['image'],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported,
                              size: 50.sp,
                              color: Colors.grey.shade400,
                            );
                          },
                        ),
                      ),
                    ),

                    // Top Bar - Back, Favorite, Share
                    Positioned(
                      top: 5.h,
                      left: 4.w,
                      right: 4.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back Button
                          _buildIconButton(
                            icon: Icons.arrow_back_ios_new,
                            onTap: () => Get.back(),
                          ),

                          // Favorite & Share Buttons
                          Row(
                            children: [
                              // Favorite Button with Obx
                              Obx(() {
                                final isFav = favoriteController.isFavorite(productId);

                                return _buildIconButton(
                                  icon: isFav ? Icons.favorite : Icons.favorite_border,
                                  iconColor: isFav ? Color(0xFFFF6B35) : Colors.black87,
                                  onTap: () {
                                    favoriteController.toggleFavorite(product);

                                    Get.snackbar(
                                      isFav ? 'Removed' : 'Added',
                                      isFav
                                          ? 'Removed from favorites'
                                          : 'Added to favorites',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.black87,
                                      colorText: Colors.white,
                                      duration: Duration(seconds: 2),
                                      margin: EdgeInsets.all(4.w),
                                      borderRadius: 10,
                                    );
                                  },
                                );
                              }),

                              SizedBox(width: 3.w),

                              // Share Button
                              _buildIconButton(
                                icon: Icons.share_outlined,
                                onTap: () {
                                  _shareProduct(product);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ================= DETAILS SECTION =================
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product['category'].toString().toUpperCase(),
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    SizedBox(height: 1.5.h),

                    // Product Title
                    Text(
                      product['title'],
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 1.h),

                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFFFC107), size: 16.sp),
                        SizedBox(width: 1.w),
                        Text(
                          product['rating']['rate'].toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '(${product['rating']['count']} reviews)',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Price
                    Text(
                      "\$${product['price']}",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: 2.5.h),

                    // Color Label
                    Text(
                      "Available Colors",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 1.2.h),

                    // Color Options
                    Row(
                      children: [
                        _colorDot(Color(0xFFFF6B35), true),
                        SizedBox(width: 3.w),
                        _colorDot(Color(0xFF4ECDC4), false),
                        SizedBox(width: 3.w),
                        _colorDot(Color(0xFF95E1D3), false),
                        SizedBox(width: 3.w),
                        _colorDot(Color(0xFFFFC107), false),
                        SizedBox(width: 3.w),
                        _colorDot(Color(0xFF000000), false),
                      ],
                    ),

                    SizedBox(height: 2.5.h),

                    // Description Label
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Description Text
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          product['description'],
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // ================= ADD TO CART BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: 6.5.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: controller.addToCart,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ================= ICON BUTTON =================
  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 11.w,
        height: 11.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.black87,
          size: 18.sp,
        ),
      ),
    );
  }

  // ================= COLOR DOT =================
  Widget _colorDot(Color color, bool selected) {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: selected ? AppColors.primary : Colors.grey.shade300,
          width: selected ? 3 : 2,
        ),
        boxShadow: selected
            ? [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ]
            : [],
      ),
      child: selected
          ? Center(
        child: Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      )
          : null,
    );
  }

  // ================= SHARE PRODUCT =================
  void _shareProduct(Map<String, dynamic> product) {
    final String shareText = '''
🛍️ Check out this amazing product!

📦 ${product['title']}

💰 Price: \$${product['price']}
⭐ Rating: ${product['rating']['rate']}/5 (${product['rating']['count']} reviews)

📝 ${product['description']}

🔗 Product Image: ${product['image']}
    '''.trim();

    Share.share(
      shareText,
      subject: product['title'],
    );

    Get.snackbar(
      'Share',
      'Product shared successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(4.w),
      borderRadius: 10,
      icon: Icon(Icons.share, color: Colors.white),
    );
  }
}