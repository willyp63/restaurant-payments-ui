import 'package:flutter/material.dart';

import '../models/table.model.dart';
import '../services/user.service.dart';
import './table-view.widget.dart';

class PastTables extends StatefulWidget {
  @override
  _PastTablesState createState() => _PastTablesState();
}

class _PastTablesState extends State<PastTables> {
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
          List<TableModel> pastTables = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text('Past Tables'),
            ),
            body: ListView(
              children: pastTables
                  .map((pastTable) {
                    return [
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        title: Text(pastTable.name),
                        onTap: () => _goToTableView(pastTable.id),
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

  void _goToTableView(String tableId) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => TableView(tableId),
      ),
    );
  }
}
