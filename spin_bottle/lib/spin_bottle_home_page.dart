import 'package:flutter/material.dart';
import 'dart:math';
import 'bottle_selection_screen.dart'; // Ensure this import is correct

class SpinBottleHomePage extends StatefulWidget {
  final int numberOfPlayers;
  final String selectedBottle; // Add this parameter to pass the selected bottle

  const SpinBottleHomePage(
      {super.key, required this.numberOfPlayers, required this.selectedBottle});

  @override
  SpinBottleHomePageState createState() => SpinBottleHomePageState();
}

class SpinBottleHomePageState extends State<SpinBottleHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _angle = 0;
  late String _selectedBottle;
  List<String> _players = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Increase speed
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _angle = _animation.value * 2 * pi;
        });
      });

    // Initialize players
    _players =
        List.generate(widget.numberOfPlayers, (index) => 'Player ${index + 1}');
    _selectedBottle = widget.selectedBottle; // Initialize selected bottle
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spinBottle() {
    final random = Random();
    final randomAngle =
        random.nextDouble() * 2 * pi; // Randomize spin direction
    _controller.reset();
    _controller.forward(from: 0).whenComplete(() {
      setState(() {
        _angle = randomAngle;
      });
    });
  }

  void _selectBottle() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BottleSelectionScreen(
          onBottleSelected: (bottle) {
            setState(() {
              _selectedBottle = bottle;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 25, 48, 82), // Set background color
      appBar: AppBar(
        title: const Text(
          'Spin the Bottle Game',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            const Color.fromARGB(255, 219, 216, 7), // Set app bar color
        actions: [
          IconButton(
            icon: const Icon(Icons.local_drink), // Use a valid icon here
            onPressed: _selectBottle,
          ),
        ],
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: _angle,
              child: Image.asset(_selectedBottle,
                  width: 200), // Use logical properties if needed
            ),
            ..._buildPlayerPositions(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _spinBottle,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  List<Widget> _buildPlayerPositions() {
    final double radius =
        150; // Radius of the circle where players will be positioned
    final double angleStep = 2 * pi / _players.length;

    return List.generate(_players.length, (index) {
      final double angle = index * angleStep;
      final double x = radius * cos(angle);
      final double y = radius * sin(angle);

      return Positioned(
        left: x + MediaQuery.of(context).size.width / 2 - 20, // Adjust position
        top: y + MediaQuery.of(context).size.height / 2 - 20, // Adjust position
        child: Text(
          _players[index],
          style: const TextStyle(color: Colors.white),
        ),
      );
    });
  }
}
