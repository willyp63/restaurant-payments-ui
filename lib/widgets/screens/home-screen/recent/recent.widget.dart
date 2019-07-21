import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:restaurant_payments_ui/constants/app-routes.constants.dart';
import 'package:restaurant_payments_ui/models/table.model.dart';
import 'package:restaurant_payments_ui/services/index.dart';
import 'package:restaurant_payments_ui/theme/colors.dart';
import 'package:restaurant_payments_ui/utils/date.utils.dart';
import 'package:restaurant_payments_ui/widgets/shared/divider.widget.dart';
import 'package:restaurant_payments_ui/widgets/shared/index.dart';

class MMSRecent extends StatefulWidget {
  @override
  _MMSRecentState createState() => _MMSRecentState();
}

class _MMSRecentState extends State<MMSRecent> {
  Future<List<TableModel>> _recentTables;

  @override
  void initState() {
    super.initState();

    _recentTables = UserService.getPastTables();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
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
      future: _recentTables,
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
