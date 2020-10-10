import 'package:flutter/material.dart';

class ConfirmDialog {
  static void showGameOverScreen(BuildContext context,
      void Function() playAgainPressed, final String score) {
    // set up the buttons
    final Widget playAgainButton = FlatButton(
      onPressed: () {
        Navigator.of(context).pop();
        playAgainPressed();
      },
      child: const Text("Play Again",
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );

    // set up the AlertDialog
    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.brown,
      title: Text(
        "GAME OVER!\n\nScore: $score",
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        playAgainButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
