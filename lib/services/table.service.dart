import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/index.dart';
import '../utils/index.dart';
import '../constants/index.dart';

class TableService {

  static Future<TableModel> getTableById(String tableId) async {
    final response = await http.get(formatRoute([ApiRoutes.baseUrl, ApiRoutes.tables, tableId]));
    if (response.statusCode != 200) { throw Exception('Failed to load Table'); }

    return TableModel.fromJson(json.decode(response.body));
  }
  
}
