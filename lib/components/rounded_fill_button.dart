import 'package:flutter/material.dart';
import 'package:teddy_the_tracker/constants.dart';

/*
button widget used for welcome, login and sign up pages
 */

class RoundButton extends StatefulWidget {
  final String text;
  final VoidCallback onClicked;

  const RoundButton({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: mainColorList[2],
              padding: const EdgeInsets.all(20),
            ),
            onPressed: widget.onClicked,
            child: Center(
              child: Text(
                widget.text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
            ),
          ),
        )
    );
  }
}
/*return Container(
      decoration: BoxDecoration(
          color: mainColorList[2],
          borderRadius: BorderRadius.circular(50)
      ),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          widget.text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16
          ),
        ),
      ),
    );*/