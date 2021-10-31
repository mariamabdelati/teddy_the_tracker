// ignore_for_file: deprecated_member_use

import 'package:auth_test/constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback pressed;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.pressed,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          onPressed: pressed,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 40,
          ),
          color: color,
        ),
      ),
    );
  }
}
