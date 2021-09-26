import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  const MyBird(
      {Key? key,
      required this.birdY,
      required this.birdHeight,
      required this.birdWidth})
      : super(key: key);
  final double birdY;
  final double birdWidth;
  final double birdHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      child: Container(
        child: Image.asset("assets/picture/flappy_bird.png"),
        width: MediaQuery.of(context).size.height * birdWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * birdHeight / 2,
      ),
    );
  }
}
