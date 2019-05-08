import 'package:flutter/material.dart';
import 'widgets/signup.widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Payments',
      theme: ThemeData(
        primaryColor: Colors.blue[700],
        accentColor: Colors.blue[700],
      ),
      home: SignUp(),
      debugShowCheckedModeBanner: false,
    );
  }
}
