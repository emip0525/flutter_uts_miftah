import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_constants.dart';
import '../models/rental_booking.dart';

class DatabaseService {
  static const String _localBookingsKey = 'local_rental_bookings_list';
  bool _isSupabaseInitialized = false;

  DatabaseService() {
    _initSupabase();
  }

  Future<void> _initSupabase() async {
    try {
      if (Supabase.instance.client.auth.currentSession == null && !_isSupabaseInitialized) {
        await Supabase.initialize(
          url: AppConstants.supabaseUrl,
          anonKey: AppConstants.supabaseAnonKey, // ignore: deprecated_member_use
        );
        _isSupabaseInitialized = true;
      }
    } catch (e) {
      debugPrint('Supabase init notice (local sync fallback active): $e');
    }
  }

  /// READ / GET: Mengambil seluruh data rental bookings
  Future<List<RentalBooking>> getBookings() async {
    List<RentalBooking> results = [];

    // 1. Coba ambil dari Supabase PostgreSQL
    try {
      if (_isSupabaseInitialized) {
        final response = await Supabase.instance.client
            .from(AppConstants.bookingsTable)
            .select()
            .order('created_at', ascending: false);

        if (response.isNotEmpty) {
          results = (response as List)
              .map((item) => RentalBooking.fromJson(item as Map<String, dynamic>))
              .toList();
          // Simpan sinkronisasi ke storage lokal
          await _saveToLocal(results);
          return results;
        }
      }
    } catch (e) {
      debugPrint('Supabase get error, falling back to local DB: $e');
    }

    // 2. Fallback ke persistent local storage jika offline / tabel supabase belum dibuat
    results = await _loadFromLocal();
    if (results.isEmpty) {
      results = _getInitialSampleBookings();
      await _saveToLocal(results);
    }
    return results;
  }

  /// CREATE / INSERT: Menambahkan data rental baru ke database
  Future<RentalBooking> createBooking(RentalBooking booking) async {
    try {
      if (_isSupabaseInitialized) {
        final inserted = await Supabase.instance.client
            .from(AppConstants.bookingsTable)
            .insert(booking.toJson())
            .select()
            .single();

        final created = RentalBooking.fromJson(inserted);
        await _insertToLocal(created);
        return created;
      }
    } catch (e) {
      debugPrint('Supabase insert error, persisting locally: $e');
    }

    // Simpan ke local persistent storage
    await _insertToLocal(booking);
    return booking;
  }

  /// UPDATE: Memperbarui data rental di database
  Future<RentalBooking> updateBooking(RentalBooking booking) async {
    try {
      if (_isSupabaseInitialized) {
        final updated = await Supabase.instance.client
            .from(AppConstants.bookingsTable)
            .update(booking.toJson())
            .eq('id', booking.id)
            .select()
            .single();

        final updatedBooking = RentalBooking.fromJson(updated);
        await _updateInLocal(updatedBooking);
        return updatedBooking;
      }
    } catch (e) {
      debugPrint('Supabase update error, updating locally: $e');
    }

    await _updateInLocal(booking);
    return booking;
  }

  /// DELETE: Menghapus data rental dari database
  Future<void> deleteBooking(String id) async {
    try {
      if (_isSupabaseInitialized) {
        await Supabase.instance.client
            .from(AppConstants.bookingsTable)
            .delete()
            .eq('id', id);
      }
    } catch (e) {
      debugPrint('Supabase delete error, deleting locally: $e');
    }

    await _deleteFromLocal(id);
  }

  // --- Local Database Helper Methods ---

  Future<List<RentalBooking>> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString(_localBookingsKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> list = jsonDecode(jsonStr);
        return list.map((item) => RentalBooking.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('Error loading local bookings: $e');
    }
    return [];
  }

  Future<void> _saveToLocal(List<RentalBooking> list) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(list.map((b) => b.toJson()).toList());
      await prefs.setString(_localBookingsKey, jsonStr);
    } catch (e) {
      debugPrint('Error saving local bookings: $e');
    }
  }

  Future<void> _insertToLocal(RentalBooking booking) async {
    final list = await _loadFromLocal();
    list.insert(0, booking);
    await _saveToLocal(list);
  }

  Future<void> _updateInLocal(RentalBooking booking) async {
    final list = await _loadFromLocal();
    final index = list.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      list[index] = booking;
      await _saveToLocal(list);
    }
  }

  Future<void> _deleteFromLocal(String id) async {
    final list = await _loadFromLocal();
    list.removeWhere((b) => b.id == id);
    await _saveToLocal(list);
  }

  List<RentalBooking> _getInitialSampleBookings() {
    return [
      RentalBooking(
        id: 'rent_001',
        studentId: AppConstants.studentNim,
        customerName: 'Ahmad Fauzan',
        customerPhone: '081234567890',
        gearId: 'gear_01',
        gearName: 'Tenda Dome Eiger Storm Shelter 4P',
        rentalDays: 3,
        startDate: '2026-11-10',
        returnDate: '2026-11-13',
        totalPrice: 180000,
        note: 'Pendakian Puncak Rinjani bersama tim 4 orang',
        status: 'Aktif',
      ),
      RentalBooking(
        id: 'rent_002',
        studentId: AppConstants.studentNim,
        customerName: 'Siti Rahma',
        customerPhone: '085712345678',
        gearId: 'gear_03',
        gearName: 'Carrier Deuter Aircontact Pro 60+10L',
        rentalDays: 2,
        startDate: '2026-11-12',
        returnDate: '2026-11-14',
        totalPrice: 100000,
        note: 'Camp ground Gunung Batur Bali',
        status: 'Aktif',
      ),
      RentalBooking(
        id: 'rent_003',
        studentId: AppConstants.studentNim,
        customerName: 'Bayu Putra',
        customerPhone: '087812345679',
        gearId: 'gear_06',
        gearName: 'Kompor Ultralight Windproof & Cooking Set DS-308',
        rentalDays: 4,
        startDate: '2026-11-05',
        returnDate: '2026-11-09',
        totalPrice: 100000,
        note: 'Sewa selesai dan dikembalikan dalam keadaan bersih',
        status: 'Selesai',
      ),
    ];
  }
}
