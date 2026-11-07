import 'package:flutter/material.dart';

class AppConstants {
  // Application Info
  static const String appName = 'MuncakGear';
  static const String appTagline = 'Rental Fasilitas Mendaki & Alat Outdoor';
  static const String appVersion = '1.0.0';

  // Student Info for UTS Pemrograman Mobile
  static const String studentName = 'Miftah Fadilatus Sakhila';
  static const String studentNim = '2415051011';
  static const String studentClass = 'PTI 5A';
  static const String courseName = 'Pemrograman Mobile';
  static const String lecturerName = 'Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom';
  static const String teachingAssistant = 'Made Yuda Sadewa, S.Pd.';

  // Theme Colors (Earthy / Mountain Outdoor Palette)
  static const Color primaryGreen = Color(0xFF1B4332); // Deep Forest Green
  static const Color secondaryGreen = Color(0xFF2D6A4F);
  static const Color accentOrange = Color(0xFFE76F51); // Mountain Sunset Orange
  static const Color surfaceWarm = Color(0xFFF8F9FA);
  static const Color cardDark = Color(0xFF222B27);

  // Supabase Configuration
  // Anon key is safe for client-side usage (public key)
  static const String supabaseUrl = 'https://znhrqszqchmwbqwbzrqp.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpuaHJxc3pxY2htd2Jxd2J6cnFwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk4Mjk1NTgsImV4cCI6MjAyNTQwNTU1OH0.sample_anon_key';
  static const String bookingsTable = 'rental_bookings';
  static const String favoritesTable = 'favorite_gears';

  // REST API Endpoints
  // Weather REST API for Bali Mountain / Outdoor Summit forecast
  static const String weatherApiUrl =
      'https://api.open-meteo.com/v1/forecast?latitude=-8.411&longitude=115.312&current_weather=true';
  // Gear Catalog REST API (with dynamic fallback)
  static const String gearCatalogApiUrl =
      'https://raw.githubusercontent.com/emip0525/flutter_uts_miftah/main/assets/data/gear_catalog.json';
}
