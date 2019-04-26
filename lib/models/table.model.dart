class TableModel {
  final String id;
  final String name;

  TableModel({this.id, this.name});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['_id'],
      name: json['name'],
    );
  }
}
