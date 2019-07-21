import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:restaurant_payments_ui/constants/app-routes.constants.dart';
import 'package:restaurant_payments_ui/models/table.model.dart';
import 'package:restaurant_payments_ui/services/index.dart';
import 'package:restaurant_payments_ui/theme/colors.dart';
import 'package:restaurant_payments_ui/utils/date.utils.dart';
import 'package:restaurant_payments_ui/widgets/shared/divider.widget.dart';
import 'package:restaurant_payments_ui/widgets/shared/index.dart';

class MMSHome extends StatefulWidget {
  @override
  _MMSHomeScreenState createState() => _MMSHomeScreenState();
}

class _MMSHomeScreenState extends State<MMSHome> {
  Future<List<TableModel>> _tables;

  @override
  void initState() {
    super.initState();

    _tables = UserService.getPastTables();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 36),
                child: Text('Scan code',
                    style: Theme.of(context).textTheme.headline),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: InkWell(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: MMSColors.white,
                      border: Border.all(
                          color: MMSColors.gray,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    child:
                        Icon(Icons.camera_alt, size: 80, color: MMSColors.teal),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.scanCode);
                  },
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 48),
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Recent tables',
                  style: Theme.of(context).textTheme.headline,
                ),
                MMSButton(
                  type: MMSButtonType.Link,
                  text: 'View all',
                  onPressed: _onViewAllRecentPressed,
                ),
              ],
            ),
          ),
          MMSDivider(),
          Expanded(
            child: _buildPastTablesList(context),
          )
        ],
      ),
    );
  }

  Widget _buildPastTablesList(BuildContext context) {
    return FutureBuilder(
      future: _tables,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<TableModel> tables = snapshot.data;

          if (tables.length == 0) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'No recent tables',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .merge(TextStyle(color: MMSColors.gray)),
              ),
            );
          }

          return ListView(
            children: tables
                .map((table) {
                  return [
                    MMSListTile(
                      title: table.name,
                      subtitle: 'Date Visted:  ' + formatDate(table.joinedAt),
                    ),
                    MMSDivider(),
                  ];
                })
                .expand((i) => i)
                .toList(),
          );
        } else if (snapshot.hasError) {
          throw snapshot.error;
        }

        return MMSSpinner();
      },
    );
  }

  _onViewAllRecentPressed() {
    // TODO
  }
}
