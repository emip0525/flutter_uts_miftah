import '../models/rental_booking.dart';
import '../services/database_service.dart';

class RentalRepository {
  final DatabaseService _databaseService;

  RentalRepository({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  Future<List<RentalBooking>> getBookings() async {
    return await _databaseService.getBookings();
  }

  Future<RentalBooking> createBooking(RentalBooking booking) async {
    return await _databaseService.createBooking(booking);
  }

  Future<RentalBooking> updateBooking(RentalBooking booking) async {
    return await _databaseService.updateBooking(booking);
  }

  Future<void> deleteBooking(String id) async {
    return await _databaseService.deleteBooking(id);
  }
}
