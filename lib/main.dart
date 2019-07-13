import 'package:flutter/material.dart';

import './theme/app-theme.dart';

import './constants/index.dart';

import 'widgets/home/home.widget.dart';
import 'widgets/past-tables/past-tables.widget.dart';
import 'widgets/join-table/join-table.widget.dart';
import 'widgets/signup/signup.widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mimos',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.signUp,
      routes: {
        AppRoutes.home: (_) => MMSHome(),
        AppRoutes.pastTables: (_) => MMSPastTables(),
        AppRoutes.joinTable: (_) => MMSJoinTable(),
        AppRoutes.signUp: (_) => MMSSignUp(),
      },
    );
  }
}
