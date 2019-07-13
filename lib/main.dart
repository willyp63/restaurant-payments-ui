import 'package:flutter/material.dart';

import './theme/app-theme.dart';

import './constants/index.dart';

import 'widgets/home/home.widget.dart';
import 'widgets/past-tables/past-tables.widget.dart';
import 'widgets/join-table/join-table.widget.dart';
import 'widgets/screens/welcome-screen/welcome-screen.widget.dart';
import 'widgets/screens/login-screen/login-screen.widget.dart';
import 'widgets/screens/signup-screen/signup-screen.widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mimos',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.home: (_) => MMSHome(),
        AppRoutes.pastTables: (_) => MMSPastTables(),
        AppRoutes.joinTable: (_) => MMSJoinTable(),
        AppRoutes.signUp: (_) => MMSSignupScreen(),
        AppRoutes.welcome: (_) => MMSWelcomeScreen(),
        AppRoutes.login: (_) => MMSLoginScreen(),
      },
    );
  }
}
