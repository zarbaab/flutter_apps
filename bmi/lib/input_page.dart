import 'package:flutter/material.dart';
import 'IconTextFile.dart';
import 'container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
