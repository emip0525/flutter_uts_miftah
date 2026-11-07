import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_uts_miftah/models/outdoor_gear.dart';
import 'package:flutter_uts_miftah/models/rental_booking.dart';
import 'package:flutter_uts_miftah/models/mountain_weather.dart';
import 'package:flutter_uts_miftah/utils/formatters.dart';

void main() {
  group('UTS Dart Models & Formatter Unit Tests', () {
    test('OutdoorGear JSON parsing and copyWith test', () {
      final json = {
        'id': 'test_gear_1',
        'name': 'Tenda Dome 4P',
        'brand': 'Eiger',
        'category': 'Tenda & Shelter',
        'price_per_day': 50000,
        'security_deposit': 100000,
        'rating': 4.8,
        'reviews_count': 25,
        'image_url': 'https://example.com/tenda.jpg',
        'description': 'Tenda gunung anti badai',
        'specifications': {'Kapasitas': '4 Orang'},
        'features': ['Double Layer', 'Frame Alloy'],
        'in_stock': true,
        'stock_count': 3,
      };

      final gear = OutdoorGear.fromJson(json);
      expect(gear.id, 'test_gear_1');
      expect(gear.name, 'Tenda Dome 4P');
      expect(gear.pricePerDay, 50000.0);
      expect(gear.specifications['Kapasitas'], '4 Orang');
      expect(gear.features.length, 2);

      final updated = gear.copyWith(pricePerDay: 55000);
      expect(updated.pricePerDay, 55000.0);
      expect(updated.name, 'Tenda Dome 4P');
    });

    test('RentalBooking JSON serialization test (Database CRUD model)', () {
      final booking = RentalBooking(
        id: 'rent_101',
        customerName: 'Miftah Fadilatus Sakhila',
        customerPhone: '081234567890',
        gearId: 'test_gear_1',
        gearName: 'Tenda Dome 4P',
        rentalDays: 3,
        startDate: '2026-11-10',
        returnDate: '2026-11-13',
        totalPrice: 150000,
        note: 'Pendakian Batur',
        status: 'Aktif',
      );

      final map = booking.toJson();
      expect(map['customer_name'], 'Miftah Fadilatus Sakhila');
      expect(map['rental_days'], 3);
      expect(map['total_price'], 150000.0);
      expect(map['status'], 'Aktif');

      final deserialized = RentalBooking.fromJson(map);
      expect(deserialized.id, 'rent_101');
      expect(deserialized.customerName, 'Miftah Fadilatus Sakhila');
    });

    test('MountainWeather Open-Meteo REST API JSON parsing test', () {
      final apiJson = {
        'current_weather': {
          'temperature': 21.5,
          'windspeed': 7.2,
          'weathercode': 0,
        }
      };

      final weather = MountainWeather.fromOpenMeteoJson(apiJson);
      expect(weather.temperature, 21.5);
      expect(weather.windSpeed, 7.2);
      expect(weather.isSafeForHiking, true);
      expect(weather.safetyStatus, 'Aman Mendaki');
    });

    test('Formatters test (Indonesian Rupiah and Date)', () {
      final formattedPrice = Formatters.formatCurrency(75000);
      expect(formattedPrice.contains('75.000'), isTrue);

      final date = Formatters.formatShortDate(DateTime(2026, 11, 7));
      expect(date, '2026-11-07');
    });
  });
}
