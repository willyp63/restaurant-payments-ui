import 'package:flutter/material.dart';

import 'package:restaurant_payments_ui/theme/colors.dart';

class MMSTableScreenArguments {
  final String tableId;

  MMSTableScreenArguments({this.tableId});
}

class MMSTableScreen extends StatefulWidget {
  @override
  _MMSTableScreenState createState() => _MMSTableScreenState();
}

class _MMSTableScreenState extends State<MMSTableScreen> {
  @override
  Widget build(BuildContext context) {
    final MMSTableScreenArguments args = ModalRoute.of(context).settings.arguments;
    final tableId = args.tableId;

    return Scaffold(
      backgroundColor: MMSColors.white,
      body: Center(child: Text(tableId)),
    );
  }
}
