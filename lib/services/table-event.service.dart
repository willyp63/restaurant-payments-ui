import 'package:rxdart/rxdart.dart';

import 'package:mimos/models/index.dart';

import 'package:mimos/services/user.service.dart';
import 'package:mimos/services/table-item.service.dart';

class TableEventService {

  static Subject<DateTime> _lastSeenDate = new BehaviorSubject<DateTime>.seeded(null);

  static Observable<List<TableEventModel>> getTableEvents(String tableId) {
    return Observable.combineLatest2<List<UserModel>, List<TableItemModel>, List<TableEventModel>>(
      UserService.getTableUsers(tableId),
      TableItemService.getTableItems(tableId),
      (List<UserModel> users, List<TableItemModel> tableItems) {

        List<ItemPayEventModel> itemPayEvents = tableItems
          .where((item) => item.paidForAt != null)
          .map((item) {
            return new ItemPayEventModel(
              date: item.paidForAt,
              tableItem: item,
              user: item.paidForBy,
            );
          }).toList();

        List<UserJoinEventModel> userJoinEvents = users
          .map((user) {
            return new UserJoinEventModel(
              date: user.joinedTableAt,
              user: user,
            );
          }).toList();

        List<TableEventModel> events = [itemPayEvents, userJoinEvents].expand((x) => x).toList();
        events.sort((a, b) => b.date.compareTo(a.date));
        return events;
      },
    );
  }

  static void seeEvents(String tableId) {
    _lastSeenDate.add(DateTime.now());
  }

  static Observable<int> getNumUnseenEvents(String tableId) {
    return Observable.combineLatest2<List<TableEventModel>, DateTime, int>(
      TableEventService.getTableEvents(tableId),
      _lastSeenDate,
      (List<TableEventModel> events, DateTime lastSeenDate) {
        final notMyEvents = events.where((TableEventModel event) => event.user.id != UserService.getActiveUser().id);
        
        if (lastSeenDate == null) { return notMyEvents.length; }
        return notMyEvents.where((TableEventModel event) => DateTime.parse(event.date).compareTo(lastSeenDate) > 0).length;
      }
    );
  }
  
}
