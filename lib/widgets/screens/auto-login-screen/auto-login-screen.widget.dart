import 'package:flutter/material.dart';

import 'package:mimos/constants/index.dart';
import 'package:mimos/services/index.dart';
import 'package:mimos/widgets/shared/spinner.widget.dart';

class MMSAutoLoginScreen extends StatefulWidget {
  @override
  _MMSAutoLoginScreenState createState() => _MMSAutoLoginScreenState();
}

class _MMSAutoLoginScreenState extends State<MMSAutoLoginScreen> {
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();

    UserService.getStoredUserId().then((userId) {
      if (userId == null) {
        _goToWelcomeScreen();
      } else {
        setState(() {
          _isLoading = true;
        });

        UserService.loginUserWithStoredId(userId).then((success) {
          if (success) {
            _goToHomeScreen();
          } else {
            _goToWelcomeScreen();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MMSColors.white,
      body: _isLoading ? Center(child: MMSSpinner()) : null,
    );
  }

  _goToHomeScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  _goToWelcomeScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.welcome, (route) => false);
  }
}
