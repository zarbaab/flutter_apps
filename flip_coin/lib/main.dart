import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CoinFlipGame());
}

class CoinFlipGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CoinFlipHomePage(),
    );
  }
}

class CoinFlipHomePage extends StatefulWidget {
  @override
  _CoinFlipHomePageState createState() => _CoinFlipHomePageState();
}

class _CoinFlipHomePageState extends State<CoinFlipHomePage>
    with SingleTickerProviderStateMixin {
  String _selectedChoice = '';
  String _coinSide = '';
  int _score = 0;
  bool _isTossed = false;
  String _message = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration:
          const Duration(seconds: 1), // Adjust this duration to increase speed
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _tossCoin() {
    setState(() {
      _isTossed = true;
      _coinSide = Random().nextBool() ? 'Heads' : 'Tails';
      if (_selectedChoice == _coinSide) {
        _score++;
        _message = 'Right guess!';
      } else {
        _message = 'Bad luck, try again!';
      }
      _selectedChoice = ''; // Reset selected choice to disable the button
      _controller.forward(from: 0).then((_) {
        _controller.reverse();
      });
    });
  }

  void _resetGame() {
    setState(() {
      _selectedChoice = '';
      _coinSide = '';
      _score = 0;
      _isTossed = false;
      _message = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Coin Flip Game',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: const Color.fromARGB(255, 8, 97, 88), // Zinc color background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Heads or Tails',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Orange button color
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedChoice = 'Heads';
                    });
                  },
                  child: Text(
                    'Heads',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Orange button color
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedChoice = 'Tails';
                    });
                  },
                  child: Text(
                    'Tails',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedChoice.isEmpty
                    ? Colors.grey
                    : Colors.red, // Change color based on selection
              ),
              onPressed: _selectedChoice.isEmpty ? null : _tossCoin,
              child: Text(
                'Toss Coin',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_isTossed ? _animation.value * 2 * pi : 0)
                ..translate(0.0, _isTossed ? -_animation.value * 200 : 0),
              child: Image.asset(
                'assets/coin.png', // Add your coin image in assets
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _coinSide.isEmpty ? '' : 'Coin shows: $_coinSide',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Your Score: $_score',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Orange button color
              ),
              onPressed: _resetGame,
              child: Text(
                'Reset Game',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      _message == 'Right guess!' ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
