import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/index.dart';
import '../table/table.widget.dart';

class MMSJoinTable extends StatefulWidget {
  @override
  _MMSJoinTableState createState() => new _MMSJoinTableState();
}

class _MMSJoinTableState extends State<MMSJoinTable> {
  @override
  initState() {
    super.initState();
    _scan();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future _scan() async {
    try {
      String tableId = await BarcodeScanner.scan();
      _goToTableView(tableId);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print('The user did not grant the camera permission!');
      } else {
        print('Unknown error: $e');
      }
    } on FormatException{
      print('null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      print('Unknown error: $e');
    }
  }

  void _goToTableView(String tableId) {
    UserService.addUserToTable(tableId);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => MMSTable(tableId),
      ),
    );
  }
}
