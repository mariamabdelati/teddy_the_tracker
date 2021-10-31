// ignore_for_file: prefer_const_constructors

import 'package:auth_test/widgets/welcome/body.dart';
import 'package:flutter/material.dart';
import 'package:auth_test/constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColorList[0],
      // backgroundColor: Color.fromARGB(250, 254, 214, 83),
      body: Body(),
    );
  }
}
