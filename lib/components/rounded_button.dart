// ignore_for_file: deprecated_member_use

//import '../../constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color textColor; //color
  const RoundedButton({
    Key? key,
    required this.text,
    required this.onClicked,
    //this.color = kPrimaryColor,
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
          onPressed: onClicked,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 40,
          ),
          //color: color,
        ),
      ),
    );
  }
}