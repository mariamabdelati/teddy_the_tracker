import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HideWidget extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration time;

  const HideWidget({
    Key? key,
    required this.child,
    required this.controller,
    this.time = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Hide_widgetState createState() => Hide_widgetState();
}

class Hide_widgetState extends State<HideWidget> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  void show() {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
  }

  void hide() {
    if (isVisible) {
      setState(() {
        isVisible = false;
      });
    }
  }

  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.time,
      child: Wrap(children: [widget.child]),
      height: isVisible ? 70.0 : 0,
    );
  }
}
