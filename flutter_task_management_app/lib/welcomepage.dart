import 'package:flutter/material.dart';
import 'home_screen.dart';

class WelcomePage extends StatelessWidget {
  final void Function() toggleTheme; // Accept the toggleTheme function

  const WelcomePage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF355C7D), // Darkest color from your scheme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Task Manager',
              textAlign:
                  TextAlign.center, // Center-align text within its container
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFBB195), // Lightest color from your scheme
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your go-to app for managing tasks efficiently.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFF67280), // Second color from your scheme
              ),
            ),
            SizedBox(height: 40),
            Image.asset(
              'assets/img/1.png', // Path to the center picture
              height: 200,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to HomeScreen and pass toggleTheme
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(toggleTheme: toggleTheme),
                  ),
                );
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
