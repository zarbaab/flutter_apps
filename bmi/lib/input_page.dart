import 'package:flutter/material.dart';
import 'IconTextFile.dart';
import 'container.dart';

const activeColor = Color(0xFF1D1E33);
const deActiveColor = Color(0xFF111328);

enum Gender {
  male,
  female,
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Color maleColor = deActiveColor;
  Color femaleColor = deActiveColor;

  void updateColor(Gender gendertype) {
    setState(() {
      if (gendertype == Gender.male) {
        maleColor = activeColor;
        femaleColor = deActiveColor;
      } else if (gendertype == Gender.female) {
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
          // Gender selection row
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      updateColor(Gender.male);
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
                      updateColor(Gender.female);
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
          // Empty widget for Height
          Expanded(
            child: RepeatContainerCode(
              color: Color(0xFF1D1E33),
              child: Container(), // Empty container as placeholder
            ),
          ),
          // Empty row for Weight and Age
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: RepeatContainerCode(
                    color: Color(0xFF1D1E33),
                    child: Container(), // Empty container as placeholder
                  ),
                ),
                Expanded(
                  child: RepeatContainerCode(
                    color: Color(0xFF1D1E33),
                    child: Container(), // Empty container as placeholder
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
