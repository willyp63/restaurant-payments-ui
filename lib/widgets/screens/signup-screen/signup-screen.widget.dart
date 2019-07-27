import 'package:flutter/material.dart';

import 'package:mimos/models/user.model.dart';
import 'package:mimos/services/index.dart';
import 'package:mimos/utils/forms/index.dart';
import 'package:mimos/widgets/shared/index.dart';
import 'package:mimos/constants/index.dart';
import 'package:mimos/widgets/templates/index.dart';

class MMSSignupInputNames {
  static String email = 'email';
  static String firstName = 'firstName';
  static String lastName = 'lastName';
  static String password = 'password';
}

class MMSSignupScreen extends StatefulWidget {
  @override
  _MMSSignupScreenState createState() => _MMSSignupScreenState();
}

class _MMSSignupScreenState extends State<MMSSignupScreen> {
  MMSFormController _form = new MMSFormController(
    inputs: {
      MMSSignupInputNames.email: new MMSInputController<String>(
        value: '',
        validators: [emailValidator, requiredValidator],
      ),
      MMSSignupInputNames.firstName: new MMSInputController<String>(
        value: '',
        validators: [requiredValidator],
      ),
      MMSSignupInputNames.lastName: new MMSInputController<String>(
        value: '',
        validators: [requiredValidator],
      ),
      MMSSignupInputNames.password: new MMSInputController<String>(
        value: '',
        validators: [requiredValidator],
      ),
    },
    errorDictionary: errorDictionary,
  );

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MMSFormTemplate(
      isLoading: _isLoading,
      children: <Widget>[
        Container(
          child: MMSTextField(
            label: 'email address',
            errorText: _form.errorMessages[MMSSignupInputNames.email],
            onChanged: (String value) {
              setState(() { _form.setValue({ MMSSignupInputNames.email: value }); });
            },
            onBlur: () {
              setState(() { _form.markAsDirty(MMSSignupInputNames.email); });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: MMSTextField(
            label: 'first name',
            errorText: _form.errorMessages[MMSSignupInputNames.firstName],
            onChanged: (String value) {
              setState(() { _form.setValue({ MMSSignupInputNames.firstName: value }); });
            },
            onBlur: () {
              setState(() { _form.markAsDirty(MMSSignupInputNames.firstName); });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: MMSTextField(
            label: 'last name',
            errorText: _form.errorMessages[MMSSignupInputNames.lastName],
            onChanged: (String value) {
              setState(() { _form.setValue({ MMSSignupInputNames.lastName: value }); });
            },
            onBlur: () {
              setState(() { _form.markAsDirty(MMSSignupInputNames.lastName); });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: MMSTextField(
            label: 'password',
            obscureText: true,
            errorText: _form.errorMessages[MMSSignupInputNames.password],
            onChanged: (String value) {
              setState(() { _form.setValue({ MMSSignupInputNames.password: value }); });
            },
            onBlur: () {
              setState(() { _form.markAsDirty(MMSSignupInputNames.password); });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 24),
          child: MMSButton(
            text: 'Let\'s Go',
            onPressed: _onSignupPressed,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: MMSButton(
            type: MMSButtonType.Link,
            text: 'Sign in',
            onPressed: _onLoginPressed,
          ),
        ),
      ],
    );
  }

  _onLoginPressed() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  _onSignupPressed() {
    setState(() {
      _form.validate();

      if (_form.isValid) {
        _isLoading = true;

        final formValue = _form.value;
        final user = new UserModel(
          email: formValue[MMSSignupInputNames.email],
          firstName: formValue[MMSSignupInputNames.firstName],
          lastName: formValue[MMSSignupInputNames.lastName],
        );

        UserService.signUpUser(user, formValue[MMSSignupInputNames.password]).then((insertedUser) {
          _isLoading = false;

          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
        });
      }
    });
  }
}
