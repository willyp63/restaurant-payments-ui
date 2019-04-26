import 'package:flutter/material.dart';
import './qr-reader.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.list), onPressed: _onMenuPressed),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.person), onPressed: _onProfilePressed),
        ], 
      ),
      body: Container(
        child: new Center(
          child: new RaisedButton(
            child: new Text('Scan QR', style: _biggerFont),
            onPressed: _onScanQRPressed,
          ),
        ),
      )
    );
  }

  void _onMenuPressed() {
    // TODO
  }

  void _onProfilePressed() {
    // TODO
  }

  void _onScanQRPressed() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => QRReader(),
      ),
    );
  }
}
