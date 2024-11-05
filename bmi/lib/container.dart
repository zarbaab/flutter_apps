import 'package:flutter/material.dart';

class RepeatContainerCode extends StatelessWidget {
  final Color color;
  final Widget child;

  const RepeatContainerCode({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      color: color,
      child: Center(child: child),
    );
  }
}
