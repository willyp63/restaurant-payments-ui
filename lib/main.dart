import 'package:flutter/material.dart';

import './theme/app-theme.dart';
import './constants/index.dart';

import './widgets/screens/auto-login-screen/auto-login-screen.widget.dart';
import './widgets/screens/welcome-screen/welcome-screen.widget.dart';
import './widgets/screens/login-screen/login-screen.widget.dart';
import './widgets/screens/signup-screen/signup-screen.widget.dart';
import './widgets/screens/home-screen/home-screen.widget.dart';
import './widgets/screens/home-screen/account/account-personal/account-personal.widget.dart';
import './widgets/screens/home-screen/account/account-payments/account-payments.widget.dart';
import './widgets/screens/scan-code-screen/scan-code-screen.widget.dart';
import './widgets/screens/table-screen/table-screen.widget.dart';
import './widgets/screens/payment-confirmation-screen/payment-confirmation-screen.widget.dart';
import './widgets/screens/payment-screen/payment-screen.widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mimos',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.autoLogin,
      routes: {
        AppRoutes.autoLogin: (_) => MMSAutoLoginScreen(),
        AppRoutes.welcome: (_) => MMSWelcomeScreen(),
        AppRoutes.signUp: (_) => MMSSignupScreen(),
        AppRoutes.login: (_) => MMSLoginScreen(),
        AppRoutes.home: (_) => MMSHomeScreen(),
        AppRoutes.accountPayments: (_) => MMSAccountPaymentsScreen(),
        AppRoutes.accountPersonal: (_) => MMSAccountPersonalScreen(),
        AppRoutes.scanCode: (_) => MMSScanCodeScreen(),
        AppRoutes.paymentConfirmation: (_) => MMSPaymentConfirmationScreen(),
      },
      onGenerateRoute: _onGenerateRoute,
    );
  }

  MaterialPageRoute _onGenerateRoute(RouteSettings settings) {
    // table route
    if (settings.name == AppRoutes.table) {
      final MMSTableScreenArguments args = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => MMSTableScreen(tableId: args.tableId),
      );
    }

    // table route
    if (settings.name == AppRoutes.payment) {
      final MMSPaymentScreenArguments args = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => MMSPaymentScreen(table: args.table, items: args.items),
      );
    }
  }
}
