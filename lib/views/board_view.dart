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
  Piece currentPiece = Piece(type: Tetromino.T);
  int currentScore = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();
    Duration frameRate = const Duration(milliseconds: 200);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        clearLines();
        checkLanding();
        if (gameOver == true) {
          timer.cancel();
        }
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  void showGameOverDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Game Over"),
              content: Text("Your score is: $currentScore"),
              actions: [
                TextButton(
                    onPressed: () {
                      resetGame();
                      Navigator.pop(context);
                    },
                    child: const Text("Play again"))
              ],
            ));
  }

  void resetGame() {
    gameBoard =
        List.generate(colLength, (i) => List.generate(rowLength, (j) => null));
    gameOver = false;
    currentScore = 0;
    createNewPiece();
    startGame();
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

      if (row >= colLength || col < 0 || col >= rowLength) {
        return true; // Collision with boundary
      }

      if (row >= 0 && gameBoard[row][col] != null) {
        return true; // Collision with existing piece
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
    if (isGameOver()) {
      gameOver == true;
    }
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.rotatePiece();
      });
    }
  }

  void clearLines() {
    for (int row = colLength - 1; row >= 0; row--) {
      bool rowIsFUll = true;

      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          rowIsFUll = false;
          break;
        }
      }

      if (rowIsFUll) {
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        gameBoard[0] = List.generate(row, (index) => null);
      }
    }
  }

  bool isGameOver() {
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: rowLength * colLength,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength),
              itemBuilder: (context, index) {
                int row = (index / rowLength).floor();
                int col = index % rowLength;
                if (currentPiece.position.contains(index)) {
                  return Pixel(
                    color: currentPiece.color,
                  );
                } else if (gameBoard[row][col] != null) {
                  final Tetromino? tetrominoType = gameBoard[row][col];
                  return Pixel(
                    color: tetrominoColors[tetrominoType],
                  );
                } else {
                  return Pixel(
                    color: Colors.grey,
                  );
                }
              },
            ),
          ),
          Text(
            "Score: $currentScore",
            style: const TextStyle(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0, top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  color: Colors.white,
                  onPressed: moveLeft,
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),
                ),
                IconButton(
                  onPressed: rotatePiece,
                  color: Colors.white,
                  icon: const Icon(Icons.rotate_right),
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: moveRight,
                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
