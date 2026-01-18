import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../Fav/favorite_view.dart';
import '../cart/cart_view.dart';
import '../dashboard_screen/dashboard_view.dart';
import '../profile/provile_view.dart';
import 'bottom_nav_controller.dart';

class BottomNavView extends GetView<BottomNavController> {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            /// 🔥 HOME TAB WITH NESTED NAVIGATOR
            Navigator(
              key: Get.nestedKey(1),
              onGenerateRoute: (settings) {
                return GetPageRoute(
                  page: () =>  DashboardView(),
                );
              },
            ),

            /// CART
            const CartView(),

            /// FAVORITE
            const FavoriteView(),

            /// PROFILE
            const ProfileView(),
          ],
        ),

        /// 🔥 BEAUTIFUL BOTTOM NAV
        bottomNavigationBar: _buildBottomBar(),
      );
    });
  }

  Widget _buildBottomBar() {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Fav',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
