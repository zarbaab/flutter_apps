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
                      colors: Color.fromARGB(255, 181, 182, 207)),
                ),
                Expanded(
                  child: RepeatContainerCode(colors: Color(0xFF1D1E33)),
                ),
              ],
            ),
          ),
          Expanded(
            child: RepeatContainerCode(colors: Color(0xFF1D1E33)),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: RepeatContainerCode(colors: Color(0xFF1D1E33)),
                ),
                Expanded(
                  child: RepeatContainerCode(
                      colors: Color.fromARGB(255, 68, 69, 75)),
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
  RepeatContainerCode({Key? key, required this.colors}) : super(key: key);
  final Color colors;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      color: colors,
    );
  }
}
