import 'package:intl/intl.dart';

import 'package:mimos/models/index.dart';

import './string.utils.dart';

final currencyFormatter = NumberFormat.currency(symbol: '\$');
final percentFormatter = NumberFormat.percentPattern();

String formatTableItem(TableItemModel item) {
  return formatTableItemName(item) + ' (' + formatTableItemPrice(item) + ')';
}

String formatTableItemName(TableItemModel item) {
  return capitalizeEachWordInSentence(item.name);
}

String formatTableItemPrice(TableItemModel item) {
  return currencyFormatter.format(item.price);
}
