import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import '../../components/rounded_fill_button.dart';
import '../../components/rounded_outlined_button.dart';
import '../../components/success_dialog.dart';
import '../../screens/registration/auth_screen.dart';

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
        title: const Text("Verify Your Email"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 15.0),
                    child: Text(
                      _isLogin
                          ? "Email Verification is needed \n before using Teddy \n to track your expenses"
                          : "A verification link has been sent to your email",
                      style: TextStyle(fontSize: 20, color: mainColorList[2]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
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
                  text: _isLogin? "Send Verification Email" : "Send Verification Email Again",
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
                  const SizedBox(height: 12),
                  const Text(
                    'Success!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "A verification link has been sent to your email",
                    textAlign: TextAlign.center,
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
