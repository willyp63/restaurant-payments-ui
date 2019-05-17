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
  UserModel user;

  TableEventModel({this.type, this.date, this.user});
}

class ItemPayEventModel extends TableEventModel {
  TableItemModel tableItem;
  
  ItemPayEventModel({String date, this.tableItem, UserModel user})
    : super(type: TableEventType.ItemPay, date: date, user: user);
}

class UserJoinEventModel extends TableEventModel {
  UserJoinEventModel({String date, UserModel user})
    : super(type: TableEventType.UserJoin, date: date, user: user);
}

class UserLeaveEventModel extends TableEventModel {
  UserLeaveEventModel({String date, UserModel user})
    : super(type: TableEventType.UserLeave, date: date, user: user);
}
