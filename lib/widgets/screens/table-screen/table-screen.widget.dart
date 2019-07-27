import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimos/utils/currency.utils.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sticky_headers/sticky_headers.dart';

import 'package:mimos/constants/index.dart';
import 'package:mimos/models/index.dart';
import 'package:mimos/services/index.dart';
import 'package:mimos/utils/index.dart';
import 'package:mimos/widgets/shared/index.dart';

class MMSTableScreenArguments {
  final String tableId;

  MMSTableScreenArguments({this.tableId});
}

class MMSTableScreen extends StatefulWidget {
  final String tableId;

  MMSTableScreen({this.tableId});

  @override
  _MMSTableScreenState createState() => _MMSTableScreenState();
}

class _MMSTableScreenState extends State<MMSTableScreen> {
  Future<TableModel> _table;
  Observable<List<TableItemModel>> _tableItems;
  StreamSubscription _websocketSubscription;
  StreamSubscription _tableItemsSubscription;
  StreamSubscription _itemPaySubscription;

  final Set<TableItemModel> _selectedItems = Set<TableItemModel>();
  final Set<String> _selectedItemIds = Set<String>();

  @override
  void initState() {
    super.initState();

    _table = TableService.getTableById(widget.tableId);

    _websocketSubscription = WebSocketService.onReconnect(() {
      setState(() {
        _tableItems = TableItemService.getTableItems(widget.tableId);
      });

      _removePaidForItemsFromSelection();
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
    return FutureBuilder(
      future: _table,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final TableModel table = snapshot.data;

          return Scaffold(
            backgroundColor: MMSColors.babyPowder,
            appBar: MMSAppBar(
              title: Text(
                table.name,
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .merge(TextStyle(color: MMSColors.white)),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: _buildTableIems(),
                ),
                _buildBottomDrawer(),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          throw snapshot.error;
        }

        return Scaffold(
          backgroundColor: MMSColors.babyPowder,
          appBar: MMSAppBar(title: Container()),
          body: Center(child: MMSSpinner()),
        );
      },
    );
  }

  Widget _buildTableIems() {
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
            shrinkWrap: true,
            children: <Widget>[
              StickyHeader(
                header: Column(
                  children: <Widget>[
                    MMSListHeader(title: 'Unpaid'),
                    MMSDivider(),
                  ],
                ),
                content: Column(
                  children: _buildTableItemList(unpaidTableItems, false),
                ),
              ),
              StickyHeader(
                header: Column(
                  children: <Widget>[
                    MMSListHeader(title: 'Paid'),
                    MMSDivider(),
                  ],
                ),
                content: Column(
                  children: _buildTableItemList(paidForTableItems, true),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          throw snapshot.error;
        }

        return Center(child: MMSSpinner());
      },
    );
  }

  List<Widget> _buildTableItemList(
      List<TableItemModel> tableItems, bool isPaidFor) {
    return tableItems
        .map((item) {
          bool isItemSelected = _selectedItemIds.contains(item.id);

          return [
            MMSListTile(
              title: formatTableItemName(item),
              subtitle: isPaidFor
                  ? formatCurrency(item.price) +
                      '\nPaid by ' +
                      formatUser(item.paidForBy, UserService.getActiveUser())
                  : formatCurrency(item.price),
              trailing: isPaidFor
                  ? null
                  : isItemSelected
                      ? Icon(Icons.check_box, color: MMSColors.violet, size: 32)
                      : Container(
                          margin: EdgeInsets.only(right: 4),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(
                                style: BorderStyle.solid,
                                color: MMSColors.violet,
                                width: 1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
              onTap: () {
                if (isPaidFor) {
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
            MMSDivider(),
          ];
        })
        .expand((x) => x)
        .toList();
  }

  Widget _buildBottomDrawer() {
    final numItems = _selectedItems.length;
    final selectedItemsSubtotal = _selectedItems.length != 0
        ? _selectedItems
            .map((item) => item.price)
            .reduce((sum, itemPrice) => sum + itemPrice)
        : 0;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MMSColors.white,
        boxShadow: [
          new BoxShadow(
            color: const Color(0x66000000),
            offset: new Offset(0.0, 0.0),
            blurRadius: 8.0,
          )
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Your items ($numItems):',
                style: Theme.of(context).textTheme.headline,
              ),
              Text(
                formatCurrency(selectedItemsSubtotal),
                style: Theme.of(context).textTheme.headline.merge(TextStyle(fontWeight: FontWeight.normal)),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MMSButton(
                  text: 'Add items',
                  onPressed: () {
                    // TODO
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _removePaidForItemsFromSelection() {
    if (_tableItemsSubscription != null) {
      _tableItemsSubscription.cancel();
    }

    final tableItems = TableItemService.getTableItems(widget.tableId);
    _tableItemsSubscription =
        tableItems.listen((List<TableItemModel> tableItems) {
      // TODO: this is really inefficient
      List<TableItemModel> paidForTableItems =
          tableItems.where((item) => item.paidForAt != null).toList();

      Set<String> selectedItemIdsToRemove = Set<String>();
      _selectedItemIds.forEach((itemId) {
        if (paidForTableItems.any((item) => item.id == itemId)) {
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
  }
}
