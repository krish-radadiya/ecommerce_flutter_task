import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/constants/app_keys.dart';

class FavoriteController extends GetxController {
  var favorites = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  /// LOAD FROM SHARED PREF
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(AppKeys.favorites);

    if (data != null) {
      favorites.value =
      List<Map<String, dynamic>>.from(jsonDecode(data));
    }
  }

  /// SAVE TO SHARED PREF
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      AppKeys.favorites,
      jsonEncode(favorites),
    );
  }

  /// TOGGLE FAVORITE
  void toggleFavorite(Map<String, dynamic> product) {
    final index =
    favorites.indexWhere((item) => item['id'] == product['id']);

    if (index == -1) {
      favorites.add(product);
    } else {
      favorites.removeAt(index);
    }

    favorites.refresh();
    _saveFavorites();
  }

  /// CHECK IS FAVORITE
  bool isFavorite(int productId) {
    return favorites.any((item) => item['id'] == productId);
  }

  /// REMOVE
  void removeFavorite(int productId) {
    favorites.removeWhere((item) => item['id'] == productId);
    favorites.refresh();
    _saveFavorites();
  }
}
