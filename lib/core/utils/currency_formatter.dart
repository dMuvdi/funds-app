import 'package:intl/intl.dart';

/// Format Colombian Pesos in the format: $ 500.000 COP
String formatCop(double value) {
  final formatted = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '',
    decimalDigits: 0,
  ).format(value).trim();
  return '\$ $formatted COP';
}
