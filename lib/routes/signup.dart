import 'package:flutter/material.dart';
import './home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 28);
  String userName = '';
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Sign Up'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_forward), onPressed: _onNextPressed),
        ], 
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: new Center(
          child: new TextField(
            decoration: InputDecoration(
              hintText: 'Username',
              errorText: hasError ? 'Username can\'t be empty' : null,
            ),
            onSubmitted: (String value) {
              setState(() {
                userName = value;
                hasError = userName.isEmpty;
              });
            },
          ),
        ),
      )
    );
  }

  void _onNextPressed() {
    setState(() {
      hasError = userName.isEmpty;
    });

    if (!hasError) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => Home(),
        ),
      );
    }
  }
}
