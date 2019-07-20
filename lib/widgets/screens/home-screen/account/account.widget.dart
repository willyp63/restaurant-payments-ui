import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurant_payments_ui/constants/app-routes.constants.dart';

import 'package:restaurant_payments_ui/services/index.dart';
import 'package:restaurant_payments_ui/theme/colors.dart';
import 'package:restaurant_payments_ui/utils/index.dart';
import 'package:restaurant_payments_ui/widgets/shared/index.dart';

class MMSAccount extends StatefulWidget {
  @override
  _MMSAccountScreenState createState() => _MMSAccountScreenState();
}

class _MMSAccountScreenState extends State<MMSAccount> {
  @override
  Widget build(BuildContext context) {
    final user = UserService.getActiveUser();

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 24),
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: MMSColors.teal,
                ),
                child: Center(
                  child: Text(
                    formatUserInitials(user),
                    style: Theme.of(context)
                        .textTheme
                        .display3
                        .merge(TextStyle(color: MMSColors.white)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 12),
                child: Text(
                  formatUser(user),
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: Text(
              'View & edit your account',
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          MMSDivider(),
          Expanded(
            child: ListView(
              children: <Widget>[
                MMSListTile(
                  title: 'Personal',
                  subtitle: 'Email, phone number, preferences',
                ),
                MMSDivider(),
                MMSListTile(
                  title: 'Location',
                  subtitle: 'Choose your location',
                ),
                MMSDivider(),
                MMSListTile(
                  title: 'Payment',
                  subtitle: 'Set up payment methods',
                ),
                MMSDivider(),
                MMSListTile(
                  title: 'Notifications',
                  subtitle: 'Configure notifications',
                ),
                MMSDivider(),
                MMSListTile(
                  title: 'Logout',
                  onTap: _signOutUser,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _signOutUser() {
    UserService.signOutUser().then((_) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.welcome, (route) => false);
    });
  }
}
