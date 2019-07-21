import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:restaurant_payments_ui/widgets/shared/index.dart';

class MMSAccountPaymentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MMSAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 48),
        child: Text(
          'Account Payments',
          style: Theme.of(context).textTheme.display2,
        ),
      ),
    );
  }
}
