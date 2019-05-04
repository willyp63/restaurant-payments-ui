import './user.model.dart';

class TableItemModel {
  final String id;
  final String name;
  final num price;
  final String paidForAt;
  final UserModel paidForBy;

  TableItemModel({this.id, this.name, this.price, this.paidForAt, this.paidForBy});

  factory TableItemModel.fromJson(Map<String, dynamic> json) {
    return TableItemModel(
      id: json['_id'],
      name: json['name'],
      price: json['price'],
      paidForAt: json['paidForAt'],
      paidForBy: json['paidForBy'] != null ? UserModel.fromJson(json['paidForBy']) : null,
    );
  }
}
