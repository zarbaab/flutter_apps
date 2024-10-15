// import 'package:flutter/material.dart';
// import 'dart:math';
//
// void main() => runApp(DiceApp());
//
// class DiceApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Dice Roller',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       home: DiceScreen(),
//     );
//   }
// }
//
// class DiceScreen extends StatefulWidget {
//   @override
//   _DiceScreenState createState() => _DiceScreenState();
// }
//
// class _DiceScreenState extends State<DiceScreen> {
//   int _diceNumber1 = 0; // Initial dice number
//   int _diceNumber2 = 0; // Initial dice number
//   int _diceNumber3 = 0; // Initial dice number
//   int _diceNumber4 = 0; // Initial dice number
//
//   // Function to roll the dice
//   void _rollDice1() {
//     setState(() {
//       _diceNumber1 = Random().nextInt(6) + 1;
//     });
//   }
//
//   void _rollDice2() {
//     setState(() {
//       _diceNumber2 = Random().nextInt(6) + 1;
//     });
//   }
//
//   void _rollDice3() {
//     setState(() {
//       _diceNumber3 = Random().nextInt(6) + 1;
//     });
//   }
//
//   void _rollDice4() {
//     setState(() {
//       _diceNumber4 = Random().nextInt(6) + 1;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shazim Dice'),
//         backgroundColor: Color(0xFFFEFFFF),
//       ),
//       backgroundColor: Color(0xFF3AAFA9),
//       body:
//       Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     Text(
//                       'Rolling Number: $_diceNumber1',
//                       style: TextStyle(
//                           fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     Image.asset(
//                       'images/dice-$_diceNumber1.png',
//                       height: 100,
//                     ),
//                     SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: _rollDice1,
//                       child: Text(' Roll the Dice '),
//                     ),
//                   ],
//                 ),
//                 SizedBox(width: 100),
//                 Column(
//                   children: [
//                     Text(
//                       'Rolling Number: $_diceNumber2',
//                       style: TextStyle(
//                           fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     Image.asset(
//                       'images/dice-$_diceNumber2.png',
//                       height: 100,
//                     ),
//                     SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: _rollDice2,
//                       child: Text(' Roll the Dice '),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 100),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//
//               children: [
//                 Column(
//                   children: [
//                     Text(
//                       'Rolling Number: $_diceNumber3',
//                       style: TextStyle(
//                           fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     Image.asset(
//                       'images/dice-$_diceNumber3.png',
//                       height: 100,
//                     ),
//                     SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: _rollDice3,
//                       child: Text(' Roll the Dice '),
//                     ),
//                   ],
//                 ),
//                 SizedBox(width: 100),
//
//                 Column(
//                   children: [
//                     Text(
//                       'Rolling Number: $_diceNumber4',
//                       style: TextStyle(
//                           fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     Image.asset(
//                       'images/dice-$_diceNumber4.png',
//                       height: 100,
//                     ),
//                     SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: _rollDice4,
//                       child: Text(' Roll the Dice '),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
