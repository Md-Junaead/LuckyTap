import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../services/storage_service.dart';
import '../utils/random_generator.dart';
import '../widgets/number_button.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState _gameState;
  int _lastNumber = 0;
  final StorageService _storageService = StorageService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGameState();
  }

  Future<void> _loadGameState() async {
    _gameState = await _storageService.loadGameState();
    setState(() {
      _isLoading = false;
    });
  }

  void _generateNumber() {
    setState(() {
      _lastNumber = RandomGenerator.generateNumber();
      _gameState.addPoints(_lastNumber);
      _storageService.saveGameState(_gameState);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Random Number Game')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Last Number: $_lastNumber',
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              'Points: ${_gameState.points}',
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              'Level: ${_gameState.level}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            NumberButton(onPressed: _generateNumber),
          ],
        ),
      ),
    );
  }
}
