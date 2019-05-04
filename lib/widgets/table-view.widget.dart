import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import './home.widget.dart';
import './table-events-view.widget.dart';
import './table-users-view.widget.dart';
import '../utils/table-item.utils.dart';
import '../models/table.model.dart';
import '../models/table-item.model.dart';
import '../services/table.service.dart';
import '../services/table-item.service.dart';

class TableView extends StatefulWidget {
  final String tableId;

  TableView(this.tableId);

  @override
  _TableViewState createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  Future<TableModel> table;
  Observable<List<TableItemModel>> tableItems;

  final Set<String> selectedItemIds = Set<String>();

  @override
  void initState() {
    super.initState();

    table = TableService.getTableById(widget.tableId);
    tableItems = TableItemService.getTableItems(widget.tableId);
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
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.people),
                  onPressed: _goToTableUsersView,
                ),
                IconButton(
                  icon: Icon(Icons.list),
                  onPressed: _goToTableEventsView,
                ),
              ],
            ),
            body: _buildTableItemList(),
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

  Widget _buildTableItemList() {
    return StreamBuilder(
      stream: tableItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TableItemModel> tableItems = snapshot.data;

          return ListView(
            children: tableItems.map((item) {
              bool isItemSelected = selectedItemIds.contains(item.id);

              return [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  title: Text(formatTableItemName(item)),
                  subtitle: Text(formatTableItemPrice(item)),
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
    selectedItemIds.forEach((String id) {
      TableItemService.payForTableItem(id);
    });

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Home(),
      ),
    );
  }

  _goToTableUsersView() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TableUsersView(widget.tableId),
      ),
    );
  }

  _goToTableEventsView() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TableEventsView(widget.tableId),
      ),
    );
  }
}
