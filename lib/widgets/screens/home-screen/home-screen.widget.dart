import 'package:flutter/material.dart';

import 'package:restaurant_payments_ui/theme/colors.dart';
import 'package:restaurant_payments_ui/constants/index.dart';
import 'package:restaurant_payments_ui/widgets/shared/app-bar.widget.dart';

import './home/home.widget.dart';
import './account/account.widget.dart';
import './recent/recent.widget.dart';

class MMSHomeScreen extends StatefulWidget {
  @override
  _MMSHomeScreenState createState() => _MMSHomeScreenState();
}

class _MMSHomeScreenState extends State<MMSHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      MMSHome(onRecentTablesPressed: _onRecentTablesPressed),
      MMSRecent(),
      Container(), // clicking this route opens the scanner
      MMSAccount(),
    ];

    return Scaffold(
      backgroundColor: MMSColors.babyPowder,
      appBar: MMSAppBar(),
      body: children[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: MMSColors.warmGray, style: BorderStyle.solid, width: 1)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: MMSColors.lightGray,
          unselectedItemColor: MMSColors.darkGray,
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: (selectedIdx) {
            setState(() {
              if (selectedIdx == 2) {
                // open scanner for route labled scanner
                Navigator.of(context).pushNamed(AppRoutes.scanCode);
              } else {
                _currentIndex = selectedIdx;
              }
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.room_service),
              title: new Text('Recent'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              title: Text('Scan'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Account'),
            ),
          ],
        ),
      ),
    );
  }

  _onRecentTablesPressed() {
    setState(() {
      // open recent tables route
      _currentIndex = 1;
    });
  }
}
