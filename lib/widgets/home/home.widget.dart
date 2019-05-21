import 'package:flutter/material.dart';

import './main-drawer.widget.dart';

import '../../services/index.dart';
import '../../constants/index.dart';
import '../shared/index.dart';

class MMSHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MMSMainDrawer(
        user: UserService.getActiveUser(),
        onSignOut: () {
          UserService.signOutUser().then((_) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.signUp, (_) => false);
          });
        },
      ),
      body: Container(
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 16),
                child: MMSButton(
                  text: 'Join Table',
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.joinTable),
                ),
              ),
              Container(
                child: MMSButton(
                  type: MMSButtonType.Secondary,
                  text: 'Past Tables',
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.pastTables),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
