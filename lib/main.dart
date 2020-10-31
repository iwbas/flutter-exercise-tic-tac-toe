import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tic tac toe',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int crossAxisCount = 3;
  List<String> gameField;
  int marked = 0;
  bool oIsNext = true;
  bool gameStopped = false;

  final Widget header = Center(
    child: Text(
      "TIK TOK TOE",
      style: TextStyle(
        fontSize: 22.0,
        fontFamily: 'BACKTO1982',
        letterSpacing: 3.0,
        color: Colors.grey.shade100,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    gameField = List.generate(crossAxisCount * crossAxisCount, (i) => '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          header,
          gameFieldWidget(),
          SizedBox(height: 36),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refresh,
            iconSize: 40,
            splashRadius: 20,
          )
        ],
      ),
      backgroundColor: Colors.grey.shade900,
    );
  }

  Widget gameFieldWidget() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 9,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: this.crossAxisCount),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => _tapped(index),
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
          child: Center(
            child: Text(
              gameField[index],
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
        ),
      ),
    );
  }

  void _tapped(int index) {
    if (gameField[index] != '' || gameStopped) return;

    setState(() {
      String player = oIsNext ? 'O' : 'X';

      gameField[index] = player;

      if (checkWinner(index) == true) {
        gameStopped = true;
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(player + " is winner winner chicken dinner"),
                ));
        return;
      }

      oIsNext = !oIsNext;
      marked++;
    });
  }

  bool checkWinner(int lastMoveIndex) {
    int i = lastMoveIndex ~/ 3;
    int j = lastMoveIndex % 3;

    String player = gameField[lastMoveIndex];

    print((i == j && checkMainDiagonal(player)));
    print((i == (crossAxisCount - j - 1) && checkSideDiagonal(player)));
    print(checkHorizontal(player, i));
    print(checkVertical(player, j));

    return (i == j && checkMainDiagonal(player)) ||
        (i == (crossAxisCount - j - 1) && checkSideDiagonal(player)) ||
        checkHorizontal(player, i) ||
        checkVertical(player, j);
  }

  bool checkMainDiagonal(String player) {
    int amount = 0;

    for (int k = 0; k < crossAxisCount; k++)
      if (gameField[k * crossAxisCount + k] == player) amount++;

    return amount == 3;
  }

  bool checkSideDiagonal(String player) {
    int amount = 0;

    for (int k = 0; k < crossAxisCount; k++) {
      int index = k * crossAxisCount + (crossAxisCount - k - 1);

      if (gameField[index] == player) amount++;
    }

    return amount == 3;
  }

  bool checkHorizontal(String player, int i) {
    int amount = 0;

    for (int k = 0; k < crossAxisCount; k++)
      if (gameField[i * crossAxisCount + k] == player) amount++;

    return amount == 3;
  }

  bool checkVertical(String player, int j) {
    int amount = 0;

    for (int k = 0; k < 3; k++) if (gameField[k * 3 + j] == player) amount++;

    return amount == 3;
  }

  void refresh() {
    setState(() {
      gameField = List.generate(crossAxisCount * crossAxisCount, (i) => '');
      marked = 0;
      oIsNext = true;
      gameStopped = false;
    });
  }
}
