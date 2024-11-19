import 'package:flutter/material.dart';
import 'constant.dart';

class RepeatTextAndIconWidget extends StatelessWidget {
  final IconData iconData;
  final String label;

  const RepeatTextAndIconWidget({
    super.key,
    required this.iconData,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: 80.0,
          color: Colors.white,
        ),
        const SizedBox(height: 15.0),
        Text(
          label,
          style: kLabelStyle,
        ),
      ],
    );
  }
}
