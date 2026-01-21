import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../cart/cart_controller.dart';

class ProductDetailsController extends GetxController {
  final int productId = Get.arguments;

  var isLoading = true.obs;
  var product = <String, dynamic>{}.obs;

  /// ✅ FIX: DO NOT CREATE NEW CART CONTROLLER
  final CartController cartController = Get.find<CartController>();

  /// TAB MANAGEMENT
  var selectedTab = 0.obs;
  final List<String> tabs = ['Description', 'Specification', 'Review'];

  /// COLOR MANAGEMENT
  var selectedColor = 0.obs;
  final List<Color> colors = [
    const Color(0xFFFF6B35),
    const Color(0xFF4ECDC4),
    const Color(0xFF45B7D1),
    const Color(0xFFFFC107),
    const Color(0xFF9C27B0),
  ];

  /// QUANTITY
  var quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      isLoading(true);

      final res = await http.get(
        Uri.parse('https://fakestoreapi.com/products/$productId'),
      );

      if (res.statusCode == 200) {
        product.value = jsonDecode(res.body);
      } else {
        Get.snackbar('Error', 'Failed to load product');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading(false);
    }
  }

  void changeTab(int index) => selectedTab.value = index;
  void selectColor(int index) => selectedColor.value = index;

  void increaseQty() => quantity.value++;

  void decreaseQty() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  /// ✅ FIXED ADD TO CART
  void addToCart() {
    if (product.isEmpty) return;

    cartController.addToCartWithQuantity(
      product.value,
      quantity.value,
    );

    Get.snackbar(
      "Added to Cart",
      "${product['title']} (x${quantity.value}) added",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
      margin: EdgeInsets.all(4.w),
      borderRadius: 10,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );

    /// ✅ RESET QTY AFTER ADD
    quantity.value = 1;
  }
}
