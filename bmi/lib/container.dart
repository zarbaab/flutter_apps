import 'package:flutter/material.dart';

class RepeatContainerCode extends StatelessWidget {
  final Color color;
  final Widget child;
  final VoidCallback onPressed;

  const RepeatContainerCode({
    super.key,
    required this.color,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        child: Center(child: child),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0), // Optional rounding
        ),
      ),
    );
  }
}
