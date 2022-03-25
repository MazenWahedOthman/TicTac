import 'dart:math';

class Player {
  static const x = 'X';
  static const o = 'O';
  static const empty = '';
  static List<int> playerX = [];
  static List<int> playerO = [];
}

extension ContainsAll on List {
  bool containsAll(int x, int y, int z) {
    return contains(x) && contains(y) && contains(z);
  }
}

class Game {
  void playGame(int index, String activePlayer) {
    if (activePlayer == 'X')
      Player.playerX.add(index);
    else
      Player.playerO.add(index);
  }

  String checkWinner() {
    String winner = '';
    if (Player.playerX.containsAll(0, 1, 2) ||
        Player.playerX.containsAll(3, 4, 5) ||
        Player.playerX.containsAll(0, 3, 6) ||
        Player.playerX.containsAll(1, 4, 7) ||
        Player.playerX.containsAll(2, 5, 8) ||
        Player.playerX.containsAll(0, 4, 8) ||
        Player.playerX.containsAll(2, 4, 6)) winner = 'X';
    if (Player.playerO.containsAll(0, 1, 2) ||
        Player.playerO.containsAll(3, 4, 5) ||
        Player.playerO.containsAll(0, 3, 6) ||
        Player.playerO.containsAll(1, 4, 7) ||
        Player.playerO.containsAll(2, 5, 8) ||
        Player.playerO.containsAll(0, 4, 8) ||
        Player.playerO.containsAll(2, 4, 6)) winner = 'O';

    return winner;
  }

  Future<void> autoPlayer(String activePlayer) async {
    List<int> emptyCells = [];
    int index = 0;
    for (int i = 0; i < 9; i++) {
      if (!Player.playerX.contains(i) && !Player.playerO.contains(i)) {
        emptyCells.add(i);
      }
    }
    Random random = Random();
    int rand = random.nextInt(emptyCells.length);
    index = emptyCells[rand];
    playGame(index, activePlayer);
  }
}
