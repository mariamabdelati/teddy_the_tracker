//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;

//import '../../constants.dart';

class RadialProgress extends StatefulWidget {
  final String balance;
  final double percentage;

  const RadialProgress(this.balance, this.percentage, {Key? key}) : super(key: key);

  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _radialProgressAnimationController;
  late Animation<double> _progressAnimation;
  final Duration fadeInDuration = const Duration(milliseconds: 500);
  final Duration fillDuration = const Duration(seconds: 2);

  double progressDegrees = 0;
  var count = 0;

  @override
  void initState() {
    super.initState();
    _radialProgressAnimationController =
        AnimationController(vsync: this, duration: fillDuration);
    _progressAnimation = Tween(begin: 0.0, end: 360.0).animate(CurvedAnimation(
        parent: _radialProgressAnimationController, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {
          progressDegrees = widget.percentage * _progressAnimation.value;
        });
      });

    _radialProgressAnimationController.forward();
  }

  @override
  void dispose() {
    _radialProgressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 162.0,
        width: 150.0,
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: AnimatedOpacity(
          opacity: progressDegrees >= 0 ? 1.0 : 0.0,
          duration: fadeInDuration,
          child: Column(
            children: <Widget>[
              const Text(
                'Balance',
                style: TextStyle(fontSize: 18.0, letterSpacing: 1.5, color: Color(0xFFFFEDEC)),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Container(
                height: 5.0,
                width: 40.0,
                decoration: const BoxDecoration(
                    color: Color(0xFFFFD2CE),
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                widget.balance,
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFFFFEDEC)),
              ),
              const SizedBox(
                height: 4.0,
              ),
              const Text(
                'IN ACCOUNT',
                style: TextStyle(
                    fontSize: 10.0, color: Color(0xFFFFD2CE), letterSpacing: 1.5),
              ),
            ],
          ),
        ),
      ),
      painter: RadialPainter(progressDegrees),
    );
  }
}

class RadialPainter extends CustomPainter {
  double progressInDegrees;

  RadialPainter(this.progressInDegrees);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paint);

    Paint progressPaint = Paint()
      ..shader = const LinearGradient(
          colors: [Color(0xFFFE6A68), Color(0xFFF6BAB5), Color(0xFFFF9E9E)])//[const Color(0xFF1D67A6), const Color(0xFF3493E3), const Color(0xFF61ADEB)])
          .createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0;

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90),
        math.radians(progressInDegrees),
        false,
        progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}