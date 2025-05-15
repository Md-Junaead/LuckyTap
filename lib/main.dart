import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/game_provider.dart';
import 'presentation/screens/game_screen.dart';

void main() {
  runApp(const RandomNumberGame());
}

class RandomNumberGame extends StatelessWidget {
  const RandomNumberGame({super.key});

  // flutter build apk --build-name=1.0 --build-number=1
  Apk Is Updated

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        title: 'Lucky Tap',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const GameScreen(),
      ),
    );
  }
}
