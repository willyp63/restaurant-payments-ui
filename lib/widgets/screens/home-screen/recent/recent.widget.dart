import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:restaurant_payments_ui/constants/index.dart';
import 'package:restaurant_payments_ui/models/table.model.dart';
import 'package:restaurant_payments_ui/services/index.dart';
import 'package:restaurant_payments_ui/theme/colors.dart';
import 'package:restaurant_payments_ui/utils/date.utils.dart';
import 'package:restaurant_payments_ui/widgets/screens/table-screen/table-screen.widget.dart';
import 'package:restaurant_payments_ui/widgets/shared/divider.widget.dart';
import 'package:restaurant_payments_ui/widgets/shared/index.dart';

class MMSRecent extends StatefulWidget {
  @override
  _MMSRecentState createState() => _MMSRecentState();
}

class _MMSRecentState extends State<MMSRecent> {
  Future<List<TableModel>> _recentTables;
  bool _sortDescending = true;

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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Text('Sort by date', style: Theme.of(context).textTheme.title),
                    Container(
                      margin: EdgeInsets.only(left: 4),
                      child: Icon(_sortDescending ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                    ),
                  ],
                ),
                onPressed: _onSortByDatePressed,
              ),
            ],
          ),
        ),
        MMSDivider(),
        Expanded(
          child: Container(
            color: MMSColors.white,
            child: _buildPastTablesList(context),
          ),
        )
      ],
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

          if (_sortDescending) {
            tables.sort((a, b) => b.joinedAt.compareTo(a.joinedAt));
          } else {
            tables.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));
          }

          return ListView(
            children: tables
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

  _onSortByDatePressed() {
    setState(() {
      _sortDescending = !_sortDescending;
    });
  }
}
