class TableItemPayModel {
  final String tableItemId;

  TableItemPayModel({this.tableItemId});

  factory TableItemPayModel.fromJson(Map<String, dynamic> json) {
    return TableItemPayModel(
      tableItemId: json['tableItemId'],
    );
  }

  toJson() {
    return {
      'tableItemId': tableItemId,
    };
  }
}
