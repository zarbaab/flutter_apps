import 'package:flutter/material.dart';
import 'dart:math';
import 'bottle_selection_screen.dart';
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

class SpinBottleHomePage extends StatefulWidget {
  const SpinBottleHomePage({super.key});

  @override
  SpinBottleHomePageState createState() => SpinBottleHomePageState();
}

class SpinBottleHomePageState extends State<SpinBottleHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _angle = 0;
  final List<String> _players = [];
  final TextEditingController _nameController = TextEditingController();
  String _selectedBottle = 'assets/images/bottle1.png';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _spinBottle() {
    _controller.reset();
    _controller.forward();
  }

  void _addPlayer() {
    if (_nameController.text.isNotEmpty && _players.length < 10) {
      setState(() {
        _players.add(_nameController.text);
        _nameController.clear();
      });
    }
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
      appBar: AppBar(
        title: const Text('Spin the Bottle Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_drink), // Use a valid icon here
            onPressed: _selectBottle,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Transform.rotate(
            angle: _angle,
            child: Image.asset(_selectedBottle, width: 200),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _spinBottle,
            child: const Text('Spin the Bottle'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Enter player name',
            ),
          ),
          ElevatedButton(
            onPressed: _addPlayer,
            child: const Text('Add Player'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _players.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_players[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
