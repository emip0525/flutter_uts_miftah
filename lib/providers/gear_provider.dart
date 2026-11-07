import 'package:flutter/material.dart';
import '../models/outdoor_gear.dart';
import '../models/mountain_weather.dart';

class GearProvider extends ChangeNotifier {
  List<OutdoorGear> _gears = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  String _sortBy = 'popular'; // 'popular', 'price_asc', 'price_desc', 'rating'

  MountainWeather? _weather;
  bool _isLoadingWeather = false;

  List<OutdoorGear> get gears => _gears;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  MountainWeather? get weather => _weather;
  bool get isLoadingWeather => _isLoadingWeather;

  List<String> get categories => [
        'Semua',
        'Tenda & Shelter',
        'Carrier & Tas',
        'Sleeping Bag & Matras',
        'Memasak & Dapur',
        'Penerangan & Elektronik',
        'Sepatu & Sandal',
        'Aksesoris Mendaki',
      ];

  List<OutdoorGear> get filteredGears {
    var result = List<OutdoorGear>.from(_gears);

    // Filter by Category
    if (_selectedCategory != 'Semua') {
      result = result.where((gear) => gear.category == _selectedCategory).toList();
    }

    // Filter by Search Query
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      result = result.where((gear) {
        return gear.name.toLowerCase().contains(query) ||
            gear.brand.toLowerCase().contains(query) ||
            gear.description.toLowerCase().contains(query);
      }).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'price_asc':
        result.sort((a, b) => a.pricePerDay.compareTo(b.pricePerDay));
        break;
      case 'price_desc':
        result.sort((a, b) => b.pricePerDay.compareTo(a.pricePerDay));
        break;
      case 'rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'popular':
      default:
        result.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
        break;
    }

    return result;
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void setGears(List<OutdoorGear> items) {
    _gears = items;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  void setWeather(MountainWeather? weatherData) {
    _weather = weatherData;
    _isLoadingWeather = false;
    notifyListeners();
  }

  void setLoadingWeather(bool loading) {
    _isLoadingWeather = loading;
    notifyListeners();
  }
}
