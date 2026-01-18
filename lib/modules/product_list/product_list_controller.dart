import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductListController extends GetxController {
  late final String category;

  var isLoading = true.obs;
  var products = [].obs;

  @override
  void onInit() {
    super.onInit();

    /// ✅ SAFE ARGUMENT READ
    final arg = Get.arguments;
    if (arg == null || arg is! String) {
      category = '';
      debugPrint("❌ ProductListController: category is null");
      return;
    }

    category = arg;
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading(true);

      final res = await http.get(
        Uri.parse(
          'https://fakestoreapi.com/products/category/$category',
        ),
      );

      if (res.statusCode == 200) {
        products.value = jsonDecode(res.body);
      }
    } catch (e) {
      debugPrint("ERROR: $e");
    } finally {
      isLoading(false);
    }
  }
}
