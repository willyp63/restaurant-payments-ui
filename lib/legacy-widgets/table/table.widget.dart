import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/index.dart';
import '../../utils/index.dart';
import '../../constants/index.dart';
import '../../services/index.dart';

import './table-events.widget.dart';

class MMSTable extends StatefulWidget {
  final String tableId;

  MMSTable(this.tableId);

  @override
  _MMSTableState createState() => _MMSTableState();
}

class _MMSTableState extends State<MMSTable> {
  Future<TableModel> table;
  Observable<List<TableItemModel>> _tableItems;
  Observable<int> _numUnseenEvents;
  StreamSubscription _websocketSubscription;
  StreamSubscription _tableItemsSubscription;
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
        _numUnseenEvents = TableEventService.getNumUnseenEvents(widget.tableId);

        // remove item from selection if it has been removed from unpaid items
        if (_tableItemsSubscription != null) {
          _tableItemsSubscription.cancel();
        }
        _tableItemsSubscription = TableItemService.getTableItems(widget.tableId)
            .listen((List<TableItemModel> tableItems) {
          List<TableItemModel> unpaidTableItems =
              tableItems.where((item) => item.paidForAt == null).toList();

          Set<String> selectedItemIdsToRemove = Set<String>();
          _selectedItemIds.forEach((itemId) {
            if (!unpaidTableItems.any((item) => item.id == itemId)) {
              selectedItemIdsToRemove.add(itemId);
            }
          });

          if (selectedItemIdsToRemove.length > 0) {
            setState(() {
              selectedItemIdsToRemove.forEach((itemId) {
                _selectedItems
                    .removeWhere((selectedItem) => selectedItem.id == itemId);
                _selectedItemIds.remove(itemId);
              });
            });
          }
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_websocketSubscription != null) {
      _websocketSubscription.cancel();
    }
    if (_tableItemsSubscription != null) {
      _tableItemsSubscription.cancel();
    }
    if (_itemPaySubscription != null) {
      _itemPaySubscription.cancel();
    }
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
                _buildEventsButton(),
              ],
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      bottom: _selectedItems.length > 0 ? 192 : 0),
                  child: _buildBothTableItemLists(),
                ),
                _selectedItems.length > 0
                    ? Positioned(
                        // red box
                        child: Container(
                          height: 192,
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _buildFooterRow(
                                  'Your Items:', selectedItemsTotal),
                              Container(
                                height: 40,
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
                                padding: EdgeInsets.only(top: 16),
                                height: 56,
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
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

  Widget _buildEventsButton() {
    return StreamBuilder(
      stream: _numUnseenEvents,
      builder: (context, snapshot) {
        int numEvents = 0;
        if (snapshot.hasData) {
          numEvents = snapshot.data;
        } else if (snapshot.hasError) {
          throw snapshot.error;
        }

        return GestureDetector(
          onTap: _goToTableEventsView,
          child: Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.list, color: Colors.white),
                onPressed: null,
              ),
              numEvents == 0
                ? Container()
                : Positioned(
                  top: 6,
                  right: 4,
                  child: Stack(
                  children: <Widget>[
                  Icon(Icons.brightness_1,
                      size: 20.0, color: Colors.orange[800]),
                  Positioned(
                      top: 0,
                      left: 0,
                      width: 20,
                      height: 20,
                      child: Center(
                        child: Text(
                          numEvents.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500),
                        ),
                      )),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooterRow(String label, num amount) {
    return Container(
      height: 32,
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
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
              ],
              _buildTableItems(unpaidTableItems, true),
              [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Paid for:', style: _boldFont),
                  decoration: BoxDecoration(
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
                      color: isItemSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    )
                  : Text(
                      'Paid for by: ' +
                          formatUser(
                              item.paidForBy, UserService.getActiveUser()),
                      style: _greyFont),
              onTap: () {
                if (!isSelectable) {
                  return;
                }

                setState(() {
                  if (isItemSelected) {
                    _selectedItems.removeWhere(
                        (selectedItem) => selectedItem.id == item.id);
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

      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
    });
  }

  _goToTableEventsView() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => MMSTableEvents(widget.tableId),
      ),
    );
  }
}
