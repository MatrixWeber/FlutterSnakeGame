import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'confirm_dialog.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];
  int numberOfSquares = 760;
  static const int randomNumberSeed = 700;

  static Random randomNumber = Random();
  int food = randomNumber.nextInt(randomNumberSeed);

  int bestScore = 0;
  int score = 0;

  void generateNewFood() {
    food = randomNumber.nextInt(randomNumberSeed);
    ++score;
  }

  void startGame() {
    snakePosition = [45, 65, 85, 105, 125];
    const duration = Duration(milliseconds: 300);
    if (bestScore < score) {
      bestScore = score;
    }
    score = 0;
    Timer.periodic(duration, (Timer timer) {
      {
        updateSnake();
        if (gameOver()) {
          timer.cancel();
          ConfirmDialog.showGameOverScreen(
              context, startGame, score.toString());
        }
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          ++count;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  String direction = 'down';
  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > 740) {
            snakePosition.add(snakePosition.last + 20 - 760);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;
        case 'up':
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last - 20 + 760);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;
        case 'left':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
        case 'right':
          if ((snakePosition.last + 1) % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 + 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;
        default:
      }
      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    if (direction != 'up' && details.delta.dy > 0) {
      direction = 'down';
    } else if (direction != 'down' && details.delta.dy < 0) {
      direction = 'up';
    }
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (direction != 'left' && details.delta.dx > 0) {
      direction = 'right';
    } else if (direction != 'right' && details.delta.dx < 0) {
      direction = 'left';
    }
  }

  Widget ClipRRectContainer(Color color) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: onVerticalDragUpdate,
                onHorizontalDragUpdate: onHorizontalDragUpdate,
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 20),
                    itemBuilder: (context, index) {
                      if (snakePosition.contains(index)) {
                        return Center(
                          child: ClipRRectContainer(Colors.white),
                        );
                      }
                      if (food == index) {
                        return ClipRRectContainer(Colors.green);
                      } else {
                        return ClipRRectContainer(Colors.grey[900]);
                      }
                    }),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: startGame,
                    child: const Text(
                      'Start Game',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                  Text(
                    'Score: $score',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    'Best Score: $bestScore',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
