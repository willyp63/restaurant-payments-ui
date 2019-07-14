import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../constants/app-routes.constants.dart';

class MMSHomeScreen extends StatelessWidget {
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 36),
              child: Text('Scan code', style: Theme.of(context).textTheme.headline),
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: InkWell(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: MMSColors.white,
                    border: Border.all(color: MMSColors.gray, width: 1, style: BorderStyle.solid),
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
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: MMSColors.warmGray, style: BorderStyle.solid, width: 1)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: MMSColors.lightGray,
          unselectedItemColor: MMSColors.darkGray,
          elevation: 0,
          currentIndex: 0,
          onTap: (selectedIdx) {
            // TODO
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
