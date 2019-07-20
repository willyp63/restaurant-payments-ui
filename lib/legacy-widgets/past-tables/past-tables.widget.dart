import 'package:flutter/material.dart';

import '../../models/index.dart';
import '../../services/index.dart';
import '../shared/full-page-spinner.widget.dart';

import '../table/table.widget.dart';

class MMSPastTables extends StatefulWidget {
  @override
  _MMSPastTablesState createState() => _MMSPastTablesState();
}

class _MMSPastTablesState extends State<MMSPastTables> {
  Future<List<TableModel>> _tables;

  @override
  void initState() {
    super.initState();

    _tables = UserService.getPastTables();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _tables,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text('Past Tables')),
            body: _buildTableList(snapshot.data),
          );
        } else if (snapshot.hasError) {
          throw snapshot.error;
        }

        return MMSFullPageSpinner();
      },
    );
  }

  Widget _buildTableList(List<TableModel> tables) {
    return ListView(
      children: tables
          .map((table) {
            return [
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                title: Text(table.name),
                onTap: () => _goToTableView(table.id),
              ),
              Divider(),
            ];
          })
          .expand((i) => i)
          .toList(),
    );
  }

  void _goToTableView(String tableId) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => MMSTable(tableId),
      ),
    );
  }
}
