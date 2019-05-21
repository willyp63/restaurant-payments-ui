import 'package:flutter/material.dart';

import '../../models/index.dart';
import '../../utils/index.dart';
import '../../constants/index.dart';

class MMSMainDrawer extends StatelessWidget {
  final UserModel user;
  final void Function() onSignOut;

  MMSMainDrawer({this.user, this.onSignOut});

  @override
  Widget build(context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Container(
                  child: Icon(Icons.person),
                  padding: EdgeInsets.only(right: 16),
                ),
                Text(formatUser(user), style: Fonts.xl),
              ],
            ),
          ),
          ListTile(
            title: Text('Sign Out', style: Fonts.lg),
            trailing: Icon(Icons.arrow_forward),
            onTap: onSignOut,
          ),
          Divider(),
        ],
      ),
    );
  }
}
