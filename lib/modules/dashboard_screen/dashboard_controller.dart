// dashboard_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DashboardController extends GetxController {
  var categories = <String>[].obs;
  var allProducts = <dynamic>[].obs;
  var filteredProducts = <dynamic>[].obs;
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchAllProducts();
  }

  /// FETCH CATEGORIES
  Future<void> fetchCategories() async {
    try {
      final res = await http.get(
        Uri.parse('https://fakestoreapi.com/products/categories'),
      );

      if (res.statusCode == 200) {
        categories.value = List<String>.from(jsonDecode(res.body));
        print("✅ Categories loaded: ${categories.length}");
      }
    } catch (e) {
      print("❌ ERROR fetching categories: $e");
    }
  }

  /// FETCH ALL PRODUCTS
  Future<void> fetchAllProducts() async {
    try {
      isLoading(true);
      final res = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );

      if (res.statusCode == 200) {
        allProducts.value = jsonDecode(res.body);
        filteredProducts.value = List.from(allProducts);
        print("✅ Products loaded: ${allProducts.length}");
      }
    } catch (e) {
      print("❌ ERROR fetching products: $e");
    } finally {
      isLoading(false);
    }
  }

  /// SELECT CATEGORY - FIXED VERSION
  void selectCategory(String category) {
    print("📂 Category selected: $category");
    selectedCategory.value = category;
    filterProducts();
  }

  /// SEARCH PRODUCTS
  void searchProducts(String query) {
    searchQuery.value = query;
    filterProducts();
  }

  /// FILTER PRODUCTS - IMPROVED VERSION
  void filterProducts() {
    var filtered = List.from(allProducts);

    // Filter by category
    if (selectedCategory.value != 'All') {
      filtered = filtered.where((product) {
        final productCategory = product['category'].toString().toLowerCase();
        final selected = selectedCategory.value.toLowerCase();
        return productCategory == selected;
      }).toList();

      print("🔍 Filtered by category '${selectedCategory.value}': ${filtered.length} products");
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((product) {
        final title = product['title'].toString().toLowerCase();
        final query = searchQuery.value.toLowerCase();
        return title.contains(query);
      }).toList();

      print("🔍 Filtered by search '${searchQuery.value}': ${filtered.length} products");
    }

    filteredProducts.value = filtered;
    filteredProducts.refresh(); // Force UI update

    print("✅ Total filtered products: ${filteredProducts.length}");
  }

  /// REFRESH DATA
  Future<void> refreshData() async {
    await fetchCategories();
    await fetchAllProducts();
  }
}