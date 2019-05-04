import 'package:intl/intl.dart';

import './string.utils.dart';
import '../models/table-item.model.dart';

final _currencyFormatter = NumberFormat.currency(symbol: '\$');

String formatTableItem(TableItemModel item) {
  return formatTableItemName(item) + ' (' + formatTableItemPrice(item) + ')';
}

String formatTableItemName(TableItemModel item) {
  return capitalizeEachWordInSentence(item.name);
}

String formatTableItemPrice(TableItemModel item) {
  return _currencyFormatter.format(item.price);
}
