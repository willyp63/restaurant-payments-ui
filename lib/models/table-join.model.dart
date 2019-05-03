import './json-convertable.model.dart';

class TableJoinModel implements JSONConvertable {
  final String tableId;
  final String userId;

  TableJoinModel({this.tableId, this.userId});

  factory TableJoinModel.fromJson(Map<String, dynamic> json) {
    return TableJoinModel(
      tableId: json['tableId'],
      userId: json['userId'],
    );
  }

  Map toJson() {
    return {
      'tableId': tableId,
      'userId': userId,
    };
  }
}
