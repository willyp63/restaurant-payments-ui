import 'package:flutter/material.dart';

import './qr-reader.widget.dart';
import './past-tables.widget.dart';
import '../services/user.service.dart';
import '../utils/name.utils.dart';
import './signup.widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 28);
  final TextStyle _bigFont = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    final user = UserService.getActiveUser();

    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(formatName(user), style: _biggerFont),
              leading: Icon(Icons.person),
            ),
            Divider(),
            ListTile(
              title: Text('Sign Out', style: _bigFont),
              trailing: Icon(Icons.arrow_forward),
              onTap: _signOutUser,
            ),
            Divider(),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 24),
                  child: RaisedButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: new Text('Join Table', style: _biggerFont),
                    onPressed: _onScanQRPressed,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 24),
                  child: RaisedButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: new Text('Past Tables', style: _biggerFont),
                    onPressed: _onPastTablesPressed,
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  void _onScanQRPressed() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => QRReader(),
      ),
    );
  }

  void _onPastTablesPressed() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PastTables(),
      ),
    );
  }

  void _signOutUser() {
    UserService.signOutUser().then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => SignUp(),
        ),
      );
    }); 
  }
}
