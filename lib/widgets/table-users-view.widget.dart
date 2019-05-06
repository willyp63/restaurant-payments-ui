import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/user.model.dart';
import '../services/user.service.dart';
import '../services/websocket.service.dart';
import '../utils/name.utils.dart';
import '../utils/table-item.utils.dart';

class ExpandableUserModel {
  UserModel user;
  bool isExpanded;

  ExpandableUserModel({ this.user, this.isExpanded: false });
}

class TableUsersView extends StatefulWidget {
  final String tableId;

  TableUsersView(this.tableId);

  @override
  _TableUsersViewState createState() => _TableUsersViewState();
}

class _TableUsersViewState extends State<TableUsersView> {
  Observable<List<ExpandableUserModel>> _users;
  StreamSubscription _usersSubscription;

  final TextStyle _boldFont = const TextStyle(fontSize: 12, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();

    _usersSubscription = WebSocketService.onReconnect(() {
      setState(() {
        _users = UserService.getTableUsers(widget.tableId).map((users) {
          return users.map((user) => new ExpandableUserModel(user: user)).toList();
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usersSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _users,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ExpandableUserModel> users = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text('People At Table'),
            ),
            body: ListView(
              children: [
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      users[index].isExpanded = !users[index].isExpanded;
                    });
                  },
                  children: users.map((user) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 24),
                              child: Text(formatName(user.user) + ' (' + user.user.paidForItems.length.toString() + ')'),
                            ),
                          ],
                        );
                      },
                      isExpanded: user.isExpanded,
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Divider(),
                          Container(
                            padding: EdgeInsets.only(left: 24),
                            child: Text(user.user.paidForItems.length != 0 ? 'Paid for Items:' : 'No items paid for...', style: _boldFont),
                          ),
                          Divider(),
                          Column(
                            children: user.user.paidForItems.map((item) {
                              return Column(
                                children: <Widget>[
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                                    title: Text(formatTableItem(item)),
                                  ),
                                  Divider(),
                                ],
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
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
}
