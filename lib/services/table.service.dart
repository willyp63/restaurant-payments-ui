import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/table.model.dart';

Future<TableModel> fetchTableById(String tableId) async {
  final response =
      await http.get('https://restaurant-payments-api.herokuapp.com/table/$tableId');

  if (response.statusCode == 200) {
    return TableModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load table');
  }
}
