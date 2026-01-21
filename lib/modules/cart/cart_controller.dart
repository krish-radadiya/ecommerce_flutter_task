/// cart_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;

  // SharedPreferences key
  static const String _cartKey = 'shopping_cart_items';

  @override
  void onInit() {
    super.onInit();
    loadCartFromStorage();
  }

  /// LOAD CART FROM SHARED PREFERENCES
  Future<void> loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString(_cartKey);

      if (cartData != null && cartData.isNotEmpty) {
        final List<dynamic> decodedData = jsonDecode(cartData);
        cartItems.value = decodedData
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        print("✅ Cart loaded from storage: ${cartItems.length} items");
      } else {
        print("📦 No cart data found in storage");
      }
    } catch (e) {
      print("❌ Error loading cart: $e");
    }
  }

  /// SAVE CART TO SHARED PREFERENCES
  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = jsonEncode(cartItems);
      await prefs.setString(_cartKey, cartData);

      print("💾 Cart saved to storage: ${cartItems.length} items");
    } catch (e) {
      print("❌ Error saving cart: $e");
    }
  }

  /// ADD TO CART
  void addToCart(Map<String, dynamic> product) {
    final index = cartItems.indexWhere((item) => item['id'] == product['id']);

    if (index != -1) {
      // Product already exists, increment quantity
      cartItems[index]['quantity']++;
      cartItems.refresh();
      print("➕ Quantity increased for: ${product['title']}");
    } else {
      // Add new product
      cartItems.add({
        ...product,
        'quantity': 1,
      });
      print("✅ Added to cart: ${product['title']}");
    }

    _saveCartToStorage();
  }

  /// ADD TO CART WITH CUSTOM QUANTITY
  void addToCartWithQuantity(Map<String, dynamic> product, int qty) {
    final index = cartItems.indexWhere((item) => item['id'] == product['id']);

    if (index != -1) {
      // Product already exists, add to existing quantity
      cartItems[index]['quantity'] += qty;
      cartItems.refresh();
      print("➕ Quantity increased by $qty for: ${product['title']}");
    } else {
      // Add new product with specified quantity
      cartItems.add({
        ...product,
        'quantity': qty,
      });
      print("✅ Added to cart: ${product['title']} with quantity $qty");
    }

    _saveCartToStorage();
  }

  /// INCREMENT QUANTITY
  void increment(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems[index]['quantity']++;
      cartItems.refresh();
      _saveCartToStorage();

      print("➕ Quantity increased: ${cartItems[index]['title']}");
    }
  }

  /// DECREMENT QUANTITY
  void decrement(int index) {
    if (index >= 0 && index < cartItems.length) {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
        cartItems.refresh();
        _saveCartToStorage();

        print("➖ Quantity decreased: ${cartItems[index]['title']}");
      } else {
        // Remove item if quantity becomes 0
        removeItem(index);
      }
    }
  }

  /// REMOVE ITEM
  void removeItem(int index) {
    if (index >= 0 && index < cartItems.length) {
      final removedItem = cartItems[index];
      cartItems.removeAt(index);
      cartItems.refresh();
      _saveCartToStorage();

      print("🗑️ Removed from cart: ${removedItem['title']}");
    }
  }

  /// CLEAR CART
  void clearCart() {
    cartItems.clear();
    cartItems.refresh();
    _saveCartToStorage();

    print("🗑️ Cart cleared");
  }

  /// GET TOTAL AMOUNT
  double get totalAmount {
    return cartItems.fold(
      0.0,
          (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  /// GET TOTAL ITEMS COUNT
  int get totalItems {
    return cartItems.fold(
      0,
          (sum, item) => sum + (item['quantity'] as int),
    );
  }

  /// CHECK IF PRODUCT IS IN CART
  bool isInCart(int productId) {
    return cartItems.any((item) => item['id'] == productId);
  }

  /// GET PRODUCT QUANTITY IN CART
  int getProductQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item['id'] == productId);
    if (index != -1) {
      return cartItems[index]['quantity'] as int;
    }
    return 0;
  }
}