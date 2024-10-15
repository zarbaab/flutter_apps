import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
// Import for rootBundle

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FrontPage(),
    );
  }
}

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  FrontPageState createState() => FrontPageState();
}

class FrontPageState extends State<FrontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 50,
            ),
            const SizedBox(width: 7),
            const Text(
              'Xylophone by Zarbaab',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'ComicSans',
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.pink[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/kid.png',
              width: 1600,
              height: 250,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const XylophonePage()),
                );
              },
              child: const Text('Let\'s Play'),
            ),
          ],
        ),
      ),
    );
  }
}

class XylophonePage extends StatefulWidget {
  const XylophonePage({super.key});

  @override
  XylophonePageState createState() => XylophonePageState();
}

class XylophonePageState extends State<XylophonePage> {
  final List<Color> _keyColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  final List<String> _keyNames = [
    'Do',
    'Re',
    'Mi',
    'Fa',
    'Sol',
    'La',
    'Ti',
  ];

  final List<int> _soundNumbers = [1, 2, 3, 4, 5, 6, 7];
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSound(int soundNumber) {
    final player = AudioCache(prefix: 'assets/sounds/');
    player.play('note$soundNumber.wav');
  }

  void _playSoundFromFile(String filePath) async {
    await _audioPlayer.stop(); // Stop any currently playing sound
    await _audioPlayer.play(filePath, isLocal: true);
    debugPrint('Playing sound from file: $filePath');
  }

  Widget _buildKey(
      {required Color color,
      required int soundNumber,
      required String keyName}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          debugPrint('$keyName pressed');
          _playSound(soundNumber);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 75.0), // Adjusted margin to decrease size
          color: color,
          child: Center(
            child: Text(
              keyName,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Xylophone by Zarbaab',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'ComicSans',
          ),
        ),
      ),
      body: Container(
        color: Colors.pink[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    _showPreRecordedSounds();
                  },
                ),
              ],
            ),
            ..._keyColors.asMap().entries.map((entry) {
              int idx = entry.key;
              Color color = entry.value;
              return _buildKey(
                  color: color,
                  soundNumber: _soundNumbers[idx],
                  keyName: _keyNames[idx]);
            }),
          ],
        ),
      ),
    );
  }

  void _showPreRecordedSounds() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a Sound'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Party'),
                onTap: () {
                  Navigator.of(context).pop();
                  _playSoundFromFile('assets/sounds/party.wav');
                },
                trailing: IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    _audioPlayer.stop();
                  },
                ),
              ),
              ListTile(
                title: const Text('Joy'),
                onTap: () {
                  Navigator.of(context).pop();
                  _playSoundFromFile('assets/sounds/joy.wav');
                },
                trailing: IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    _audioPlayer.stop();
                  },
                ),
              ),
              ListTile(
                title: const Text('Happiness'),
                onTap: () {
                  Navigator.of(context).pop();
                  _playSoundFromFile('assets/sounds/happy.wav');
                },
                trailing: IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    _audioPlayer.stop();
                  },
                ),
              ),
              ListTile(
                title: const Text('Birthday'),
                onTap: () {
                  Navigator.of(context).pop();
                  _playSoundFromFile('assets/sounds/birthday.wav');
                },
                trailing: IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    _audioPlayer.stop();
                  },
                ),
              ),
              ListTile(
                title: const Text('Funny'),
                onTap: () {
                  Navigator.of(context).pop();
                  _playSoundFromFile('assets/sounds/funny.wav');
                },
                trailing: IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    _audioPlayer.stop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
