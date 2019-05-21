import 'package:flutter/material.dart';

import '../../models/index.dart';
import '../../constants/index.dart';
import '../../services/index.dart';
import '../shared/index.dart';

class MMSSignUp extends StatefulWidget {
  @override
  _MMSSignUpState createState() => _MMSSignUpState();
}

class _MMSSignUpState extends State<MMSSignUp> {
  InputFieldModel _firstName = new InputFieldModel(value: '');
  InputFieldModel _lastName = new InputFieldModel(value: '');
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // attempt to load user from local storage and skip signup
    UserService.loadStoredUser().then((didFindUser) {
      if (didFindUser) { _goToHome(); }
      else { setState(() { _isLoading = false; }); }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) { return MMSFullPageSpinner(); }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_forward), onPressed: _onNextPressed),
        ], 
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Center(
          child: _buildInputFields(),
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 24),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'First Name',
                errorText: _firstName.hasError ? 'Can\'t be empty' : null,
              ),
              onChanged: (String value) {
                setState(() {
                  _firstName.value = value;
                  _firstName.hasError = value.isEmpty;
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 24),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Last Name',
                errorText: _lastName.hasError ? 'Can\'t be empty' : null,
              ),
              onChanged: (String value) {
                setState(() {
                  _lastName.value = value;
                  _lastName.hasError = value.isEmpty;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onNextPressed() {
    setState(() {
      _firstName.hasError = _firstName.value.isEmpty;
      _lastName.hasError = _lastName.value.isEmpty;

      if (!_firstName.hasError && !_lastName.hasError) {
        _isLoading = true;

        final user = new UserModel(firstName: _firstName.value, lastName: _lastName.value);
        final password = '123';

        UserService.signUpUser(user, password).then((insertedUser) {
          _isLoading = false;
          _goToHome();
        });
      }
    });
  }

  void _goToHome() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }
}
