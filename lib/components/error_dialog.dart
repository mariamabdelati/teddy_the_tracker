import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedError extends StatefulWidget {
  @override
  _AnimatedErrorState createState() => _AnimatedErrorState();
}

class _AnimatedErrorState extends State<AnimatedError> with TickerProviderStateMixin {
  late AnimationController scaleController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
  late Animation<double> scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  late Animation<double> checkAnimation = CurvedAnimation(parent: checkController, curve: Curves.linear);

  @override
  void initState() {
    super.initState();
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double circleSize = 80;
    double iconSize = 60;

    return Stack(
      children: [
        Center(
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              height: circleSize,
              width: circleSize,
              decoration: const BoxDecoration(
                color: Color(0xFFD32F2F),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: checkAnimation,
          axis: Axis.horizontal,
          axisAlignment: -1,
          child: Center(
            heightFactor: 1.3,
            child: Icon(CupertinoIcons.exclamationmark, color: Colors.white, size: iconSize),
          ),
        ),
      ],
    );
  }
}