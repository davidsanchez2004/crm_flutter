import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);
  }

  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'es_ES',
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  static String formatNumber(double value) {
    return value.toStringAsFixed(2);
  }
}
