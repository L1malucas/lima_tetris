import 'package:flutter/material.dart';

enum Tetromino { L, J, I, O, S, Z, T }

enum Direction { left, down, right }

int rowLength = 10;
int colLength = 15;

const Map<Tetromino, MaterialColor> tetrominoColors = {
  Tetromino.L: Colors.orange,
  Tetromino.J: Colors.blue,
  Tetromino.I: Colors.pink,
  Tetromino.O: Colors.yellow,
  Tetromino.S: Colors.green,
  Tetromino.Z: Colors.red,
  Tetromino.T: Colors.purple,
};
