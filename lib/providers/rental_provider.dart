import 'package:flutter/material.dart';
import '../models/rental_booking.dart';

class RentalProvider extends ChangeNotifier {
  List<RentalBooking> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _statusFilter = 'Semua';

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

  void setBookings(List<RentalBooking> list) {
    _bookings = list;
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

  void addLocalBooking(RentalBooking booking) {
    _bookings.insert(0, booking);
    notifyListeners();
  }

  void updateLocalBooking(RentalBooking booking) {
    final index = _bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      _bookings[index] = booking;
      notifyListeners();
    }
  }

  void removeLocalBooking(String id) {
    _bookings.removeWhere((b) => b.id == id);
    notifyListeners();
  }
}
