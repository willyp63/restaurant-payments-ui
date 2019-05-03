import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../models/table-item.model.dart';
import '../models/table-item-pay.model.dart';
import '../constants/api-routes.constants.dart';
import '../constants/socket-events.constants.dart';
import '../utils/route.utils.dart';
import '../services/websocket.service.dart';

class TableItemService {

  static void payForTableItem(TableItemPayModel itemPay) {
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
