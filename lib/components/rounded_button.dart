// ignore_for_file: deprecated_member_use
<<<<<<< HEAD

import 'package:auth_test/constants.dart';
=======
import 'package:teddy_the_tracker/constants.dart';
>>>>>>> 81e15421d895fbe0cc4d9b92137aceaa31319c4e
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
<<<<<<< HEAD
  final VoidCallback pressed;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.pressed,
    this.color = kPrimaryColor,
=======
  final VoidCallback onClicked;
  final Color textColor; //color,
  const RoundedButton({
    Key? key,
    required this.text,
    required this.onClicked,
    //this.color = kPrimaryColor,
>>>>>>> 81e15421d895fbe0cc4d9b92137aceaa31319c4e
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
<<<<<<< HEAD
          onPressed: pressed,
=======
          onPressed: onClicked,
>>>>>>> 81e15421d895fbe0cc4d9b92137aceaa31319c4e
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 40,
          ),
<<<<<<< HEAD
          color: color,
=======
          //color: color,
>>>>>>> 81e15421d895fbe0cc4d9b92137aceaa31319c4e
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 81e15421d895fbe0cc4d9b92137aceaa31319c4e
