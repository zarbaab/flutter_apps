import 'package:flutter/material.dart';
import 'spin_bottle_home_page.dart';

class PlayerSelectionScreen extends StatefulWidget {
  final String selectedBottle;

  const PlayerSelectionScreen({super.key, required this.selectedBottle});

  @override
  PlayerSelectionScreenState createState() => PlayerSelectionScreenState();
}

class PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  final List<String> _players = [];
  final TextEditingController _nameController = TextEditingController();

  void _addPlayer() {
    if (_nameController.text.isNotEmpty && _players.length < 10) {
      setState(() {
        _players.add(_nameController.text);
        _nameController.clear();
      });
    }
  }

  void _addDefaultPlayers() {
    if (_players.isEmpty) {
      setState(() {
        _players.addAll([
          'Player 1',
          'Player 2',
          'Player 3',
          'Player 4',
          'Player 5',
          'Player 6',
          'Player 7',
          'Player 8',
          'Player 9',
          'Player 10'
        ]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 25, 48, 82), // Set background color
      appBar: AppBar(
        title: const Text('Select Players'),
        backgroundColor:
            const Color.fromARGB(255, 219, 216, 7), // Set app bar color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            ElevatedButton(
              onPressed: _addDefaultPlayers,
              child: const Text('Add Default Players'),
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
            ElevatedButton(
              onPressed: _players.length == 10
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpinBottleHomePage(
                            players: _players,
                            selectedBottle: widget.selectedBottle,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text('Proceed to Game'),
            ),
          ],
        ),
      ),
    );
  }
}
