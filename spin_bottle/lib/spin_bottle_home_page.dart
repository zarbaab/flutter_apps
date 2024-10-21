import 'package:flutter/material.dart';
import 'dart:math';

class SpinBottleHomePage extends StatefulWidget {
  final List<String> players;
  final String selectedBottle;

  const SpinBottleHomePage({super.key, required this.players, required this.selectedBottle});

  @override
  SpinBottleHomePageState createState() => SpinBottleHomePageState();
}

class SpinBottleHomePageState extends State<SpinBottleHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _angle = 0;
  String? _selectedPlayer;
  late String _selectedBottle;
  final List<Color> playerColors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.tealAccent,
    Colors.deepOrangeAccent,
    Colors.cyanAccent,
    Colors.indigoAccent,
  ];
  final List<String> _challenges = [
    'Sing a song!',
    'Do a dance!',
    'Tell a joke!',
    'Do 10 push-ups!',
    'Impersonate someone!',
    'Make a funny face!',
    'Do a cartwheel!',
    'Run around the room!',
    'Do a silly walk!',
    'Say something nice about each player!',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _angle = _animation.value * 2 * pi;
        });
      });
    _selectedBottle = widget.selectedBottle;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spinBottle() {
    final random = Random();
    final randomAngle = random.nextDouble() * 2 * pi;
    _controller.reset();
    _controller.forward(from: 0).whenComplete(() {
      setState(() {
        _angle = randomAngle;
        int selectedPlayerIndex = (randomAngle / (2 * pi) * widget.players.length).floor() % widget.players.length;
        _selectedPlayer = widget.players[selectedPlayerIndex];
        _showChallenge(_selectedPlayer!);
      });
    });
  }

  void _showChallenge(String player) {
    final random = Random();
    final challenge = _challenges[random.nextInt(_challenges.length)];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Challenge for $player'),
          content: Text(challenge),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildPlayerPositions() {
    final double radius = 150; // Radius of the circle where players will be positioned
    final double angleStep = 2 * pi / widget.players.length;
    return List.generate(widget.players.length, (index) {
      final double angle = index * angleStep;
      final double x = radius * cos(angle);
      final double y = radius * sin(angle);
      return Positioned(
        left: x + MediaQuery.of(context).size.width / 2 - 50, // Adjust position
        top: y + MediaQuery.of(context).size.height / 2 - 150, // Adjust position
        child: Transform.rotate(
          angle: -angle, // Keep player names upright
          child: Container(
            color: playerColors[index],
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.players[index],
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 48, 82), // Set background color
      appBar: AppBar(
        title: const Text(
          'Spin the Bottle Game',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 219, 216, 7), // Set app bar color
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: _angle,
              child: Image.asset(_selectedBottle, width: 200), // Use logical properties if needed
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
}
