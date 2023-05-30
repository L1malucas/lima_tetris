import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lima_tetris/piece.dart';
import 'package:lima_tetris/pixel.dart';
import 'package:lima_tetris/values.dart';

List<List<Tetromino?>> gameBoard =
    List.generate(colLength, (i) => List.generate(rowLength, (j) => null));

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  Piece currentPiece = Piece(type: Tetromino.L);

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();
    Duration frameRate = const Duration(milliseconds: 800);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        checkLanding();
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  bool checkCollision(Direction direction) {
    for (int index = 0; index < currentPiece.position.length; index++) {
      int row = (currentPiece.position[index] / rowLength).floor();
      int col = currentPiece.position[index] % rowLength;

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }
      if (col > 0 && row > 0 && gameBoard[row][col] != null) {
        return true;
      }

      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
    }
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (int index = 0; index < currentPiece.position.length; index++) {
        int row = (currentPiece.position[index] / rowLength).floor();
        int col = currentPiece.position[index] % rowLength;

        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
        itemCount: rowLength * colLength,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: rowLength),
        itemBuilder: (context, index) {
          int row = (index / rowLength).floor();
          int col = index % rowLength;
          if (currentPiece.position.contains(index)) {
            return Pixel(
              color: Colors.yellow,
              numbers: index.toString(),
            );
          } else if (gameBoard[row][col] != null) {
            return Pixel(
              color: Colors.pink,
              numbers: index.toString(),
            );
          } else {
            return Pixel(
              color: Colors.grey,
              numbers: index.toString(),
            );
          }
        },
      ),
    );
  }
}
