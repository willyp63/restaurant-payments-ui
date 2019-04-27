import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final Set<String> selectedItemIds = Set<String>();
  final currencyFormatter = NumberFormat.currency(symbol: '\$');
  final TextStyle _biggerFont = const TextStyle(fontSize: 28);

  @override
  void initState() {
    super.initState();
    table = TableService.fetchTableById(widget.tableId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: table,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TableModel table = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text(table.name),
            ),
            body: ListView(
              children: table.items.map((item) {
                bool isItemSelected = selectedItemIds.contains(item.id);

                return [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    title: Text(item.name),
                    subtitle: Text(currencyFormatter.format(item.price)),
                    trailing: Icon(
                      isItemSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    ),
                    onTap: () {
                      setState(() {
                        if (isItemSelected) {
                          selectedItemIds.remove(item.id);
                        } else {
                          selectedItemIds.add(item.id);
                        }
                      });
                    },
                  ),
                  Divider(),
                ];
              }).expand((i) => i).toList(),
            ),
            persistentFooterButtons: selectedItemIds.length > 0 ? <Widget>[
              new Container(
                height: 40,
                child: new Center(
                  child: new FlatButton(
                    child: new Text('Pay for Items'),
                    onPressed: _onPayPressed
                  ),
                )
              )
            ] : null,
          );
        } else if (snapshot.hasError) {
          throw snapshot.error;
        }

        // By default, show a loading spinner
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _onPayPressed() {
    // TODO
  }
}
