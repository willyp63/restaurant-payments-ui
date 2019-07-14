import 'package:flutter/material.dart';

import '../../shared/button.widget.dart';
import '../../shared/text-field.widget.dart';
import '../../shared/form-template.widget.dart';
import '../../../constants/app-routes.constants.dart';

class MMSSignupScreen extends StatefulWidget {
  @override
  _MMSSignupScreenState createState() => _MMSSignupScreenState();
}

class _MMSSignupScreenState extends State<MMSSignupScreen> {
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
            label: 'phone number',
            obscureText: true,
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
          margin: EdgeInsets.only(top: 20),
          child: MMSTextField(
            label: 'retype password',
            obscureText: true,
            onChanged: (String value) {
              // TODO
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: MMSButton(
            text: 'Let\'s Go',
            onPressed: () {
              // TODO
              setState(() {
                _isLoading = true;
              });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: MMSButton(
            type: MMSButtonType.Link,
            text: 'Sign in',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
          ),
        ),
      ],
    );
  }
}
