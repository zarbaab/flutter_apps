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
  Gender? selectGender;

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
                      selectGender = Gender.male;
                    },
                    child: RepeatContainerCode(
                      color: selectGender == Gender.male
                          ? activeColor
                          : deActiveColor,
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
                      selectGender = Gender.female;
                    },
                    child: RepeatContainerCode(
                      color: selectGender == Gender.female
                          ? activeColor
                          : deActiveColor,
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
