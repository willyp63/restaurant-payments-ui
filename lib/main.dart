import 'package:flutter/material.dart';
import 'widgets/signup.widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Payments',
      theme: ThemeData(),
      home: SignUp(),
      debugShowCheckedModeBanner: false,
    );
  }
}
