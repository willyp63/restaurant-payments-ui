import './table-item.model.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String joinedTableAt;
  final String leftTableAt;
  final List<TableItemModel> paidForItems;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.joinedTableAt,
    this.leftTableAt,
    this.paidForItems,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      joinedTableAt: json['joinedTableAt'],
      leftTableAt: json['leftTableAt'],
      paidForItems: (json['paidForItems'] as List).map((item) => TableItemModel.fromJson(item)).toList(),
    );
  }
}
