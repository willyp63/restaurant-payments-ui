import 'package:flutter/material.dart';
import 'routes/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Payments',
      theme: ThemeData(),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
