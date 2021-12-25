// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teddy_the_tracker/screens/registration/verify.dart';
import '../../components/error_dialog.dart';
import '../../screens/dashboard/dashboard_navbar.dart';
import '../../screens/welcome/welcome_page.dart';
import '../walletsmanagement/wallet_selection_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen(this._isLogin);
  final bool _isLogin;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  //function for authentication
  void _submitAuthForm(
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    //auth logic is here;
    UserCredential authResult;
    User user;
    try {
      setState(() {
        _isLoading = true;
      });

      /*
      if it is a login attempt the function waits for firebase authentication
      otherwise, a new user is created and the username is updated
       */
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
        _auth.currentUser!.updateDisplayName(username);
      }
      user = _auth.currentUser!;
      /*
      upon successful login or signup the user is navigated to the select wallet page where
      they can join an existing wallet or create a new wallet
       */
      await user.reload();
      if (!user.emailVerified) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Verify(isLogin: isLogin, mauth: _auth)));
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SelectWallet()),
            (route) => false);
      }
    } on FirebaseAuthException catch (err) {
      var msg = "Error occurred, please check your credentials";

      if (err.message != null) {
        msg = err.message as String;
      }

      /*
      when the user enters invalid credentials they shown an error dialog detailing the error message
       */
      showErrorDialog(context, msg);

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print("error is: ${err.runtimeType}");
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: RegistrationPage(
        _submitAuthForm,
        _isLoading,
        widget._isLogin,
      ),
    );
  }
}

// storing Extra user data 5:35;

/*
error dialog function that shows the dialog and details  the message
the user can dismiss it by clicking okay
 */
void showErrorDialog(BuildContext context, String msg) {
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
                AnimatedError(),
                const SizedBox(height: 12),
                const Text(
                  'Invalid Credentials',
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
