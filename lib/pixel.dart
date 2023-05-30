import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  Pixel({super.key, required this.numbers, required this.color});
  var color;
  var numbers;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.all(1),
      child: Center(child: Text(numbers)),
    );
  }
}
