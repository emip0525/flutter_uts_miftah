import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatDate(String isoOrFormatted) {
    try {
      final dt = DateTime.parse(isoOrFormatted);
      return DateFormat('dd MMM yyyy', 'id_ID').format(dt);
    } catch (_) {
      return isoOrFormatted;
    }
  }

  static String formatShortDate(DateTime dt) {
    return DateFormat('yyyy-MM-dd').format(dt);
  }
}
