import 'package:flutter/material.dart';
import 'player_selection_screen.dart';

class BottleSelectionScreen extends StatefulWidget {
  final Function(String) onBottleSelected;

  const BottleSelectionScreen({super.key, required this.onBottleSelected});

  @override
  _BottleSelectionScreenState createState() => _BottleSelectionScreenState();
}

class _BottleSelectionScreenState extends State<BottleSelectionScreen> {
  String? _selectedBottle;

  void _selectBottle(String bottle) {
    setState(() {
      _selectedBottle = bottle;
    });
    widget.onBottleSelected(bottle);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> bottleImages = [
      'assets/images/bottle_1.png',
      'assets/images/bottle_2.png',
      'assets/images/bottle_3.png',
    ];

    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 25, 48, 82), // Set background color
      appBar: AppBar(
        title: const Text('Select a Bottle'),
        backgroundColor:
            const Color.fromARGB(255, 219, 216, 7), // Set app bar color
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: bottleImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _selectBottle(bottleImages[index]);
                  },
                  child: Image.asset(
                    bottleImages[index],
                    width: 200,
                    height: 200,
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _selectedBottle != null
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerSelectionScreen(
                          selectedBottle: _selectedBottle!,
                        ),
                      ),
                    );
                  }
                : null,
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }
}
