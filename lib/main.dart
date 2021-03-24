import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_07_tic_tac_toe/board_tile.dart';
import 'package:flutter_07_tic_tac_toe/tile_sate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _boardState = List.filled(9, TileState.EMPTY);
  var currentTurn = TileState.CROSS;
  final navigatorKey = GlobalKey<NavigatorState>();
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: Center(
            child: Stack(
          children: [Image.asset("images/board.png"), _boardTiles()],
        )),
      ),
    );
  }

  Widget _boardTiles() {
    return Builder(builder: (context) {
      final boardDimension = MediaQuery.of(context).size.width;
      final tilesDimension = boardDimension / 3;
      return Container(
        width: boardDimension,
        height: boardDimension,
        child: Column(
            children: chunk(_boardState, 3).asMap().entries.map((entry) {
          final chunkIndex = entry.key;
          final tileStateChunk = entry.value;

          return Row(
            children: tileStateChunk.asMap().entries.map((innerEntry) {
              final innerIndex = innerEntry.key;
              final tileState = innerEntry.value;
              final tileIndex = (chunkIndex * 3) + innerIndex;

              return BoardTile(tilesDimension, tileState,
                  () => _updateTileStateForSingleIndex(tileIndex));
            }).toList(),
          );
        }).toList()),
      );
    });
  }

  void _updateTileStateForSingleIndex(int selectIndex) {
    if (_boardState[selectIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectIndex] = currentTurn;
        currentTurn = currentTurn == TileState.CROSS
            ? currentTurn = TileState.CIRCLE
            : currentTurn = TileState.CROSS;
        i++;
        print(i);
      });

      final winner = _findWinner();

      if (winner != null) {
        print("winner Is $winner");
        _showWinnerDialogue(winner);
        //
      }
      if (i == 9 && winner == null) {
        _showDrawDialogue();
      }
    }
  }

  TileState _findWinner() {
    TileState Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }

      return null;
    };

    final check = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];

    TileState winner;

    for (int i = 0; i < check.length; i++) {
      if (check[i] != null) {
        winner = check[i];
        break;
      }
    }
    return winner;
  }

  void _showWinnerDialogue(TileState tileState) {
    showDialog(
        context: navigatorKey.currentState.overlay.context,
        builder: (_) {
          return AlertDialog(
            title: Text("Winner"),
            content: Image.asset(
                tileState == TileState.CROSS ? 'images/x.png' : 'images/o.png'),
            actions: [FlatButton(onPressed: () {_reStartGame(); Navigator.of(navigatorKey.currentState.overlay.context).pop();}, child: Text("New Game"))],
          );
        });
  }

  void _showDrawDialogue() {
    showDialog(
        context: navigatorKey.currentState.overlay.context,
        builder: (_) {
          return AlertDialog(
            content: Text("Draw",style: TextStyle(color: Colors.indigoAccent,fontSize: 40),),
            actions: [FlatButton(onPressed: () {_reStartGame(); Navigator.of(navigatorKey.currentState.overlay.context).pop();}, child: Text("New Game"))],
          );
        });
  }

  void _reStartGame()
  {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      currentTurn = TileState.CROSS;
      i=0;
    });

  }
}
