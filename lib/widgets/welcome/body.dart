// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:teddy_the_tracker/components/rounded_button.dart';
import 'package:teddy_the_tracker/constants.dart';
import 'package:teddy_the_tracker/screens/auth_screen.dart';
import 'package:teddy_the_tracker/widgets/welcome/background.dart';
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
              onClicked: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => (AuthScreen(true)),
                  ),
                );
              },
              textColor: Colors.white,
            ),
            RoundedButton(
              text: 'Register',
              onClicked: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AuthScreen(false)));
              },
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
