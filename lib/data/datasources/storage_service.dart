// import 'package:shared_preferences/shared_preferences.dart';
// import '../../domain/models/game_state.dart';
// import '../repositories/storage_repository.dart';

// class StorageService implements StorageRepository {
//   static const String _pointsKey = 'points';
//   static const String _levelKey = 'level';

//   @override
//   Future<void> saveGameState(GameState state) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(_pointsKey, state.points);
//     await prefs.setInt(_levelKey, state.level);
//   }

//   @override
//   Future<GameState> loadGameState() async {
//     final prefs = await SharedPreferences.getInstance();
//     int points = prefs.getInt(_pointsKey) ?? 0;
//     int level = prefs.getInt(_levelKey) ?? 1;
//     return GameState(points: points, level: level);
//   }

//   @override
//   Future<void> clearGameState() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_pointsKey);
//     await prefs.remove(_levelKey);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/game_state.dart';
import '../repositories/storage_repository.dart';

class StorageService implements StorageRepository {
  static const String _pointsKey = 'points';
  static const String _levelKey = 'level';
  static const String _audioEnabledKey = 'audio_enabled';

  @override
  Future<void> saveGameState(GameState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, state.points);
    await prefs.setInt(_levelKey, state.level);
  }

  @override
  Future<GameState> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    int points = prefs.getInt(_pointsKey) ?? 0;
    int level = prefs.getInt(_levelKey) ?? 1;
    return GameState(points: points, level: level);
  }

  @override
  Future<void> clearGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pointsKey);
    await prefs.remove(_levelKey);
  }

  @override
  Future<void> saveAudioEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_audioEnabledKey, isEnabled);
  }

  @override
  Future<bool> loadAudioEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_audioEnabledKey) ?? true; // Default: audio enabled
  }
}
