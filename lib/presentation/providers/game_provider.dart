// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../data/datasources/storage_service.dart';
// import '../../data/repositories/storage_repository.dart';
// import '../../domain/models/game_state.dart';
// import '../../domain/usecases/generate_number_usecase.dart';
// import '../../domain/usecases/reset_game_usecase.dart';

// class GameProvider extends ChangeNotifier {
//   GameState _gameState = GameState();
//   int _lastNumber = 0;
//   String _lastQuote = 'Tap to start!';
//   String _currentTime = '';
//   bool _isLoading = true;
//   Timer? _timer;

//   final StorageRepository _storageRepository;
//   final GenerateNumberUseCase _generateNumberUseCase;
//   final ResetGameUseCase _resetGameUseCase;

//   GameProvider({
//     StorageRepository? storageRepository,
//     GenerateNumberUseCase? generateNumberUseCase,
//     ResetGameUseCase? resetGameUseCase,
//   }) : _storageRepository = storageRepository ?? StorageService(),
//        _generateNumberUseCase =
//            generateNumberUseCase ?? GenerateNumberUseCase(),
//        _resetGameUseCase = resetGameUseCase ?? ResetGameUseCase() {
//     _init();
//   }

//   // Getters
//   GameState get gameState => _gameState;
//   int get lastNumber => _lastNumber;
//   String get lastQuote => _lastQuote;
//   String get currentTime => _currentTime;
//   bool get isLoading => _isLoading;

//   void _init() {
//     _loadGameState();
//     _updateTime();
//     _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateTime());
//   }

//   Future<void> _loadGameState() async {
//     _gameState = await _storageRepository.loadGameState();
//     _isLoading = false;
//     notifyListeners();
//   }

//   void _updateTime() {
//     final DateTime now = DateTime.now();
//     final DateFormat formatter = DateFormat('MMMM d, yyyy, h:mm a');
//     _currentTime = formatter.format(now);
//     notifyListeners();
//   }

//   void generateNumber() {
//     final result = _generateNumberUseCase.execute();
//     _lastNumber = result['number'];
//     _lastQuote = result['quote'];
//     _gameState.addPoints(_lastNumber);
//     _storageRepository.saveGameState(_gameState);
//     notifyListeners();
//   }

//   void resetGame() {
//     _gameState = _resetGameUseCase.execute();
//     _lastNumber = 0;
//     _lastQuote = 'Tap to start!';
//     _storageRepository.clearGameState();
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../data/datasources/storage_service.dart';
import '../../data/repositories/storage_repository.dart';
import '../../domain/models/game_state.dart';
import '../../domain/usecases/generate_number_usecase.dart';
import '../../domain/usecases/reset_game_usecase.dart';

class GameProvider extends ChangeNotifier {
  GameState _gameState = GameState();
  int _lastNumber = 0;
  String _lastQuote = 'Tap to start!';
  String _currentTime = '';
  bool _isLoading = true;
  bool _isAudioEnabled = true;
  Timer? _timer;
  final FlutterTts _tts = FlutterTts();

  final StorageRepository _storageRepository;
  final GenerateNumberUseCase _generateNumberUseCase;
  final ResetGameUseCase _resetGameUseCase;

  GameProvider({
    StorageRepository? storageRepository,
    GenerateNumberUseCase? generateNumberUseCase,
    ResetGameUseCase? resetGameUseCase,
  }) : _storageRepository = storageRepository ?? StorageService(),
       _generateNumberUseCase =
           generateNumberUseCase ?? GenerateNumberUseCase(),
       _resetGameUseCase = resetGameUseCase ?? ResetGameUseCase() {
    _init();
  }

  // Getters
  GameState get gameState => _gameState;
  int get lastNumber => _lastNumber;
  String get lastQuote => _lastQuote;
  String get currentTime => _currentTime;
  bool get isLoading => _isLoading;
  bool get isAudioEnabled => _isAudioEnabled;

  void _init() async {
    await _loadGameState();
    await _loadAudioEnabled();
    await _initTts();
    _updateTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateTime());
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(0.5); // Slightly faster for energy
    await _tts.setPitch(1.0);
  }

  Future<void> _loadGameState() async {
    _gameState = await _storageRepository.loadGameState();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadAudioEnabled() async {
    _isAudioEnabled = await _storageRepository.loadAudioEnabled();
    notifyListeners();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM d, yyyy, h:mm a');
    _currentTime = formatter.format(now);
    notifyListeners();
  }

  void generateNumber() async {
    final result = _generateNumberUseCase.execute();
    _lastNumber = result['number'];
    _lastQuote = result['quote'];
    _gameState.addPoints(_lastNumber);
    await _storageRepository.saveGameState(_gameState);

    if (_isAudioEnabled) {
      // Speak quote
      await _tts.stop(); // Stop any previous TTS
      await _tts.speak(_lastQuote);
    }

    notifyListeners();
  }

  void resetGame() async {
    _gameState = _resetGameUseCase.execute();
    _lastNumber = 0;
    _lastQuote = 'Tap to start!';
    await _storageRepository.clearGameState();
    notifyListeners();
  }

  void toggleAudio() async {
    _isAudioEnabled = !_isAudioEnabled;
    await _storageRepository.saveAudioEnabled(_isAudioEnabled);
    if (!_isAudioEnabled) {
      await _tts.stop(); // Stop TTS if audio is disabled
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tts.stop();
    super.dispose();
  }
}
