//import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
//import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/rounded_fill_button.dart';
import '../../components/rounded_outlined_button.dart';
import '../../constants.dart';

class LoginPage extends StatefulWidget {
  bool isLoading;
  bool isLogged;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  LoginPage(this.submitFn, this.isLoading, this.isLogged, {Key? key})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  late var _isLogin = widget.isLogged;
  var _userEmail = "";
  var _userPassword = "";
  var _userUsername = "";

  final _emailtext = TextEditingController();
  final _usernametext = TextEditingController();

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

  int _pageState = 0;

  var _backgroundColor = Colors.white;
  var _headingColor = mainColorList[2];

  double _headingTop = 100;

  double _loginWidth = 0;
  double _loginHeight = 0;
  double _loginOpacity = 1;

  double _loginYOffset = 0;
  double _loginXOffset = 0;
  //double _registerYOffset = 0;
  //double _registerHeight = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  late bool _passwordVisible;

  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        _keyboardVisible = visible;
      });
    });
    /*KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
          print("Keyboard State Changed : $visible");
        });
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 270;
    //_registerHeight = windowHeight - 270;

    switch (_pageState) {
      case 0:
        _backgroundColor = Colors.white;
        _headingColor = mainColorList[2];

        _headingTop = 100;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = windowHeight;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;
        //_registerYOffset = windowHeight;
        break;
      case 1:
        _backgroundColor = mainColorList[2];
        _headingColor = Colors.white;

        _headingTop = 90;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = _keyboardVisible ? 40 : 270;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;
        //_registerYOffset = windowHeight;
        break;
    }

    return Stack(
      children: <Widget>[
        AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(milliseconds: 1000),
            color: _backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _pageState = 0;
                    });
                  },
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        AnimatedContainer(
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: const Duration(milliseconds: 1000),
                          margin: EdgeInsets.only(
                            top: _headingTop,
                          ),
                          child: Text(
                            "Set Money Goals",
                            style:
                                TextStyle(color: _headingColor, fontSize: 28),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            "We make tracking your expenses easy. Join Teddy the Tracker now to manage your expenses.",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: _headingColor, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  //padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/Asset 1.svg",
                        height: (windowHeight * 0.5),
                        width: (windowWidth * 0.9),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_pageState != 0) {
                          _pageState = 0;
                        } else {
                          _pageState = 1;
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(32),
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: mainColorList[2],
                          borderRadius: BorderRadius.circular(50)),
                      child: const Center(
                        child: Text(
                          "Get Started",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
        AnimatedContainer(
          padding: const EdgeInsets.all(32),
          width: _loginWidth,
          height: _loginHeight,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 1000),
          transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(_loginOpacity),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    Form(
                        key: _formkey,
                        child: ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  _isLogin
                                      ? "Login To Continue"
                                      : "Create New Account",
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              buildEmail(),
                              const SizedBox(
                                height: 15,
                              ),
                              if (!_isLogin) buildUsername(),
                              if (!_isLogin)
                                const SizedBox(
                                  height: 15,
                                ),
                              buildPassword(),
                              const SizedBox(
                                height: 15,
                              ),
                              //const InputWithIcon(icon: Icons.vpn_key, hint: "Enter Password...",),
                            ])),
                  ],
                ),
                Column(
                  children: <Widget>[
                    if (widget.isLoading) const CircularProgressIndicator(),
                    if (!widget.isLoading)
                      RoundButton(
                        text: _isLogin ? "Login" : "Create Account",
                        onClicked: _trySubmit,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (!widget.isLoading)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: RoundOutlinedButton(
                          text:
                              _isLogin ? "Create New Account" : "Back to Login",
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildEmail() {
    return TextFormField(
      controller: _emailtext,
      focusNode: FocusNode(),
      decoration: InputDecoration(
        prefixIcon: SizedBox(
          width: 60,
          child: Icon(
            Icons.email,
            color: iconsColor,
          ),
        ),
        hintText: "Enter Email...",
        labelText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
        suffixIcon: SizedBox(
          width: 60,
          child: IconButton(
            icon: Icon(Icons.clear_rounded, size: 20, color: iconsColor),
            onPressed: _emailtext.clear,
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty || !value.contains("@")) {
          return "Please enter a valid email address.";
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        _userEmail = value as String;
      },
    );
  }

  buildPassword() {
    return TextFormField(
      focusNode: FocusNode(),
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        prefixIcon: SizedBox(
          width: 60,
          child: Icon(
            Icons.vpn_key,
            color: iconsColor,
          ),
        ),
        hintText: "Enter Password...",
        labelText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
        suffixIcon: SizedBox(
          width: 60,
          child: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              // Update the state i.e. toggle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty || value.length < 8) {
          return "Please enter a valid password of 8 or more characters.";
        }
        return null;
      },
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _userPassword = value as String;
      },
    );
  }

  buildUsername() {
    return TextFormField(
      controller: _usernametext,
      focusNode: FocusNode(),
      decoration: InputDecoration(
        prefixIcon: SizedBox(
          width: 60,
          child: Icon(
            Icons.account_circle_rounded,
            color: iconsColor,
          ),
        ),
        hintText: "Enter Username...",
        labelText: "Username",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
        suffixIcon: SizedBox(
          width: 60,
          child: IconButton(
            icon: Icon(Icons.clear_rounded, size: 20, color: iconsColor),
            onPressed: _usernametext.clear,
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty || value.length < 4) {
          return "Please enter a valid username";
        }
        return null;
      },
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _userUsername = value as String;
      },
    );
  }
}
