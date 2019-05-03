import './json-convertable.model.dart';

class TableItemPayModel implements JSONConvertable {
  final String tableItemId;
  final String userId;

  TableItemPayModel({this.tableItemId, this.userId});

  factory TableItemPayModel.fromJson(Map<String, dynamic> json) {
    return TableItemPayModel(
      tableItemId: json['tableItemId'],
      userId: json['userId'],
    );
  }

  Map toJson() {
    return {
      'tableItemId': tableItemId,
      'userId': userId,
    };
  }
}
