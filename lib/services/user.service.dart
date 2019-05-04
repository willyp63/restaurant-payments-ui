import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.model.dart';
import '../models/table.model.dart';
import '../models/table-join.model.dart';
import '../constants/api-routes.constants.dart';
import '../utils/route.utils.dart';
import '../services/websocket.service.dart';
import '../services/table-item.service.dart';
import '../constants/socket-events.constants.dart';
import '../constants/local-storage.constants.dart';

class UserService {
  static UserModel _activeUser;
  static UserModel getActiveUser() { return _activeUser; }

  static Future<bool> loadStoredUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(LocalStorage.userId);

    if (userId == null) { return false; }
    
    return _getUserById(userId).then((user) {
      _activeUser = user;
      return true;
    });
  }

  static Future signUpUser(UserModel user, String password) async {
    final userData = user.toJson();
    userData['password'] = password;

    final response = await http.post(formatRoute([ApiRoutes.baseUrl, ApiRoutes.users]), body: userData);
    if (response.statusCode != 201) { throw Exception('Failed to add User'); }

    UserModel insertedUser = UserModel.fromJson(json.decode(response.body));
    _activeUser = insertedUser;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LocalStorage.userId, insertedUser.id);
  }

  static Future signOutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(LocalStorage.userId);
  }

  static void addUserToTable(String tableId) {
    if (_activeUser == null) { throw Exception('No active User'); }

    final tableJoin = new TableJoinModel(tableId: tableId, userId: _activeUser.id);
    WebSocketService.emit(SocketEvents.joinTable, tableJoin);
  }

  static void removeUserFromTable(String tableId) {
    if (_activeUser == null) { throw Exception('No active User'); }

    final tableLeave = new TableJoinModel(tableId: tableId, userId: _activeUser.id);
    WebSocketService.emit(SocketEvents.leaveTable, tableLeave);
  }

  static Future<List<TableModel>> getPastTables() async {
    if (_activeUser == null) { throw Exception('No active User'); }
    
    final response = await http.get(formatRoute([ApiRoutes.baseUrl, ApiRoutes.users, _activeUser.id, ApiRoutes.tables]));
    if (response.statusCode != 200) { throw Exception('Failed to get User\'s Tables'); }

    return (json.decode(response.body) as List).map((tableData) => TableModel.fromJson(tableData)).toList();
  }

  static Observable<void> onUserJoinedTable() {
    return WebSocketService.listen(SocketEvents.userJoinedTable);
  }

  static Observable<void> onUserLeftTable() {
    return WebSocketService.listen(SocketEvents.userLeftTable);
  }

  static Future<UserModel> _getUserById(String userId) async {
    final response = await http.get(formatRoute([ApiRoutes.baseUrl, ApiRoutes.users, userId]));
    if (response.statusCode != 200) { throw Exception('Failed to load User'); }

    return UserModel.fromJson(json.decode(response.body));
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
