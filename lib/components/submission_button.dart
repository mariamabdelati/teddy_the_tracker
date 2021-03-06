import 'package:flutter/material.dart';
//import '../../constants.dart';

/*
button widget used for submitting forms
 */

class SubmitButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const SubmitButtonWidget({
    required this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClicked,
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFF164CC4),
        padding: const EdgeInsets.all(15),
        shape: const CircleBorder(),
      ), child: const Icon(Icons.arrow_forward_rounded,
      color: Colors.white,
      size: 30,),
    );
  }
}


