import 'package:flutter/material.dart';
import 'package:flutter_07_tic_tac_toe/tile_sate.dart';

class BoardTile extends StatelessWidget {
  final double dimension;
  final TileState tileState;
  final VoidCallback onPressed;

  BoardTile(this.dimension, this.tileState, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dimension,
      width: dimension,
      child: FlatButton(
        onPressed: onPressed,
        child: _widgetForTileState(),
      ),
    );
  }

  Widget _widgetForTileState() {
    Widget widget;
    switch (tileState) {
      case TileState.EMPTY:
        {
            widget = Container();
        }
        break;
      case TileState.CROSS:
        {
          widget = Image.asset('images/x.png');
        }
        break;
      case TileState.CIRCLE:
        {
          widget = Image.asset('images/o.png');
        }
        break;
    }
    return widget;
  }
}
