// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:auth_test/components/rounded_button.dart';
import 'package:auth_test/constants.dart';
import 'package:auth_test/screens/auth_screen.dart';
import 'package:auth_test/widgets/welcome/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome to Teddy The Tracker",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: mainColorList[2],
              ),
            ),
            SizedBox(
              height: size.height * 0.0,
            ),
            SvgPicture.asset(
              "assets/icons/Artboard 2.svg",
              height: (size.height * 0.5),
            ),
            SizedBox(
              height: size.height * 0.00,
            ),
            RoundedButton(
              text: 'Login',
              pressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => (AuthScreen(true)),
                  ),
                );
              },
              color: mainColorList[2],
              textColor: Colors.white,
            ),
            RoundedButton(
              text: 'Register',
              pressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AuthScreen(false)));
              },
              color: mainColorList[4],
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
