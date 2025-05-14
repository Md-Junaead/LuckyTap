import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  Timer? _timer;

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

  void _init() {
    _loadGameState();
    _updateTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateTime());
  }

  Future<void> _loadGameState() async {
    _gameState = await _storageRepository.loadGameState();
    _isLoading = false;
    notifyListeners();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM d, yyyy, h:mm a');
    _currentTime = formatter.format(now);
    notifyListeners();
  }

  void generateNumber() {
    final result = _generateNumberUseCase.execute();
    _lastNumber = result['number'];
    _lastQuote = result['quote'];
    _gameState.addPoints(_lastNumber);
    _storageRepository.saveGameState(_gameState);
    notifyListeners();
  }

  void resetGame() {
    _gameState = _resetGameUseCase.execute();
    _lastNumber = 0;
    _lastQuote = 'Tap to start!';
    _storageRepository.clearGameState();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
