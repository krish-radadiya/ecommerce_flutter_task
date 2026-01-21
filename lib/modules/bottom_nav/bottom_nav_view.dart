import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../Fav/favorite_view.dart';
import '../cart/cart_controller.dart';
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
          // Handle Android back for nested navigation
          final canPopNested =
              await Get.nestedKey(1)?.currentState?.maybePop() ?? false;

          if (canPopNested) return false;

          // If not on Home tab → go to Home
          if (controller.currentIndex.value != 0) {
            controller.changeIndex(0);
            return false;
          }

          // On Home root → allow exit
          return true;
        },
        child: Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: [
              /// 🏠 HOME (Nested Navigator – ONLY ONCE)
              Navigator(
                key: Get.nestedKey(1),
                onGenerateRoute: (_) => GetPageRoute(
                  page: () =>  DashboardView(),
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

  /// 🔥 Custom Floating Bottom Nav Bar
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
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: false,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            onTap: (index) {
              // If same tab tapped
              if (index == controller.currentIndex.value) {
                // If Home tapped again → pop to Dashboard
                if (index == 0) {
                  Get.until((route) => route.isFirst, id: 1);
                }
                return;
              }
              controller.changeIndex(index);
            },
            items: [
              /// HOME
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),

              /// CART (WITH BADGE)
              BottomNavigationBarItem(
                label: 'Cart',
                icon: Obx(() {
                  final cartController = Get.find<CartController>();
                  final count = cartController.cartItems.length;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart_outlined),
                      if (count > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              count.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                activeIcon: Obx(() {
                  final cartController = Get.find<CartController>();
                  final count = cartController.cartItems.length;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart),
                      if (count > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              count.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),

              /// FAVORITE
              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: 'Fav',
              ),

              /// PROFILE
              const BottomNavigationBarItem(
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
