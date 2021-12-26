import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teddy_the_tracker/components/rounded_fill_button.dart';
import 'package:teddy_the_tracker/components/rounded_outlined_button.dart';
import 'package:teddy_the_tracker/components/success_dialog.dart';
import 'package:teddy_the_tracker/screens/registration/auth_screen.dart';

class Verify extends StatefulWidget {
  final bool isLogin;
  final FirebaseAuth mauth;
  const Verify({Key? key, required bool this.isLogin, required this.mauth})
      : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool _isLogin = false;
  late FirebaseAuth _mauth;
  @override
  void initState() {
    // TODO: implement initState
    _isLogin = widget.isLogin;
    _mauth = widget.mauth;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        title: Title(color: Colors.green, child: Text("Hello")),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _isLogin
                        ? "You need to verify your email before using Teddy to track your expenses"
                        : "Check your email, a verification email has been sent",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
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
                        height: (MediaQuery.of(context).size.height * 0.3),
                        width: (MediaQuery.of(context).size.width * 0.5),
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
                    _mauth.currentUser!.sendEmailVerification().then((_) {
                      buildSuccessDialog(context);
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => AuthScreen(true)),
                          (route) => false);
                      ;
                    });
                  },
                  child: const RoundOutlinedButton(
                    text: "Back to Welcome Page",
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void buildSuccessDialog(BuildContext context) {
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
                  const Text(
                    "A verification email has been sent to your email",
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
}
