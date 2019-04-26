class TableItemModel {
  final String id;
  final String name;
  final num price;
  final bool paidFor;

  TableItemModel({this.id, this.name, this.price, this.paidFor});

  factory TableItemModel.fromJson(Map<String, dynamic> json) {
    return TableItemModel(
      id: json['_id'],
      name: json['name'],
      price: json['price'],
      paidFor: json['paidFor'] == null ? false : json['paidFor'],
    );
  }
}
