import 'package:intl/intl.dart';

import 'package:mimos/models/index.dart';

import './currency.utils.dart';
import './string.utils.dart';

final percentFormatter = NumberFormat.percentPattern();

String formatTableItem(TableItemModel item) {
  return formatTableItemName(item) + ' (' + formatCurrency(item.price) + ')';
}

String formatTableItemName(TableItemModel item) {
  return capitalizeEachWordInSentence(item.name);
}
