import 'package:flutter/material.dart';

import '../models/table.model.dart';
import '../services/table.service.dart' as TableService;

class TableView extends StatefulWidget {
  final String tableId;

  TableView(this.tableId);

  @override
  _TableViewState createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  Future<TableModel> table;

  @override
  void initState() {
    super.initState();
    table = TableService.fetchTableById(widget.tableId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tableId),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            future: table,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.name);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          )
        ),
      )
    );
  }
}
