import 'package:flutter/material.dart';
import 'spin_bottle_home_page.dart';

class PlayerSelectionScreen extends StatefulWidget {
  final String selectedBottle; // Add this parameter to pass the selected bottle

  const PlayerSelectionScreen({super.key, required this.selectedBottle});

  @override
  _PlayerSelectionScreenState createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  int? _selectedPlayers;

  void _selectPlayers(int players) {
    setState(() {
      _selectedPlayers = players;
    });
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
            const Text(
              'Select Number of Players',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: List.generate(12, (index) {
                return ChoiceChip(
                  label: Text(
                    '${index + 1}',
                    style: const TextStyle(
                        color:
                            Color.fromARGB(255, 25, 48, 82)), // Set text color
                  ),
                  selected: _selectedPlayers == index + 1,
                  onSelected: (selected) {
                    _selectPlayers(index + 1);
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedPlayers != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpinBottleHomePage(
                            numberOfPlayers: _selectedPlayers!,
                            selectedBottle: widget
                                .selectedBottle, // Pass the selected bottle
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
