import '../models/table-event.model.dart';
import './name.utils.dart';
import './table-item.utils.dart';

String formatTableEvent(TableEventModel event) {
  switch (event.type) {
    case TableEventType.ItemPay:
      return _formatItemPayEvent(event);
    case TableEventType.UserJoin:
      return _formatUserJoinEvent(event);
    case TableEventType.UserLeave:
      return _formatUserLeaveEvent(event);
  }
  return 'Unknown Event.';
}

String _formatItemPayEvent(ItemPayEventModel event) {
  return formatName(event.user) + ' paid for ' + formatTableItem(event.tableItem) + '.';
}

String _formatUserJoinEvent(UserJoinEventModel event) {
  return formatName(event.user) + ' joined the table.';
}

String _formatUserLeaveEvent(UserLeaveEventModel event) {
  return formatName(event.user) + ' left the table.';
}
