class GameState {
  int points;
  int level;

  GameState({this.points = 0, this.level = 1});

  void addPoints(int newPoints) {
    points += newPoints;
    if (points >= level * 10000) {
      level++;
    }
  }
}
