import './table-item.model.dart';
import './json-convertable.model.dart';

class UserModel implements JSONConvertable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String joinedTableAt;
  final String leftTableAt;
  final List<TableItemModel> paidForItems;

  UserModel({
    this.id = '',
    this.firstName,
    this.lastName,
    this.email = 'a@b.co',
    this.joinedTableAt = '',
    this.leftTableAt = '',
    this.paidForItems = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      joinedTableAt: json['joinedTableAt'],
      leftTableAt: json['leftTableAt'],
      paidForItems: json['paidForItems'] != null ? (json['paidForItems'] as List).map((item) => TableItemModel.fromJson(item)).toList() : [],
    );
  }

  Map toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
