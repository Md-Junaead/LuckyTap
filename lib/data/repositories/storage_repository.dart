import '../../domain/models/game_state.dart';

abstract class StorageRepository {
  Future<void> saveGameState(GameState state);
  Future<GameState> loadGameState();
  Future<void> clearGameState();
}
