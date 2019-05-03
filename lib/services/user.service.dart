import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../models/user.model.dart';
import '../models/table-join.model.dart';
import '../constants/api-routes.constants.dart';
import '../utils/route.utils.dart';
import '../services/websocket.service.dart';
import '../services/table-item.service.dart';
import '../constants/socket-events.constants.dart';

class UserService {

  static Future<UserModel> addUser(UserModel user) async {
    final response = await http.post(formatRoute([ApiRoutes.baseUrl, ApiRoutes.users]), body: user);
    if (response.statusCode != 200) { throw Exception('Failed to add User'); }

    return UserModel.fromJson(json.decode(response.body));
  }

  static void addUserToTable(TableJoinModel tableJoin) {
    WebSocketService.emit(SocketEvents.joinTable, tableJoin);
  }

  static void removeUserFromTable(TableJoinModel tableJoin) {
    WebSocketService.emit(SocketEvents.leaveTable, tableJoin);
  }

  static Observable<void> onUserJoinedTable() {
    return WebSocketService.listen(SocketEvents.userJoinedTable);
  }

  static Observable<void> onUserLeftTable() {
    return WebSocketService.listen(SocketEvents.userLeftTable);
  }

  static Future<List<UserModel>> _getTableUsers(String tableId) async {
    final response = await http.get(formatRoute([ApiRoutes.baseUrl, ApiRoutes.tables, tableId, ApiRoutes.users]));
    if (response.statusCode != 200) { throw Exception('Failed to load Users'); }

    return (json.decode(response.body) as List).map((userData) => UserModel.fromJson(userData)).toList();
  }

  static Observable<List<UserModel>> getTableUsers(String tableId) {
    return new Observable.merge([
      new Observable.just(true),
      UserService.onUserJoinedTable(),
      UserService.onUserLeftTable(),
      TableItemService.onTableItemPaidFor(),
      TableItemService.onTableItemRemoved(),
    ]).concatMap((_) {
      return new Stream.fromFuture(UserService._getTableUsers(tableId));
    });
  }

}
