import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const RandomNumberGame());
}

class RandomNumberGame extends StatelessWidget {
  const RandomNumberGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Number Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GameScreen(),
    );
  }
}
