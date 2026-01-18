import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../Fav/favourite_controller.dart';
import 'product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final favController = Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          controller.category.toUpperCase(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return const Center(child: Text("No products found"));
        }

        return GridView.builder(
          padding: EdgeInsets.all(4.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.w,
            mainAxisSpacing: 4.w,
            childAspectRatio: 0.67,
          ),
          itemCount: controller.products.length,
          itemBuilder: (_, index) {
            final product = controller.products[index];

            return GestureDetector(
              onTap: () {
                Get.toNamed(
                  AppRoutes.PRODUCT_DETAILS,
                  arguments: product['id'],
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔥 IMAGE + FAVORITE
                    Expanded(
                      child: Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Image.network(
                                product['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          /// ❤️ FAVORITE BUTTON
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Obx(() {
                              final isFav = favController
                                  .isFavorite(product['id']);

                              return GestureDetector(
                                onTap: () {
                                  favController
                                      .toggleFavorite(product);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 18,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    /// 🔥 PRODUCT INFO
                    Padding(
                      padding: EdgeInsets.all(3.5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 1.2.h),

                          /// PRICE CHIP
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 0.8.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                              AppColors.primary.withOpacity(0.12),
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: Text(
                              "\$${product['price']}",
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
