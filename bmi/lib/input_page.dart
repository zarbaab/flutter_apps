import 'package:flutter/material.dart';
import 'IconTextFile.dart'; // Ensure this file contains the RepeatTextAndIconWidget
import 'container.dart';
import 'constant.dart'; // Import the constants file

int height = 170; // Default height

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'HEIGHT',
                    style: kLabelStyle, // Applied kLabelStyle here
                  ),
                  const SizedBox(height: 15.0), // Space below the label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        height.toString(), // Display current height
                        style: const TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                          width: 5.0), // Space between number and "cm"
                      const Text(
                        'cm',
                        style: kLabelStyle, // Applied kLabelStyle here
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: const Color(0xFF8D8E98),
                      thumbColor: const Color(0xFFEB1555),
                      overlayColor: const Color(0x29EB1555), // 16% opacity
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 15.0),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 30.0),
                    ),
                    child: Slider(
                      value: height.toDouble(),
                      min: 120.0,
                      max: 220.0,
                      onChanged: (double newValue) {
                        setState(() {
                          height = newValue.round();
                        });
                      },
                    ),
                  ),
                ],
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
                    child: Center(
                      child: Text(
                        'WEIGHT',
                        style: kLabelStyle, // Applied kLabelStyle here
                      ),
                    ),
                  ),
                ),
                // Age container
                Expanded(
                  child: RepeatContainerCode(
                    color: const Color(0xFF1D1E33),
                    onPressed: () {}, // Placeholder callback
                    child: Center(
                      child: Text(
                        'AGE',
                        style: kLabelStyle, // Applied kLabelStyle here
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
