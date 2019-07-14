import 'package:flutter/material.dart';

import './theme/app-theme.dart';

import './constants/index.dart';

import 'widgets/screens/welcome-screen/welcome-screen.widget.dart';
import 'widgets/screens/login-screen/login-screen.widget.dart';
import 'widgets/screens/signup-screen/signup-screen.widget.dart';
import 'widgets/screens/home-screen/home-screen.widget.dart';
import 'widgets/screens/scan-code-screen/scan-code-screen.widget.dart';

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
        AppRoutes.welcome: (_) => MMSWelcomeScreen(),
        AppRoutes.signUp: (_) => MMSSignupScreen(),
        AppRoutes.login: (_) => MMSLoginScreen(),
        AppRoutes.home: (_) => MMSHomeScreen(),
        AppRoutes.scanCode: (_) => MMSScanCodeScreen(),
      },
    );
  }
}
