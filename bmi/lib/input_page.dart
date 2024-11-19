import 'package:flutter/material.dart';
import 'IconTextFile.dart'; // Ensure this file contains the RepeatTextAndIconWidget
import 'container.dart';

const activeColor = Color(0xFF1D1E33);
const deActiveColor = Color(0xFF111328);

enum Gender {
  male,
  female,
}

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Gender? selectGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI CALCULATOR'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Gender selection row
          Expanded(
            child: Row(
              children: [
                // Male container
                Expanded(
                  child: RepeatContainerCode(
                    onPressed: () {
                      setState(() {
                        selectGender = Gender.male;
                      });
                    },
                    color: selectGender == Gender.male
                        ? activeColor
                        : deActiveColor,
                    child: const RepeatTextAndIconWidget(
                      iconData: Icons.male,
                      label: 'MALE',
                    ),
                  ),
                ),
                // Female container
                Expanded(
                  child: RepeatContainerCode(
                    onPressed: () {
                      setState(() {
                        selectGender = Gender.female;
                      });
                    },
                    color: selectGender == Gender.female
                        ? activeColor
                        : deActiveColor,
                    child: const RepeatTextAndIconWidget(
                      iconData: Icons.female,
                      label: 'FEMALE',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Height placeholder
          Expanded(
            child: RepeatContainerCode(
              color: const Color(0xFF1D1E33),
              onPressed: () {}, // Placeholder callback
              child: const Center(
                child: Text(
                  'HEIGHT',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
          ),
          // Weight and Age placeholder row
          Expanded(
            child: Row(
              children: [
                // Weight container
                Expanded(
                  child: RepeatContainerCode(
                    color: const Color(0xFF1D1E33),
                    onPressed: () {}, // Placeholder callback
                    child: const Center(
                      child: Text(
                        'WEIGHT',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                // Age container
                Expanded(
                  child: RepeatContainerCode(
                    color: const Color(0xFF1D1E33),
                    onPressed: () {}, // Placeholder callback
                    child: const Center(
                      child: Text(
                        'AGE',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
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
