import 'package:intl/intl.dart';

final dateFormatter = DateFormat.yMMMMd("en_US");
final dateTimeFormatter = dateFormatter.add_jm();

String formatDate(String timestamp) {
  return dateFormatter.format(DateTime.parse(timestamp).toLocal());
}

String formatDateTime(String timestamp) {
  return dateTimeFormatter.format(DateTime.parse(timestamp).toLocal());
}
