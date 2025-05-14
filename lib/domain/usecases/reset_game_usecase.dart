import '../models/game_state.dart';

class ResetGameUseCase {
  GameState execute() {
    return GameState(points: 0, level: 1);
  }
}
