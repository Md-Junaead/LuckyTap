// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/game_state.dart';

// class StorageService {
//   static const String _pointsKey = 'points';
//   static const String _levelKey = 'level';

//   Future<void> saveGameState(GameState state) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(_pointsKey, state.points);
//     await prefs.setInt(_levelKey, state.level);
//   }

//   Future<GameState> loadGameState() async {
//     final prefs = await SharedPreferences.getInstance();
//     int points = prefs.getInt(_pointsKey) ?? 0;
//     int level = prefs.getInt(_levelKey) ?? 1;
//     return GameState(points: points, level: level);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

class StorageService {
  static const String _pointsKey = 'points';
  static const String _levelKey = 'level';

  Future<void> saveGameState(GameState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, state.points);
    await prefs.setInt(_levelKey, state.level);
  }

  Future<GameState> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    int points = prefs.getInt(_pointsKey) ?? 0;
    int level = prefs.getInt(_levelKey) ?? 1;
    return GameState(points: points, level: level);
  }

  // NEW: Clears all stored game data
  Future<void> clearGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pointsKey);
    await prefs.remove(_levelKey);
  }
}
