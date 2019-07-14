import 'dart:async';
import 'package:flutter/material.dart';

import '../../shared/button.widget.dart';
import '../../shared/text-field.widget.dart';
import '../../shared/form-template.widget.dart';
import '../../../constants/app-routes.constants.dart';

class MMSLoginScreen extends StatefulWidget {
  @override
  _MMSLoginScreenState createState() => _MMSLoginScreenState();
}

class _MMSLoginScreenState extends State<MMSLoginScreen> {
  bool _isLoading;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return MMSFormTemplate(
      isLoading: _isLoading,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 30),
          child: MMSTextField(
            label: 'email address',
            onChanged: (String value) {
              // TODO
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: MMSTextField(
            label: 'password',
            obscureText: true,
            onChanged: (String value) {
              // TODO
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: MMSButton(
            text: 'Sign in',
            onPressed: () {
              // TODO
              setState(() {
                _isLoading = true;
                new Timer(new Duration(milliseconds: 2000), () {
                  Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
                });
              });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: MMSButton(
            type: MMSButtonType.Link,
            text: 'Forgot password?',
            onPressed: () {
              // TODO
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: MMSButton(
            type: MMSButtonType.Link,
            text: 'Create an Account',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.signUp);
            },
          ),
        ),
      ],
    );
  }
}
