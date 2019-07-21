import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:restaurant_payments_ui/theme/colors.dart';

class MMSAppBar extends AppBar {
  MMSAppBar()
      : super(
          elevation: 0,
          centerTitle: true,
          title: Container(
            width: 100,
            child: Image.asset('images/mimos_logo_white.png'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: MMSColors.white),
              onPressed: () {
                // TODO: search for something...
              },
            ),
          ],
        );
}
