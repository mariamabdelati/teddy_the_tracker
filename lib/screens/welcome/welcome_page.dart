//import 'dart:async';
//import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
//import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/success_dialog.dart';
import '../../components/rounded_fill_button.dart';
import '../../components/rounded_outlined_button.dart';
import '../../constants.dart';

/*
this class takes 2 bool variables and a function:
1. to identify if the user is logging in
2. to identify if the app is waiting for firebase response
3. the function is used to authenticate the email, password and/or user name entered in the  login page form
 */
class RegistrationPage extends StatefulWidget {
  bool isLoading;
  bool isLogged;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  RegistrationPage(this.submitFn, this.isLoading, this.isLogged, {Key? key})
      : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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
  double _verificationYOffset = 0;
  double _verificationHeight = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  late bool _passwordVisible;

  bool _keyboardVisible = false;

  late StreamSubscription<bool> keyboardSubscription;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
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
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 270;
    _verificationHeight = windowHeight - 270;

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
        _verificationYOffset = windowHeight;
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
        _verificationYOffset = windowHeight;
        break;
      case 2:
        _backgroundColor = Color(0xFFBD34C59);
        _headingColor = Colors.white;

        _headingTop = 80;

        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.7;

        _loginYOffset = _keyboardVisible ? 30 : 240;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 240;

        _loginXOffset = 20;
        _verificationYOffset = _keyboardVisible ? 55 : 270;
        _verificationHeight =
            _keyboardVisible ? windowHeight : windowHeight - 270;
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
                buildImage(),
                buildGetStartedButton()
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
        AnimatedContainer(
          height: _verificationHeight,
          padding: EdgeInsets.all(32),
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 1000),
          transform: Matrix4.translationValues(0, _verificationYOffset, 1),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      "Verify Your Email",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    //padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/Email Verification.svg",
                          height: (windowHeight * 0.3),
                          width: (windowWidth * 0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  RoundButton(
                    text: "Send Verification Email",
                    onClicked: () {
                      buildSuccessDialog(
                          context, "Verification email was sent successfully");
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: RoundOutlinedButton(
                      text: _isLogin ? "Create New Account" : "Back to Login",
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildImage() {
    return Expanded(
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
    );
  }

  Widget buildGetStartedButton() {
    return Container(
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
              color: mainColorList[2], borderRadius: BorderRadius.circular(50)),
          child: const Center(
            child: Text(
              "Get Started",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
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

void buildSuccessDialog(BuildContext context, String msg) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedCheck(),
                SizedBox(height: 12),
                const Text(
                  'Success!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  //style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 12),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
