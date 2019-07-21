class TableModel {
  final String id;
  final String name;
  final String joinedAt;

  TableModel({this.id, this.name, this.joinedAt});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['_id'],
      name: json['name'],
      joinedAt: json['joinedAt'],
    );
  }
}
