import 'package:flutter/material.dart';

import './home.widget.dart';
import '../models/input-field.model.dart';
import '../models/user.model.dart';
import '../services/user.service.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  InputFieldModel _firstName = new InputFieldModel(value: '');
  InputFieldModel _lastName = new InputFieldModel(value: '');
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // attempt to load user from local storage, and skip signin
    UserService.loadStoredUser().then((didFindUser) {
      if (didFindUser) { _goToHome(); }
      else { setState(() { _isLoading = false; }); }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => Home(),
      ),
    );
  }
}
