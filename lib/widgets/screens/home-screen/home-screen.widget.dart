import 'package:flutter/material.dart';

import 'package:restaurant_payments_ui/theme/colors.dart';

import './home/home.widget.dart';
import './account/account.widget.dart';

class MMSHomeScreen extends StatefulWidget {
  @override
  _MMSHomeScreenState createState() => _MMSHomeScreenState();
}

class _MMSHomeScreenState extends State<MMSHomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MMSHome(),
    Text('Recent'),
    Text('Receipt'),
    Text('Scan'),
    MMSAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MMSColors.babyPowder,
      appBar: AppBar(
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
      ),
      body: _children[_currentIndex],
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
              _currentIndex = selectedIdx;
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
              icon: Icon(Icons.receipt),
              title: Text('Receipt'),
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
}
