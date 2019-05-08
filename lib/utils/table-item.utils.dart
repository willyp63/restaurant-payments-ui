import 'package:intl/intl.dart';

import './string.utils.dart';
import '../models/table-item.model.dart';

final currencyFormatter = NumberFormat.currency(symbol: '\$');
final percentFormatter = NumberFormat.percentPattern();
final dateFormatter = DateFormat.yMd().add_jm();

String formatTableItem(TableItemModel item) {
  return formatTableItemName(item) + ' (' + formatTableItemPrice(item) + ')';
}

String formatTableItemName(TableItemModel item) {
  return capitalizeEachWordInSentence(item.name);
}

String formatTableItemPrice(TableItemModel item) {
  return currencyFormatter.format(item.price);
}
