import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:restaurant_payments_ui/constants/app-routes.constants.dart';
import 'package:restaurant_payments_ui/models/table.model.dart';
import 'package:restaurant_payments_ui/services/index.dart';
import 'package:restaurant_payments_ui/theme/colors.dart';
import 'package:restaurant_payments_ui/utils/date.utils.dart';
import 'package:restaurant_payments_ui/widgets/screens/table-screen/table-screen.widget.dart';
import 'package:restaurant_payments_ui/widgets/shared/divider.widget.dart';
import 'package:restaurant_payments_ui/widgets/shared/index.dart';

class MMSHome extends StatefulWidget {
  final void Function() onRecentTablesPressed;

  MMSHome({this.onRecentTablesPressed});

  @override
  _MMSHomeState createState() => _MMSHomeState();
}

class _MMSHomeState extends State<MMSHome> {
  Future<List<TableModel>> _recentTables;

  @override
  void initState() {
    super.initState();

    _recentTables = UserService.getPastTables();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: MMSListHeader(
            title: 'Recent tables',
            actionName: 'View all',
            onAction: widget.onRecentTablesPressed,
          ),
        ),
        MMSDivider(),
        Expanded(
          child: _buildPastTablesList(context),
        )
      ],
    );
  }

  Widget _buildPastTablesList(BuildContext context) {
    return FutureBuilder(
      future: _recentTables,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<TableModel> recentTables = snapshot.data;

          if (recentTables.length == 0) {
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
            children: recentTables
                .map((table) {
                  return [
                    MMSListTile(
                      title: table.name,
                      subtitle: 'Date Visted:  ' + formatDate(table.joinedAt),
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.table, arguments: MMSTableScreenArguments(tableId: table.id));
                      },
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
}
