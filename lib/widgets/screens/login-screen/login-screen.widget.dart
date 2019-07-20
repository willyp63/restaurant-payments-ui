import 'package:flutter/material.dart';

import 'package:restaurant_payments_ui/constants/app-routes.constants.dart';
import 'package:restaurant_payments_ui/services/user.service.dart';
import 'package:restaurant_payments_ui/utils/forms/index.dart';
import 'package:restaurant_payments_ui/widgets/shared/index.dart';
import 'package:restaurant_payments_ui/widgets/templates/index.dart';

class MMSLoginInputNames {
  static String email = 'email';
  static String password = 'password';
}

class MMSLoginScreen extends StatefulWidget {
  @override
  _MMSLoginScreenState createState() => _MMSLoginScreenState();
}

class _MMSLoginScreenState extends State<MMSLoginScreen> {
  MMSFormController _form = new MMSFormController(
    inputs: {
      MMSLoginInputNames.email: new MMSInputController<String>(
        value: '',
        validators: [requiredValidator],
      ),
      MMSLoginInputNames.password: new MMSInputController<String>(
        value: '',
        validators: [requiredValidator],
      ),
    },
    errorDictionary: errorDictionary,
  );

  bool _isLoading = false;
  bool _hasFailedLogin = false;

  @override
  Widget build(BuildContext context) {
    return MMSFormTemplate(
      isLoading: _isLoading,
      children: <Widget>[
        _buildFailedLoginMessage(context),
        Container(
          child: MMSTextField(
            label: 'email address',
            errorText: _form.errorMessages[MMSLoginInputNames.email],
            onChanged: (String value) {
              setState(() { _form.setValue({ MMSLoginInputNames.email: value }); });
            },
            onBlur: () {
              setState(() { _form.markAsDirty(MMSLoginInputNames.email); });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: MMSTextField(
            label: 'password',
            obscureText: true,
            errorText: _form.errorMessages[MMSLoginInputNames.password],
            onChanged: (String value) {
              setState(() { _form.setValue({ MMSLoginInputNames.password: value }); });
            },
            onBlur: () {
              setState(() { _form.markAsDirty(MMSLoginInputNames.password); });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 24),
          child: MMSButton(
            text: 'Sign in',
            onPressed: _onLoginPressed,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 24),
          child: MMSButton(
            type: MMSButtonType.Link,
            text: 'Forgot password?',
            onPressed: _onForgotPasswordPressed,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: MMSButton(
            type: MMSButtonType.Link,
            text: 'Create an Account',
            onPressed: _onSignupPressed,
          ),
        ),
      ],
    );
  }

  Widget _buildFailedLoginMessage(BuildContext context) {
    if (!_hasFailedLogin) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Text(
        'There was a problem with your login.',
        style: Theme.of(context).textTheme.body2.merge(TextStyle(color: Colors.red)),
      ),
    );
  }

  _onForgotPasswordPressed() {
    // TODO
  }

  _onSignupPressed() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.signUp);
  }

  _onLoginPressed() {
    setState(() {
      _form.validate();

      if (_form.isValid) {
        _isLoading = true;

        UserService.loginUser(
          _form.value[MMSLoginInputNames.email],
          _form.value[MMSLoginInputNames.password],
        )
        // login success
        .then((insertedUser) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
        })
        // login attempt failed
        .catchError((e) {
          setState(() {
            _isLoading = false;
            _hasFailedLogin = true;
          });
        });
      }
    });
  }
}
