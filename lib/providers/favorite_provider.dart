import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/outdoor_gear.dart';

class FavoriteProvider extends ChangeNotifier {
  static const String _prefKey = 'user_favorite_gear_ids';
  final Set<String> _favoriteIds = {};
  bool _isLoading = false;

  Set<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;

  FavoriteProvider() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedList = prefs.getStringList(_prefKey) ?? [];
      _favoriteIds.clear();
      _favoriteIds.addAll(savedList);
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String gearId) {
    return _favoriteIds.contains(gearId);
  }

  Future<void> toggleFavorite(String gearId) async {
    if (_favoriteIds.contains(gearId)) {
      _favoriteIds.remove(gearId);
    } else {
      _favoriteIds.add(gearId);
    }
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefKey, _favoriteIds.toList());
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  List<OutdoorGear> filterFavoriteGears(List<OutdoorGear> allGears) {
    return allGears.where((g) => _favoriteIds.contains(g.id)).toList();
  }
}
