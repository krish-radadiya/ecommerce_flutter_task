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
      return WillPopScope(
        onWillPop: () async {
          // 🔥 Handle Android back properly for nested nav
          final canPopNested =
              await Get.nestedKey(1)?.currentState?.maybePop() ?? false;

          if (canPopNested) return false;

          // If on Home tab root → allow app exit
          if (controller.currentIndex.value == 0) {
            return true;
          }

          // Otherwise switch to Home tab
          controller.changeIndex(0);
          return false;
        },
        child: Scaffold(
          extendBody: true, // floating nav effect
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: [
              /// 🏠 HOME (Nested Navigator – ONLY ONCE)
              Navigator(
                key: Get.nestedKey(1),
                onGenerateRoute: (_) => GetPageRoute(
                  page: () =>  DashboardView(), // ✅ const added
                ),
              ),

              /// 🛒 CART
              const CartView(),

              /// ❤️ FAVORITE
              const FavoriteView(),

              /// 👤 PROFILE
              const ProfileView(),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context),
        ),
      );
    });
  }

  Widget _buildBottomBar(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          12,
          0,
          12,
          bottomInset > 0 ? 8 : 12,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: controller.currentIndex.value,
            onTap: (index) {
              if (index == controller.currentIndex.value) {
                // 🔥 If Home reselected → pop to root
                if (index == 0) {
                  Get.until((route) => route.isFirst, id: 1);
                }
                return;
              }
              controller.changeIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: false,
            selectedFontSize: 12,
            unselectedFontSize: 12,
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
        ),
      ),
    );
  }
}
