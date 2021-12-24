import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teddy_the_tracker/screens/walletsmanagement/switch_wallet_screen.dart';

class VerificationScreen extends StatefulWidget {
  final bool isLogin;
  const VerificationScreen({Key? key, required bool this.isLogin})
      : super(key: key);

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLogin = false;
  late Timer time;
  String msg = "";
  @override
  void initState() {
    // TODO: implement initState
    user = auth.currentUser;
    user!.sendEmailVerification();
    _isLogin = widget.isLogin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if logging in:
    if (_isLogin) {
      // if verified:
      if (user != null && user!.emailVerified) {
        print("${user!.email} was verified already");
        // pushAndRemoveUntil(SwitchWallet)
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SwitchWallet()),
            (route) => false);
        // else:
      } else if (!user!.emailVerified) {
        print("${user!.email} was not verified");
        // error message to verify the account before using
        setState(() {
          msg =
              "Please verify your account before using it\nCheck your email ${user!.email}, verify your account then sign in again";
        });
        // signed out
        // FirebaseAuth.instance.signOut();
        // pop screen back to authScreen
        // Navigator.pop(context);
      }
    }
    // else:
    else {
      // send verification email
      user!.sendEmailVerification();
      print("${user!.email} was sent a verification email");
      // signout
      // FirebaseAuth.instance.signOut();
      // display screen to tell him to verify
      setState(() {
        msg =
            "A verification email has been sent to your email address ${user!.email}, please verify your account before using it";
      });
      // sleep 10 secs
      // pop screen back to authScreen
    }
    return Scaffold(
      body: Column(
        children: [
          Center(
              child: Text(
            msg,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )),
          TextButton(
              onPressed: () => user!.sendEmailVerification().then((value) {
                    setState(() {
                      msg =
                          "We have sent another email to ${user!.email}, check your emails";
                    });
                    FirebaseAuth.instance.signOut();
                    Future.delayed(const Duration(seconds: 5),
                        () => Navigator.pop(context));
                  }),
              child: const Text("Send verification email"))
        ],
      ),
    );
  }
}
