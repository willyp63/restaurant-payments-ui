import './table-item.model.dart';
import './user.model.dart';

enum TableEventType {
  ItemPay,
  UserJoin,
  UserLeave,
}

abstract class TableEventModel {
  TableEventType type;
  String date;

  TableEventModel({this.type, this.date});
}

class ItemPayEventModel extends TableEventModel {
  TableItemModel tableItem;
  UserModel user;

  ItemPayEventModel({String date, this.tableItem, this.user})
    : super(type: TableEventType.ItemPay, date: date);
}

class UserJoinEventModel extends TableEventModel {
  UserModel user;

  UserJoinEventModel({String date, this.user})
    : super(type: TableEventType.UserJoin, date: date);
}

class UserLeaveEventModel extends TableEventModel {
  UserModel user;

  UserLeaveEventModel({String date, this.user})
    : super(type: TableEventType.UserLeave, date: date);
}
