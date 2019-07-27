import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:mimos/models/index.dart';
import 'package:mimos/utils/index.dart';
import 'package:mimos/constants/index.dart';

import 'package:mimos/services/websocket.service.dart';
import 'package:mimos/services/user.service.dart';

class TableItemService {

  static void payForTableItem(String tableItemId) {
    if (UserService.getActiveUser() == null) { throw Exception('No active User'); }

    final itemPay = new TableItemPayModel(tableItemId: tableItemId, userId: UserService.getActiveUser().id);
    WebSocketService.emit(SocketEvents.payForTableItem, itemPay);
  }

  static Observable<void> onTableItemPaidFor() {
    return WebSocketService.listen(SocketEvents.tableItemPaidFor);
  }

  static Observable<void> onTableItemAdded() {
    return WebSocketService.listen(SocketEvents.tableItemAdded);
  }

  static Observable<void> onTableItemRemoved() {
    return WebSocketService.listen(SocketEvents.tableItemRemoved);
  }

  static Future<List<TableItemModel>> _getTableItems(String tableId) async {
    final response = await http.get(formatRoute([ApiRoutes.baseUrl, ApiRoutes.tables, tableId, ApiRoutes.tableItems]));
    if (response.statusCode != 200) { throw Exception('Failed to load TableItems'); }

    return (json.decode(response.body) as List).map((itemData) => TableItemModel.fromJson(itemData)).toList();
  }

  static Observable<List<TableItemModel>> getTableItems(String tableId) {
    return new Observable.merge([
      new Observable.just(true),
      TableItemService.onTableItemPaidFor(),
      TableItemService.onTableItemAdded(),
      TableItemService.onTableItemRemoved(),
    ]).concatMap((_) {
      return new Stream.fromFuture(TableItemService._getTableItems(tableId));
    });
  }
  
}
