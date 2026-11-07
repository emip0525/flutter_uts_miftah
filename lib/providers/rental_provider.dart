import 'package:flutter/material.dart';
import '../models/rental_booking.dart';
import '../repositories/rental_repository.dart';

class RentalProvider extends ChangeNotifier {
  final RentalRepository _repository;

  List<RentalBooking> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _statusFilter = 'Semua';

  RentalProvider({RentalRepository? repository})
      : _repository = repository ?? RentalRepository() {
    fetchBookings();
  }

  List<RentalBooking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get statusFilter => _statusFilter;

  List<RentalBooking> get filteredBookings {
    if (_statusFilter == 'Semua') {
      return _bookings;
    }
    return _bookings.where((b) => b.status == _statusFilter).toList();
  }

  int get totalBookingsCount => _bookings.length;
  int get activeBookingsCount => _bookings.where((b) => b.status == 'Aktif').length;
  int get completedBookingsCount => _bookings.where((b) => b.status == 'Selesai').length;
  double get totalRevenue => _bookings.fold(0.0, (sum, b) => sum + b.totalPrice);

  void setStatusFilter(String filter) {
    _statusFilter = filter;
    notifyListeners();
  }

  Future<void> fetchBookings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookings = await _repository.getBookings();
    } catch (e) {
      _errorMessage = 'Gagal memuat data sewa: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBooking(RentalBooking booking) async {
    _isLoading = true;
    notifyListeners();

    try {
      final created = await _repository.createBooking(booking);
      _bookings.insert(0, created);
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah rental: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateBooking(RentalBooking booking) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _repository.updateBooking(booking);
      final index = _bookings.indexWhere((b) => b.id == updated.id);
      if (index != -1) {
        _bookings[index] = updated;
      }
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui rental: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteBooking(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.deleteBooking(id);
      _bookings.removeWhere((b) => b.id == id);
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menghapus rental: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
