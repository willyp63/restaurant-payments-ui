import 'dart:async';
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
import '../services/websocket.service.dart';

class TableView extends StatefulWidget {
  final String tableId;

  TableView(this.tableId);

  @override
  _TableViewState createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  Future<TableModel> table;
  Observable<List<TableItemModel>> _tableItems;
  StreamSubscription _tableItemsSubscription;

  final Set<String> selectedItemIds = Set<String>();

  final TextStyle _boldFont =
      const TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
  final TextStyle _bigFont = const TextStyle(fontSize: 20);

  @override
  void initState() {
    super.initState();

    table = TableService.getTableById(widget.tableId);

    _tableItemsSubscription = WebSocketService.onReconnect(() {
      setState(() {
        _tableItems = TableItemService.getTableItems(widget.tableId);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tableItemsSubscription.cancel();
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
            body: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      bottom: selectedItemIds.length > 0 ? 158 : 0),
                  child: _buildBothTableItemLists(),
                ),
                selectedItemIds.length > 0
                    ? Positioned(
                        // red box
                        child: Container(
                          height: 158,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 16, bottom: 16),
                                child: Text('Total: 12.50', style: _bigFont),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 16, bottom: 16),
                                child: Text('Tip: 12.50', style: _bigFont),
                              ),
                              RaisedButton(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: new Text('Pay for Items', style: _bigFont),
                                onPressed: _onPayPressed,
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            boxShadow: <BoxShadow>[
                              BoxShadow (
                                color: const Color(0xcc000000),
                                offset: Offset(0.0, 2.0),
                                blurRadius: 4.0,
                              ),
                              BoxShadow (
                                color: const Color(0x80000000),
                                offset: Offset(0.0, 6.0),
                                blurRadius: 20.0,
                              ),
                            ], 
                          ),
                          padding: EdgeInsets.all(16.0),
                        ),
                        bottom: 0,
                        left: 0,
                        right: 0,
                      )
                    : Container(),
              ],
            ),
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

  Widget _buildBothTableItemLists() {
    return StreamBuilder(
      stream: _tableItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TableItemModel> tableItems = snapshot.data;
          List<TableItemModel> paidForTableItems =
              tableItems.where((item) => item.paidForAt != null).toList();
          List<TableItemModel> unpaidTableItems =
              tableItems.where((item) => item.paidForAt == null).toList();

          return ListView(
            children: [
              [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Unpaid:', style: _boldFont),
                  decoration: new BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
              ],
              _buildTableItems(unpaidTableItems, true),
              [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Paid for:', style: _boldFont),
                  decoration: new BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
              ],
              _buildTableItems(paidForTableItems, false),
            ].expand((x) => x).toList(),
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

  List<Widget> _buildTableItems(
      List<TableItemModel> tableItems, bool isSelectable) {
    return tableItems
        .map((item) {
          bool isItemSelected = selectedItemIds.contains(item.id);

          return [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              title: Text(formatTableItemName(item)),
              subtitle: Text(formatTableItemPrice(item)),
              trailing: isSelectable
                  ? Icon(
                      isItemSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                    )
                  : null,
              onTap: () {
                if (!isSelectable) {
                  return;
                }

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
        })
        .expand((x) => x)
        .toList();
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
