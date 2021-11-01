// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:auth_test/constants.dart';
import 'package:auth_test/main.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  bool isLoading;
  bool isLogged;

  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  AuthForm(
    this.submitFn,
    this.isLoading,
    this.isLogged,
  );
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  late var _isLogin = widget.isLogged;
  var _userEmail = "";
  var _userPassword = "";
  var _userUsername = "";

  void _trySubmit() {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formkey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userUsername.trim(),
        _userPassword.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        color: mainColorList[4],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: const ValueKey("email"),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Please enter a valid email address.";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'email address',
                    ),
                    onSaved: (value) {
                      _userEmail = value as String;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey("username"),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return "Please enter a valid username";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: "username"),
                      onSaved: (value) {
                        _userUsername = value as String;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey("password"),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return "Please enter a valid password of 8 or more characters.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value as String;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? "Login" : "Create account"),
                      color: mainColorList[2],
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'create new account'
                          : 'Already have an account?'),
                      textColor: mainColorList[2],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
