import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';
import '../models/mountain_weather.dart';
import '../models/outdoor_gear.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil data cuaca gunung secara real-time via Open-Meteo REST API (GET)
  Future<MountainWeather> fetchMountainWeather() async {
    try {
      final response = await _client
          .get(Uri.parse(AppConstants.weatherApiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return MountainWeather.fromOpenMeteoJson(data);
      } else {
        throw Exception('Gagal memuat cuaca: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Fallback default safe weather jika koneksi terputus
      return MountainWeather(
        temperature: 19.5,
        windSpeed: 8.2,
        weatherCode: 1,
        condition: 'Sebagian Berawan (Offline Mode)',
        safetyStatus: 'Aman Mendaki',
        isSafeForHiking: true,
      );
    }
  }

  /// Mengambil katalog peralatan mendaki & outdoor via REST API (GET)
  Future<List<OutdoorGear>> fetchOutdoorGears() async {
    try {
      // Mencoba mengambil data via HTTP GET REST API
      final response = await _client
          .get(Uri.parse(AppConstants.gearCatalogApiUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => OutdoorGear.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        // Jika response non-200, gunakan data lokal aset
        return await _loadLocalGearsAsset();
      }
    } catch (_) {
      // Jika terjadi error jaringan / offline, fallback ke aset json lokal
      return await _loadLocalGearsAsset();
    }
  }

  Future<List<OutdoorGear>> _loadLocalGearsAsset() async {
    final jsonString = await rootBundle.loadString('assets/data/gear_catalog.json');
    final List<dynamic> data = jsonDecode(jsonString);
    return data.map((json) => OutdoorGear.fromJson(json as Map<String, dynamic>)).toList();
  }
}
