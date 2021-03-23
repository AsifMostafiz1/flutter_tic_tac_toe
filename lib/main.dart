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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      });
    }
  }
}
