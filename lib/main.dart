import 'package:flutter/material.dart';
import 'package:lima_tetris/views/board_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BoardView(),
        ));
  }
}
