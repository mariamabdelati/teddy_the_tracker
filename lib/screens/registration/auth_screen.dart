// ignore_for_file: deprecated_member_use, avoid_print

<<<<<<<< HEAD:lib/screens/registration/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/dashboard/dashboard_navbar.dart';
import '../../screens/welcome/welcome_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen(this._isLogin);
========
import 'package:teddy_the_tracker/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teddy_the_tracker/constants.dart';
import 'package:teddy_the_tracker/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen(this._isLogin);
>>>>>>>> 161991911ed4ab27b25a9a037201abb4b04b33d9:lib/screens/auth_screen.dart
  final bool _isLogin;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthForm(
      String email,
      String username,
      String password,
      bool isLogin,
      BuildContext ctx,
      ) async {
    //auth logic is here;
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          "username": username,
          "email": email,
        });

        // create wallet(uid) DON'T FORGET IT OR MARIAM WILL KILL YOU
      }
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
<<<<<<<< HEAD:lib/screens/registration/auth_screen.dart
              (route) => false);
========
          (route) => false);
>>>>>>>> 161991911ed4ab27b25a9a037201abb4b04b33d9:lib/screens/auth_screen.dart
    } on FirebaseAuthException catch (err) {
      var msg = "Error occurred, please check your credentials";

      if (err.message != null) {
        msg = err.message as String;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err.runtimeType);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<<< HEAD:lib/screens/registration/auth_screen.dart
      backgroundColor: Theme.of(context).primaryColor,
      body: LoginPage(
========
      backgroundColor: mainColorList[0],
      body: AuthForm(
>>>>>>>> 161991911ed4ab27b25a9a037201abb4b04b33d9:lib/screens/auth_screen.dart
        _submitAuthForm,
        _isLoading,
        widget._isLogin,
      ),
    );
  }
}

// storing Extra user data 5:35;
