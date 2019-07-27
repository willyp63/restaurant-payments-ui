import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(symbol: '\$');

String formatCurrency(num amount) {
  return currencyFormatter.format(amount);
}
