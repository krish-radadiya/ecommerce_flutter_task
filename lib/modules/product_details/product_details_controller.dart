// product_details_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../../app/routes/app_routes.dart';
import '../cart/cart_controller.dart';

class ProductDetailsController extends GetxController {
  final int productId = Get.arguments;

  var isLoading = true.obs;
  var product = <String, dynamic>{}.obs;

  final CartController cartController = Get.put(CartController());

  @override
  void onInit() {
    super.onInit();
    fetchProductDetails();
  }

  /// FETCH PRODUCT DETAILS
  Future<void> fetchProductDetails() async {
    try {
      isLoading(true);
      print("📦 Fetching product ID: $productId");

      final res = await http.get(
        Uri.parse('https://fakestoreapi.com/products/$productId'),
      );

      print("📡 Status: ${res.statusCode}");

      if (res.statusCode == 200) {
        product.value = jsonDecode(res.body);
        print("✅ Product loaded: ${product['title']}");
      } else {
        print("❌ Failed to load product");
        Get.snackbar(
          'Error',
          'Failed to load product details',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("❌ ERROR: $e");
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  /// ADD TO CART
  void addToCart() {
    if (product.isEmpty) {
      Get.snackbar(
        'Error',
        'Product not loaded',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    cartController.addToCart(product.value);

    Get.snackbar(
      "Added to Cart",
      "${product['title']} added successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
      margin: EdgeInsets.all(4.w),
      borderRadius: 10,
      icon: Icon(Icons.check_circle, color: Colors.white),
    );

    // Navigate to cart after delay
    Future.delayed(const Duration(milliseconds: 1600), () {
      Get.toNamed(AppRoutes.CART);
    });
  }

  /// REFRESH PRODUCT
  Future<void> refreshProduct() async {
    await fetchProductDetails();
  }
}