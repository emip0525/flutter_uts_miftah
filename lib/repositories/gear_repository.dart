import '../models/mountain_weather.dart';
import '../models/outdoor_gear.dart';
import '../services/api_service.dart';

class GearRepository {
  final ApiService _apiService;

  GearRepository({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  Future<List<OutdoorGear>> getGears() async {
    return await _apiService.fetchOutdoorGears();
  }

  Future<MountainWeather> getWeather() async {
    return await _apiService.fetchMountainWeather();
  }
}
