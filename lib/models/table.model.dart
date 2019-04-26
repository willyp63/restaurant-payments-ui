import './table-item.model.dart';

class TableModel {
  final String id;
  final String name;
  final List<TableItemModel> items;

  TableModel({this.id, this.name, this.items});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    List<TableItemModel> items = (json['items'] as List<dynamic>).map((item) {
      return TableItemModel.fromJson(item);
    }).toList();

    return TableModel(
      id: json['_id'],
      name: json['name'],
      items: items,
    );
  }
}
