import 'package:flutter/material.dart';

class InvisibleContainer extends StatefulWidget {

  final int index;
  final bool showChildContainer;
  final Function childContainer;

  const InvisibleContainer(this.index, this.showChildContainer, this.childContainer);

  @override
  State<InvisibleContainer> createState() => _InvisibleContainerState();
}

class _InvisibleContainerState extends State<InvisibleContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Visibility(
          child: Center(child: widget.childContainer(widget.index)),
          visible: widget.showChildContainer,
        )
    );
  }
}






