import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
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
  String _lastQuote = 'Tap to start!';
  final StorageService _storageService = StorageService();
  bool _isLoading = true;
  String _currentTime = '';
  Timer? _timer;
  bool _hasTimeError = false;

  @override
  void initState() {
    super.initState();
    _loadGameState();
    _updateTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadGameState() async {
    _gameState = await _storageService.loadGameState();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateTime() async {
    try {
      final String timezone = await FlutterNativeTimezone.getLocalTimezone();
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('MMMM d, yyyy, h:mm a');
      final String formattedTime = formatter.format(now);
      setState(() {
        _currentTime = formattedTime;
        _hasTimeError = false;
      });
    } catch (e) {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('MMMM d, yyyy, h:mm a');
      setState(() {
        _currentTime = formatter.format(now); // Fallback
        _hasTimeError = true;
      });
    }
  }

  void _generateNumber() {
    final result = RandomGenerator.generateNumberAndQuote();
    setState(() {
      _lastNumber = result['number'];
      _lastQuote = result['quote'];
      _gameState.addPoints(_lastNumber);
      _storageService.saveGameState(_gameState);
    });
  }

  void _resetGame() {
    setState(() {
      _gameState = GameState(points: 0, level: 1);
      _lastNumber = 0;
      _lastQuote = 'Tap to start!';
      _storageService.clearGameState();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.red, width: 2.0)),
          ),
          child: const Text(
            'Lucky Tap',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: FlutterNativeTimezone.getLocalTimezone(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        'Loading time...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (snapshot.hasError || _hasTimeError) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        _currentTime.isEmpty
                            ? 'Failed to load time'
                            : _currentTime,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      _currentTime.isEmpty ? 'Loading time...' : _currentTime,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              Text(
                'Number: $_lastNumber',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '"$_lastQuote"',
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              NumberButton(onPressed: _generateNumber),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _resetGame,
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Reset Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
