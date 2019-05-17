import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/table-event.model.dart';
import '../services/user.service.dart';
import '../services/websocket.service.dart';
import '../services/table-event.service.dart';
import '../utils/table-event.utils.dart';
import '../utils/table-item.utils.dart';

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

    TableEventService.seeEvents(widget.tableId);

    _eventsSubscription = WebSocketService.onReconnect(() {
      setState(() {
        _events = TableEventService.getTableEvents(widget.tableId);
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
                        title: Text(formatTableEvent(event, UserService.getActiveUser())),
                        subtitle: Text(dateFormatter.format(DateTime.parse(event.date).toLocal())),
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
