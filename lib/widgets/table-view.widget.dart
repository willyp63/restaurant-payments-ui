import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import './home.widget.dart';
import './table-events-view.widget.dart';
import './table-users-view.widget.dart';
import '../utils/table-item.utils.dart';
import '../utils/name.utils.dart';
import '../models/table.model.dart';
import '../models/table-item.model.dart';
import '../services/table.service.dart';
import '../services/table-item.service.dart';
import '../services/websocket.service.dart';
import '../services/user.service.dart';

class TableView extends StatefulWidget {
  final String tableId;

  TableView(this.tableId);

  @override
  _TableViewState createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  Future<TableModel> table;
  Observable<List<TableItemModel>> _tableItems;
  StreamSubscription _websocketSubscription;
  StreamSubscription _itemPaySubscription;

  bool _isLoading = false;

  final Set<TableItemModel> _selectedItems = Set<TableItemModel>();
  final Set<String> _selectedItemIds = Set<String>();
  num _tipPercent = .2;

  final TextStyle _boldFont =
      const TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
  final TextStyle _bigFont = const TextStyle(fontSize: 20);
  final TextStyle _greyFont = const TextStyle(color: Colors.grey);

  @override
  void initState() {
    super.initState();

    table = TableService.getTableById(widget.tableId);

    _websocketSubscription = WebSocketService.onReconnect(() {
      setState(() {
        _tableItems = TableItemService.getTableItems(widget.tableId);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_websocketSubscription != null) { _websocketSubscription.cancel(); }
    if (_itemPaySubscription != null) { _itemPaySubscription.cancel(); }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(),
        );
    }

    return FutureBuilder(
      future: table,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TableModel table = snapshot.data;
          num selectedItemsSubtotal = _selectedItems.length != 0
              ? _selectedItems
                  .map((item) => item.price)
                  .reduce((sum, itemPrice) => sum + itemPrice)
              : 0;
          num selectedItemsTax = selectedItemsSubtotal * 0.07;
          num selectedItemsTotal = selectedItemsSubtotal + selectedItemsTax;

          num tipAmount = _tipPercent * selectedItemsTotal;
          num finalTotal = selectedItemsTotal + tipAmount;

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
                      bottom: _selectedItems.length > 0 ? 214 : 0),
                  child: _buildBothTableItemLists(),
                ),
                _selectedItems.length > 0
                    ? Positioned(
                        // red box
                        child: Container(
                          height: 214,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              _buildFooterRow(
                                  'Your Items:', selectedItemsTotal),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flex(
                                      direction: Axis.horizontal,
                                      children: <Widget>[
                                        Text('Tip:', style: _bigFont),
                                        Slider(
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          min: .1,
                                          max: .3,
                                          onChanged: (newTipPercent) {
                                            setState(() =>
                                                _tipPercent = newTipPercent);
                                          },
                                          value: _tipPercent,
                                        ),
                                        Text(
                                            '(' +
                                                percentFormatter
                                                    .format(_tipPercent) +
                                                ')',
                                            style: _bigFont),
                                      ],
                                    ),
                                    Text(currencyFormatter.format(tipAmount),
                                        style: _bigFont),
                                  ],
                                ),
                              ),
                              _buildFooterRow('Your Total:', finalTotal),
                              Container(
                                padding: EdgeInsets.only(top: 8),
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Text('Pay for Items', style: _bigFont),
                                  onPressed: _onPayPressed,
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: const Color(0xcc000000),
                                offset: Offset(0.0, 2.0),
                                blurRadius: 4.0,
                              ),
                              BoxShadow(
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

  Widget _buildFooterRow(String label, num amount) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: _bigFont),
          Text(currencyFormatter.format(amount), style: _bigFont),
        ],
      ),
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
          bool isItemSelected = _selectedItemIds.contains(item.id);

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
                      color: isItemSelected ? Theme.of(context).primaryColor : Colors.grey,
                    )
                  : Text('Paid for by: ' + formatName(item.paidForBy, UserService.getActiveUser()), style: _greyFont),
              onTap: () {
                if (!isSelectable) {
                  return;
                }

                setState(() {
                  if (isItemSelected) {
                    _selectedItems.removeWhere((selectedItem) => selectedItem.id == item.id);
                    _selectedItemIds.remove(item.id);
                  } else {
                    _selectedItems.add(item);
                    _selectedItemIds.add(item.id);
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
    setState(() {
      _isLoading = true;
    });
    
    _selectedItems.forEach((TableItemModel item) {
      TableItemService.payForTableItem(item.id);
    });

    _itemPaySubscription = TableItemService.onTableItemPaidFor().listen((_) {
      _itemPaySubscription.cancel();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (context) => Home(),
        ),
        (_) => false,
      );
    });
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
