import 'package:flutter/material.dart';

class RepeatTextAndIconWidget extends StatelessWidget {
  final IconData iconData;
  final String label;

  const RepeatTextAndIconWidget({
    Key? key,
    required this.iconData,
    required this.label,
  }) : super(key: key);

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
        SizedBox(height: 15.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
