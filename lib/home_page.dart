import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flappy_bird/widgets/barrier_widget.dart';
import 'package:flappy_bird/widgets/bird_widget.dart';
import 'package:flappy_bird/widgets/moon_icons.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //bird variable
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; //Gía trị của trọng lực
  double velocity = 2; //Vận tốc
  double birdWidth = 0.1; // trên 2, 2 là toàn màn hình
  double birdHeight = 0.1; // trên 2, 2 là toàn màn hình

  //game setting
  bool gameHasStart = false;
  int score = 0;
  int bestScore = 0;
  //Ống đồng
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    //[TopHeight, BottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gameHasStart = true;
    Timer.periodic(
      Duration(milliseconds: 10),
      (timer) {
        // Bước nhảy theo kiểu vật lý hình parapol
        height = (gravity * time * time) + (velocity * time);

        setState(() {
          birdY = initialPos - height;
        });

        if (birdIsDead()) {
          timer.cancel();
          _showDialog();
        }

        if (keepScore()) {
          setState(() {
            score += 1;
          });
        }

        moveMap();
        time += 0.01;
      },
    );
  }

  bool keepScore() {
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth <= -birdWidth &&
          !birdIsDead()) {
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      if (score > bestScore) bestScore = score;
      score = 0;
      gameHasStart = false;
      time = 0;
      initialPos = birdY;
      barrierX = [2, 2 + 1.5];
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext content) {
          return AlertDialog(
            backgroundColor: Colors.yellow,
            title: const Center(
              child: Text("G A M E  O V E R"),
            ),
            content: Text(
                "Nice try, you passed ${(score == 0 ? 0 : (score ~/ 180) + 1)} object, you has ${bestScore < score ? "new best: $score score" : ": $score score in this turn"}"),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    color: Colors.white,
                    child: const Text("PLAY AGAIN"),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });

      if (barrierX[i] < -1.5) {
        // Random rd = Random();
        // var newBarrierHeight = (rd.nextInt(10) + 1) / 10;
        barrierX[i] += 3;
        // barrierHeight[i][1] = newBarrierHeight;
        // barrierHeight[i][2] = (1 - newBarrierHeight - 0.1);
      }
    }
  }

  bool birdIsDead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStart ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: gameHasStart ? Colors.blue : Colors.black,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.asset(
                          "assets/picture/background.webp",
                          fit: BoxFit.cover,
                        ),
                      ),

                      MyBird(
                        birdY: birdY,
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                      ),
                      // Container(
                      //     child: gameHasStart
                      //         ? const Icon(
                      //             MyFlutterApp.wb_sunny,
                      //             color: Colors.yellow,
                      //             size: 50,
                      //           )
                      //         : const Icon(
                      //             MyFlutterApp.moon,
                      //             color: Colors.white,
                      //             size: 50,
                      //           ),
                      //     alignment: const Alignment(0.8, -0.8)),
                      Container(
                        alignment: const Alignment(0, -0.5),
                        child: Text(
                          gameHasStart ? "" : "F L A P P Y  B I R D",
                          style: TextStyle(color: Colors.blue, fontSize: 30),
                        ),
                      ),
                      MBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                        isThisBottomBarrier: false,
                      ),
                      Container(
                        alignment: const Alignment(0, 0.5),
                        child: Text(
                          gameHasStart ? "" : "Tap to play!",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ),

                      // Bottom barrier 0
                      MBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                        isThisBottomBarrier: true,
                      ),

                      // Top barrier 1
                      MBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                        isThisBottomBarrier: false,
                      ),

                      // Bottom barrier 1
                      MBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                        isThisBottomBarrier: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Expanded(
                  child: Container(
                    color: Colors.brown,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                score.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 35),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                'S C O R E',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                bestScore.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 35),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                'B E S T',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
