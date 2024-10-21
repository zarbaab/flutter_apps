import 'package:flutter/material.dart';

import 'starting_screen.dart';

void main() {
  runApp(const SpinBottleGame());
}

class SpinBottleGame extends StatelessWidget {
  const SpinBottleGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin the Bottle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const StartingScreen(),
    );
  }
}
