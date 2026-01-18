import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../Fav/favourite_controller.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  DashboardView({super.key});

  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSpecialOffers(),
                    _buildCategoriesSection(),
                    _buildSectionHeader(),
                    _buildProductsGrid(),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ APP BAR ------------------
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _roundIcon(Icons.menu),
          // Text(
          //   'SHOPPIFY',
          //   style: TextStyle(
          //     fontSize: 19.sp,
          //     fontWeight: FontWeight.w900,
          //     letterSpacing: 1,
          //   ),
          // ),
          InkWell(borderRadius: BorderRadius.circular(12), onTap: () {}, child: _roundIcon(Icons.notifications)),
        ],
      ),
    );
  }

  Widget _roundIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(2.3.w),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
      child: Icon(icon, size: 20.sp),
    );
  }

  // ------------------ SEARCH ------------------
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
      child: Container(
        height: 6.5.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey.shade600, size: 18.sp),
            SizedBox(width: 3.w),
            Expanded(
              child: TextField(
                onChanged: controller.searchProducts,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Special Offers Widget - Premium Beautiful Design (Overflow Fixed)
  Widget _buildSpecialOffers() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return SizedBox(
          height: screenHeight * 0.225, // 22.5% of screen height
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.92),
            physics: BouncingScrollPhysics(),
            itemCount: _specialItems.length,
            itemBuilder: (context, index) {
              final item = _specialItems[index];

              return Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: item['bgColor'],
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: Offset(0, 8), spreadRadius: -3)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      /// DECORATIVE CIRCLES
                      Positioned(
                        top: -30,
                        right: -30,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)),
                        ),
                      ),
                      Positioned(
                        bottom: -40,
                        left: -40,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
                        ),
                      ),

                      /// MAIN CONTENT
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
                        child: Row(
                          children: [
                            /// LEFT CONTENT
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// CATEGORY BADGE
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenHeight * 0.005),
                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(20)),
                                    child: Text(
                                      item['category'],
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.022,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.01),

                                  /// TITLE
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      height: 1.1,
                                      letterSpacing: -0.5,
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.005),

                                  /// SUBTITLE
                                  Text(
                                    item['subtitle'],
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withOpacity(0.95),
                                      height: 1.2,
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.015),

                                  /// SHOP NOW BUTTON
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: Offset(0, 4))],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item['button'],
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.028,
                                            fontWeight: FontWeight.w800,
                                            color: item['bgColor'],
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        Icon(Icons.arrow_forward_rounded, color: item['bgColor'], size: screenWidth * 0.038),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: screenWidth * 0.03),

                            /// RIGHT IMAGE
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: screenHeight * 0.16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 15, offset: Offset(-3, 5))],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.network(
                                    item['image'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) {
                                      return Container(
                                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(18)),
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: screenWidth * 0.095,
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// DISCOUNT BADGE - Top Right
                      Positioned(
                        top: screenWidth * 0.03,
                        right: screenWidth * 0.03,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.008),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: Offset(0, 3))],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.local_offer_rounded, size: screenWidth * 0.03, color: item['bgColor']),
                              SizedBox(width: screenWidth * 0.01),
                              Text(
                                item['discount'],
                                style: TextStyle(
                                  fontSize: screenWidth * 0.025,
                                  fontWeight: FontWeight.w900,
                                  color: item['bgColor'],
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// DOT INDICATORS - Bottom Left
                      Positioned(
                        bottom: screenHeight * 0.02,
                        left: screenWidth * 0.04,
                        child: Row(
                          children: List.generate(
                            _specialItems.length,
                            (dotIndex) => AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: dotIndex == index ? screenWidth * 0.05 : screenWidth * 0.015,
                              height: screenHeight * 0.01,
                              margin: EdgeInsets.only(right: screenWidth * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: dotIndex == index ? Colors.white : Colors.white.withOpacity(0.35),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Premium Special Items Data - Different Categories
  final List<Map<String, dynamic>> _specialItems = [
    {
      'category': 'LUXURY',
      'title': 'Jewellery',
      'subtitle': 'Elegant Collection\nUp to 40% OFF',
      'button': 'Shop Now',
      'discount': '40% OFF',
      'image': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338',
      'bgColor': Color(0xFFE17055), // Coral
    },
    {
      'category': 'TECH',
      'title': 'Electronics',
      'subtitle': 'Smart Gadgets\nUp to 50% OFF',
      'button': 'Shop Now',
      'discount': '50% OFF',
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
      'bgColor': Color(0xFF6C5CE7), // Purple
    },

    {
      'category': 'STYLE',
      'title': 'Men Fashion',
      'subtitle': 'Trendy Outfits\nUp to 45% OFF',
      'button': 'Shop Now',
      'discount': '45% OFF',
      'image': 'https://images.unsplash.com/photo-1490114538077-0a7f8cb49891',
      'bgColor': Color(0xFF0984E3), // Blue
    },
    {
      'category': 'TREND',
      'title': 'Women Fashion',
      'subtitle': 'Latest Styles\nUp to 60% OFF',
      'button': 'Shop Now',
      'discount': '60% OFF',
      'image': 'https://images.unsplash.com/photo-1483985988355-763728e1935b',
      'bgColor': Color(0xFF00B894), // Green
    },
  ];

  // Updated Special Items Data
  // ------------------ CATEGORIES ------------------
// ------------------ CATEGORIES ------------------
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          child: Text(
            'Category',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final icons = {
            'All': Icons.grid_view_rounded,
            'electronics': Icons.devices,
            'jewelery': Icons.diamond,
            'men\'s clothing': Icons.checkroom,
            'women\'s clothing': Icons.woman,
          };

          final categories = ['All', ...controller.categories];

          return SizedBox(
            height: 10.5.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return Obx(() {
                  final selected =
                      controller.selectedCategory.value == category;

                  return GestureDetector(
                    onTap: () => controller.selectCategory(category),
                    child: Container(
                      width: 18.w,
                      margin: EdgeInsets.only(right: 3.w),
                      child: Column(
                        children: [
                          /// ICON CONTAINER (NO SHADOW, ONLY BORDER)
                          Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                width: selected ? 2 : 1.2,
                              ),
                            ),
                            child: Icon(
                              icons[category] ?? Icons.shopping_bag,
                              size: 18.sp,
                              color: selected
                                  ? AppColors.primary
                                  : Colors.grey.shade600,
                            ),
                          ),

                          SizedBox(height: 0.9.h),

                          /// CATEGORY TEXT
                          Text(
                            category == 'All'
                                ? 'All'
                                : category
                                .split(' ')
                                .first
                                .replaceFirstMapped(
                              RegExp(r'^.'),
                                  (m) =>
                                  m.group(0)!.toUpperCase(),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: selected
                                  ? Colors.black87
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          );
        }),
      ],
    );
  }

  // ------------------ HEADER ------------------
  Widget _buildSectionHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Special For You',
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
          ),
          Row(
            children: [
              Text(
                'See All',
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
              SizedBox(width: 1.w),
              Icon(Icons.arrow_forward_ios, size: 11.sp, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------ PRODUCTS ------------------
  Widget _buildProductsGrid() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Padding(
          padding: EdgeInsets.all(5.h),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      final products = controller.filteredProducts;

      if (products.isEmpty) {
        return Padding(
          padding: EdgeInsets.all(5.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 60.sp, color: Colors.grey.shade300),
              SizedBox(height: 2.h),
              Text(
                "No products found",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 3.w,
          childAspectRatio: 0.68,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final productId = product['id'];

          return GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.PRODUCT_DETAILS, arguments: productId);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= IMAGE + FAVORITE =================
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Image.network(
                                product['image'],
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) {
                                  return Icon(Icons.image_not_supported, size: 40.sp, color: Colors.grey.shade400);
                                },
                              ),
                            ),
                          ),

                          // ❤️ FAVORITE BUTTON
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Obx(() {
                              final isFav = favoriteController.isFavorite(productId);

                              return GestureDetector(
                                onTap: () {
                                  favoriteController.toggleFavorite(product);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(1.8.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, spreadRadius: 1)],
                                  ),
                                  child: Icon(isFav ? Icons.favorite : Icons.favorite_border, size: 16.sp, color: const Color(0xFFFF6B35)),
                                ),
                              );
                            }),
                          ),

                          // 🔥 DISCOUNT BADGE
                          if (product['price'] > 100)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
                                decoration: BoxDecoration(color: const Color(0xFFFF6B35), borderRadius: BorderRadius.circular(8)),
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

                  // ================= DETAILS =================
                  Padding(
                    padding: EdgeInsets.all(2.8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['title'].length > 28 ? '${product['title'].substring(0, 28)}...' : product['title'],
                          style: TextStyle(fontSize: 9.5.sp, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.8.h),

                        // 🎨 COLOR DOTS (UI SAME)
                        Row(
                          children: [
                            _buildColorDot(const Color(0xFFFF6B35)),
                            SizedBox(width: 1.5.w),
                            _buildColorDot(const Color(0xFF4ECDC4)),
                            SizedBox(width: 1.5.w),
                            _buildColorDot(const Color(0xFF95E1D3)),
                            SizedBox(width: 1.5.w),
                            _buildColorDot(const Color(0xFFFFC107)),
                          ],
                        ),
                        SizedBox(height: 1.h),

                        // PRICE + RATING
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
                                  Icon(Icons.star, color: const Color(0xFFFFC107), size: 11.sp),
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
            ),
          );
        },
      );
    });
  }
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

// Pattern Painter for Background
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 40.0 + (i * 20), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
