import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const DiceApp());

class DiceApp extends StatelessWidget {
  const DiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludo Blitz',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _selectedPlayers = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ludo Blitz'),
        backgroundColor:
            const Color.fromARGB(255, 216, 132, 7), // Greenish yellow color
      ),
      backgroundColor: const Color.fromARGB(255, 112, 8, 69),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/ludo.png',
                height: 100, // Adjust the height as needed
              ),
              const SizedBox(height: 13),
              const Text(
                'Welcome to Ludo Blitz',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'CosmicFusion',
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Number of Players:',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 2,
                    groupValue: _selectedPlayers,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedPlayers = value!;
                      });
                    },
                  ),
                  const Text('2 Players',
                      style: TextStyle(color: Colors.white)),
                  Radio(
                    value: 3,
                    groupValue: _selectedPlayers,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedPlayers = value!;
                      });
                    },
                  ),
                  const Text('3 Players',
                      style: TextStyle(color: Colors.white)),
                  Radio(
                    value: 4,
                    groupValue: _selectedPlayers,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedPlayers = value!;
                      });
                    },
                  ),
                  const Text('4 Players',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PlayerNameScreen(selectedPlayers: _selectedPlayers),
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerNameScreen extends StatefulWidget {
  final int selectedPlayers;

  const PlayerNameScreen({super.key, required this.selectedPlayers});

  @override
  _PlayerNameScreenState createState() => _PlayerNameScreenState();
}

class _PlayerNameScreenState extends State<PlayerNameScreen> {
  bool _useDefaultNames = true;
  List<TextEditingController> _nameControllers = [];
  bool _isOptionSelected = false;

  @override
  void initState() {
    super.initState();
    _nameControllers = List.generate(
        widget.selectedPlayers, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ludo Blitz'),
        backgroundColor:
            const Color.fromARGB(255, 216, 132, 7), // Greenish yellow color
      ),
      backgroundColor: const Color.fromARGB(255, 112, 8, 69),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/ludo-header-thumbnail.png',
                height: 250, // Adjust the height as needed
              ),
              const SizedBox(height: 13),
              const Text(
                'Add Player Names or Use Default',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _useDefaultNames = false;
                        _isOptionSelected = true;
                      });
                    },
                    child: const Text('Add Player Names'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _useDefaultNames = true;
                        _isOptionSelected = true;
                      });
                    },
                    child: const Text('Use Default Names'),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              if (!_useDefaultNames)
                Column(
                  children: List.generate(widget.selectedPlayers, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: _nameControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Player ${index + 1} Name',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    );
                  }),
                ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: _isOptionSelected
                    ? () {
                        List<String> playerNames;
                        if (_useDefaultNames) {
                          playerNames = List.generate(widget.selectedPlayers,
                              (index) => 'Player ${index + 1}');
                        } else {
                          playerNames = _nameControllers
                              .map((controller) => controller.text)
                              .toList();
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DiceScreen(playerNames: playerNames),
                          ),
                        );
                      }
                    : null,
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiceScreen extends StatefulWidget {
  final List<String> playerNames;

  const DiceScreen({super.key, required this.playerNames});

  @override
  _DiceScreenState createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> with TickerProviderStateMixin {
  List<int> _diceNumbers = [];
  List<int> _totalScores = [];
  List<bool> _isRolling = [];
  int _currentPlayer = 0;
  int _rounds = 0;
  final int _maxRounds = 3;

  final Duration _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _diceNumbers = List.generate(widget.playerNames.length, (index) => 0);
    _totalScores = List.generate(widget.playerNames.length, (index) => 0);
    _isRolling = List.generate(widget.playerNames.length, (index) => false);
  }

  void _rollDice(int player) {
    setState(() {
      _isRolling[player] = true;
      _diceNumbers[player] = Random().nextInt(6) + 1;
    });
    _resetAnimation(player);
  }

  void _resetAnimation(int player) {
    Future.delayed(_animationDuration, () {
      setState(() {
        _isRolling[player] = false;

        if (_diceNumbers[player] != 6) {
          _updateTotalScore(player);
          _currentPlayer = (_currentPlayer + 1) % widget.playerNames.length;
        } else {
          _totalScores[player] += _diceNumbers[player];
          _diceNumbers[player] = 6; // Set dice to 6 for extra turn
        }

        if (_currentPlayer == 0) {
          _rounds++;
          if (_rounds >= _maxRounds) {
            _showWinner();
          }
        }
      });
    });
  }

  void _updateTotalScore(int player) {
    _totalScores[player] += _diceNumbers[player];
  }

  void _showWinner() {
    int highestScore = _totalScores.reduce(max);
    List<String> winners = [];
    for (int i = 0; i < _totalScores.length; i++) {
      if (_totalScores[i] == highestScore) {
        winners.add(widget.playerNames[i]);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Game Over',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: Text(
            '${winners.join(', ')} is the winner!',
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 221, 236, 3),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _diceNumbers = List.generate(widget.playerNames.length, (index) => 0);
      _totalScores = List.generate(widget.playerNames.length, (index) => 0);
      _isRolling = List.generate(widget.playerNames.length, (index) => false);
      _currentPlayer = 0;
      _rounds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ludo Blitz'),
        backgroundColor:
            const Color.fromARGB(255, 216, 132, 7), // Greenish yellow color
      ),
      backgroundColor: const Color.fromARGB(255, 112, 8, 69),
      body: Center(
        child: GridView.builder(
          padding:
              const EdgeInsets.all(16.0), // Added padding to reduce overlap
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two players per row
            crossAxisSpacing: 20, // Add spacing between grid items horizontally
            mainAxisSpacing: 20, // Add spacing between grid items vertically
            childAspectRatio:
                0.85, // Adjust aspect ratio to provide more vertical space
          ),
          itemCount: widget.playerNames.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0), // Consistent padding
              child: _buildDiceColumn(
                'Rolling Number: ${_diceNumbers[index]}',
                'images/dice-${_diceNumbers[index] % 6}.png',
                _isRolling[index],
                _currentPlayer == index ? () => _rollDice(index) : null,
                '${widget.playerNames[index]} Score: ${_totalScores[index]}',
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDiceColumn(String text, String imagePath, bool isRolling,
      VoidCallback? onPressed, String scoreText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10), // Increased space
        AnimatedOpacity(
          opacity: isRolling ? 1.0 : 0.8,
          duration: _animationDuration,
          child: AnimatedScale(
            scale: isRolling ? 1.5 : 1.0,
            duration: _animationDuration,
            child: Image.asset(
              imagePath,
              height: 70,
            ),
          ),
        ),
        const SizedBox(height: 12), // Increased space
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 40), // Adjusted button size
          ),
          child: const Text('Roll the Dice'),
        ),
        const SizedBox(height: 12), // Increased space
        Text(
          scoreText,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
