import 'package:mimos/models/index.dart';

import './user.utils.dart';
import './table-item.utils.dart';

String formatTableEvent(TableEventModel event, UserModel activeUser) {
  switch (event.type) {
    case TableEventType.ItemPay:
      return _formatItemPayEvent(event, activeUser);
    case TableEventType.UserJoin:
      return _formatUserJoinEvent(event, activeUser);
    case TableEventType.UserLeave:
      return _formatUserLeaveEvent(event, activeUser);
  }
  return 'Unknown Event.';
}

String _formatItemPayEvent(ItemPayEventModel event, UserModel activeUser) {
  return formatUser(event.user, activeUser) + ' paid for ' + formatTableItem(event.tableItem) + '.';
}

String _formatUserJoinEvent(UserJoinEventModel event, UserModel activeUser) {
  return formatUser(event.user, activeUser) + ' joined the table.';
}

String _formatUserLeaveEvent(UserLeaveEventModel event, UserModel activeUser) {
  return formatUser(event.user, activeUser) + ' left the table.';
}
