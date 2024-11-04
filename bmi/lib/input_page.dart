import 'package:flutter/material.dart';

class InputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: RepeatContainerCode(
                    color: Color(0xFF1D1E33),
                    child: RepeatTextAndIconWidget(
                      iconData: Icons.male,
                      label: 'MALE',
                    ),
                  ),
                ),
                Expanded(
                  child: RepeatContainerCode(
                    color: Color(0xFF1D1E33),
                    child: RepeatTextAndIconWidget(
                      iconData: Icons.female,
                      label: 'FEMALE',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RepeatContainerCode(
              color: Color(0xFF1D1E33),
              child: RepeatTextAndIconWidget(
                iconData: Icons.height,
                label: 'HEIGHT',
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: RepeatContainerCode(
                    color: Color(0xFF1D1E33),
                    child: RepeatTextAndIconWidget(
                      iconData: Icons.fitness_center,
                      label: 'WEIGHT',
                    ),
                  ),
                ),
                Expanded(
                  child: RepeatContainerCode(
                    color: Color(0xFF1D1E33),
                    child: RepeatTextAndIconWidget(
                      iconData: Icons.accessibility,
                      label: 'AGE',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
