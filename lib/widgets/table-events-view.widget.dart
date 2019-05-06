import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/user.model.dart';
import '../models/table-item.model.dart';
import '../models/table-event.model.dart';
import '../services/user.service.dart';
import '../services/websocket.service.dart';
import '../services/table-item.service.dart';
import '../utils/table-event.utils.dart';

class TableEventsView extends StatefulWidget {
  final String tableId;

  TableEventsView(this.tableId);

  @override
  _TableEventsViewState createState() => _TableEventsViewState();
}

class _TableEventsViewState extends State<TableEventsView> {
  Observable<List<TableEventModel>> _events;
  StreamSubscription _eventsSubscription;

  @override
  void initState() {
    super.initState();

    _eventsSubscription = WebSocketService.onReconnect(() {
      setState(() {
        _events = Observable.combineLatest2<List<UserModel>, List<TableItemModel>, List<TableEventModel>>(
          UserService.getTableUsers(widget.tableId),
          TableItemService.getTableItems(widget.tableId),
          (List<UserModel> users, List<TableItemModel> tableItems) {

            List<ItemPayEventModel> itemPayEvents = tableItems
              .where((item) => item.paidForAt != null)
              .map((item) {
                return new ItemPayEventModel(
                  date: item.paidForAt,
                  tableItem: item,
                  user: item.paidForBy,
                );
              }).toList();

            List<UserJoinEventModel> userJoinEvents = users
              .map((user) {
                return new UserJoinEventModel(
                  date: user.joinedTableAt,
                  user: user,
                );
              }).toList();

            List<UserLeaveEventModel> userLeaveEvents = users
              .where((user) => user.leftTableAt != null)
              .map((user) {
                return new UserLeaveEventModel(
                  date: user.leftTableAt,
                  user: user,
                );
              }).toList();

            List<TableEventModel> events = [itemPayEvents, userJoinEvents, userLeaveEvents].expand((x) => x).toList();
            events.sort((a, b) => a.date.compareTo(b.date));
            return events;
          },
        );
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventsSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _events,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TableEventModel> events = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text('Table Events'),
            ),
            body: ListView(
              children: events
                  .map((event) {
                    return [
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        title: Text(formatTableEvent(event)),
                      ),
                      Divider(),
                    ];
                  })
                  .expand((i) => i)
                  .toList(),
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
}
