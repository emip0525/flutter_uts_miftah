import 'package:flutter/material.dart';
import '../models/outdoor_gear.dart';
import '../models/mountain_weather.dart';
import '../repositories/gear_repository.dart';

class GearProvider extends ChangeNotifier {
  final GearRepository _repository;

  List<OutdoorGear> _gears = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  String _sortBy = 'popular'; // 'popular', 'price_asc', 'price_desc', 'rating'

  MountainWeather? _weather;
  bool _isLoadingWeather = false;
  String? _weatherError;

  GearProvider({GearRepository? repository})
      : _repository = repository ?? GearRepository() {
    loadGears();
    loadWeather();
  }

  List<OutdoorGear> get gears => _gears;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  MountainWeather? get weather => _weather;
  bool get isLoadingWeather => _isLoadingWeather;
  String? get weatherError => _weatherError;

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

  Future<void> loadGears() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.getGears();
      _gears = data;
    } catch (e) {
      _errorMessage = 'Gagal memuat katalog: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadWeather() async {
    _isLoadingWeather = true;
    _weatherError = null;
    notifyListeners();

    try {
      _weather = await _repository.getWeather();
    } catch (e) {
      _weatherError = 'Gagal memuat status cuaca: $e';
    } finally {
      _isLoadingWeather = false;
      notifyListeners();
    }
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
}
