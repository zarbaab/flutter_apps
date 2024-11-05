import 'package:flutter/material.dart';
import 'IconTextFile.dart';
import 'container.dart';

const activeColor = Color(0xFF1D1E33);
const deActiveColor = Color(0xFF111328);

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Color maleColor = deActiveColor;
  Color femaleColor = deActiveColor;

  void updateColor(int gender) {
    setState(() {
      if (gender == 1) {
        maleColor = activeColor;
        femaleColor = deActiveColor;
      } else if (gender == 2) {
        maleColor = deActiveColor;
        femaleColor = activeColor;
      }
    });
  }

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
                  child: GestureDetector(
                    onTap: () {
                      updateColor(1);
                    },
                    child: RepeatContainerCode(
                      color: maleColor,
                      child: RepeatTextAndIconWidget(
                        iconData: Icons.male,
                        label: 'MALE',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      updateColor(2);
                    },
                    child: RepeatContainerCode(
                      color: femaleColor,
                      child: RepeatTextAndIconWidget(
                        iconData: Icons.female,
                        label: 'FEMALE',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RepeatContainerCode(
              color: activeColor,
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
                    color: activeColor,
                    child: RepeatTextAndIconWidget(
                      iconData: Icons.fitness_center,
                      label: 'WEIGHT',
                    ),
                  ),
                ),
                Expanded(
                  child: RepeatContainerCode(
                    color: activeColor,
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
