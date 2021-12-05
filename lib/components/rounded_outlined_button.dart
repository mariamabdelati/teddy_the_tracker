import 'package:flutter/material.dart';
import 'package:new_merged/constants.dart';

class RoundOutlinedButton extends StatefulWidget {
  final String text;
  const RoundOutlinedButton({Key? key, required this.text}) : super(key: key);

  @override
  _RoundOutlinedButtonState createState() => _RoundOutlinedButtonState();
}

class _RoundOutlinedButtonState extends State<RoundOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: mainColorList[2],
              width: 2
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          widget.text,
          style: TextStyle(
              color: mainColorList[2],
              fontSize: 16
          ),
        ),
      ),
    );
  }
}