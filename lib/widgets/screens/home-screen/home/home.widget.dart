import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:restaurant_payments_ui/constants/app-routes.constants.dart';
import 'package:restaurant_payments_ui/theme/colors.dart';

class MMSHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 36),
            child:
                Text('Scan code', style: Theme.of(context).textTheme.headline),
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
                child: Icon(Icons.camera_alt, size: 80, color: MMSColors.teal),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.scanCode);
              },
            ),
          ),
        ],
      ),
    );
  }
}
