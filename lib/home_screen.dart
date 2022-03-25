import 'package:flutter/material.dart';

import 'game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  String result = '';
  int turn = 0;
  bool gameOver = false;
  Game game = Game();
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
            child: MediaQuery.of(context).orientation == Orientation.portrait
                ? Column(
                    children: [
                      buildSwitchListTile(),
                      buildText(),
                      buildExpanded(context),
                      buildText1(),
                      buildElevatedButton(context)
                    ],
                  )
                : (Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildSwitchListTile(),
                            buildText(),
                            buildText1(),
                            buildElevatedButton(context)
                          ],
                        ),
                      ),
                      buildExpanded(context),
                    ],
                  ))));
  }

  ElevatedButton buildElevatedButton(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            activePlayer = 'X';
            result = '';
            turn = 0;
            gameOver = false;
          });
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).splashColor)),
        icon: const Icon(Icons.replay),
        label: const Text('Repeat the game'));
  }

  Text buildText1() {
    return Text(
      result,
      style: const TextStyle(fontSize: 40, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }

  Expanded buildExpanded(BuildContext context) {
    return Expanded(
        child: GridView.count(
      padding: const EdgeInsets.all(30),
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: List.generate(
          9,
          (index) => InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: gameOver ? null : () => (_OnTap(index)),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    Player.playerX.contains(index)
                        ? 'X'
                        : Player.playerO.contains(index)
                            ? 'O'
                            : '',
                    style: TextStyle(
                        color: Player.playerX.contains(index)
                            ? Colors.blue
                            : Colors.red,
                        fontSize: 52),
                  ),
                ),
              )),
    ));
  }

  Text buildText() {
    return Text(
      'It\'s $activePlayer turn'.toUpperCase(),
      style: const TextStyle(fontSize: 50, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }

  SwitchListTile buildSwitchListTile() {
    return SwitchListTile.adaptive(
      value: isSwitched,
      onChanged: (newValue) {
        setState(() {
          isSwitched = newValue;
        });
      },
      title: const Text(
        'Turn on/off two player',
        style: TextStyle(fontSize: 30, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  _OnTap(int index) async {
    if ((Player.playerX.isEmpty || (!Player.playerX.contains(index))) &&
        (Player.playerO.isEmpty || (!Player.playerO.contains(index)))) {
      game.playGame(index, activePlayer);
      updateState();
      if (!gameOver && !isSwitched && turn != 9) {
        await game.autoPlayer(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      print(turn);
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turn++;
      String winner = game.checkWinner();
      if (winner != '') {
        result = '$winner is the winner';
        gameOver = true;
      } else if (turn == 9) result = 'It\'s Draw!';
    });
  }
}
