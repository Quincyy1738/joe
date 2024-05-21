import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async'; // Add this import statement at the top of your file

class AlphabetJumbleGame extends StatefulWidget {
  @override
  _AlphabetJumbleGameState createState() => _AlphabetJumbleGameState();
}

class _AlphabetJumbleGameState extends State<AlphabetJumbleGame> {
  String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  List<String> jumbledAlphabet = [];
  int timeLeft = 100; // Time in seconds for the timer
  bool gameStarted = false;
  int bestTime = -1; // Initialize the best time

  @override
  void initState() {
    super.initState();
    jumbleAlphabet();
  }

  void jumbleAlphabet() {
    jumbledAlphabet = alphabet.split('')..shuffle(Random());
  }

  void startTimer() {
    gameStarted = true;
    const oneSec = Duration(seconds: 1);
    Timer timer = Timer.periodic(oneSec, (Timer timer) {
      if (timeLeft == 0) {
        timer.cancel();
        checkResult();
      } else if (List.from(jumbledAlphabet).join() == alphabet) {
        timer.cancel();
        checkResult();
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  void checkResult() {
    if (List.from(jumbledAlphabet).join() == alphabet) {
      int completionTime = 100 - timeLeft;
      if (bestTime == -1 || completionTime < bestTime) {
        setState(() {
          bestTime = completionTime;
        });
      }
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have correctly ordered the alphabet in $completionTime seconds!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Better luck next time!'),
          content: Text('You didn\'t arrange the sequence within 100 seconds.'),
          actions: <Widget>[
            TextButton(
              child: Text('Try Again'),
              onPressed: () {
                setState(() {
                  jumbleAlphabet();
                  timeLeft = 100; // Reset time to your desired value
                });
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alphabet Jumble'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Rearrange the letters into the correct order:',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Wrap(
            children: List.generate(
              jumbledAlphabet.length,
                  (index) => _draggableLetter(jumbledAlphabet[index], index),
            ).toList(),
          ),
          if (gameStarted)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Time left: $timeLeft seconds'),
            ),
          if (bestTime != -1)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Best Time: ${bestTime}s'),
            ),
          ElevatedButton(
            child: Text(gameStarted ? 'Restart' : 'Start'),
            onPressed: () {
              if (!gameStarted) {
                startTimer();
              } else {
                setState(() {
                  jumbleAlphabet();
                  timeLeft = 100;
                  gameStarted = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _draggableLetter(String letter, int index) {
    return gameStarted
        ? DragTarget<int>(
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          String temp = jumbledAlphabet[index];
          jumbledAlphabet[index] = jumbledAlphabet[data];
          jumbledAlphabet[data] = temp;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Draggable<int>(
          data: index,
          child: _letterCard(letter, Colors.blue),
          feedback: _letterCard(letter, Colors.red),
          childWhenDragging: _letterCard(letter, Colors.grey),
        );
      },
    )
        : _letterCard(letter, Colors.blue); // If game hasn't started, just display the letter
  }


  Widget _letterCard(String letter, Color color) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          letter,
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
    );
  }
}
