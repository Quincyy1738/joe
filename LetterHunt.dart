import 'package:flutter/material.dart';
import 'dart:async';

class LetterHuntGame extends StatefulWidget {
  @override
  _LetterHuntGameState createState() => _LetterHuntGameState();
}

class _LetterHuntGameState extends State<LetterHuntGame> {
  String sequence = 'AAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAA';
  String targetLetter = 'B';
  bool found = false;
  Timer? timer;
  bool gameStarted = false;
  int timeLeft = 10;
  int sequenceIndex = 1; // Counter variable to track the additional sequence to use

  // Define additional sequence and target letter
  List<String> additionalSequences = [
    'LLLILLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL',
    'KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKLKKKKKKKKK',
    'PPPPPPPPPPPPPPPPPPPPPDPPPPPPPPPPPPPPPPPPPP',
    'RRRRRRRRRRRRRRRRRRRRRRRRRRRRRWRRRRRRRRRRRR',
    'BBBBBBBBBDBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',
    'ZZZZZZZZEZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ',
    'WWWWWWWWWWWWWWWWVWWWWWWWWWWWWWWWWWWWWWWWWW',
    'EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEOEEEEEEEE',
    'QQQQQQQQQQQQQQQQOQQQQQQQQQQQQQQQQQQQQQQQQQ',
    'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGJGGGGGGGGGGG',
    'SSSSSSSSSSSSSSSSSSSSSSSSSSSESSSSSSSSSSSSSS',
    'CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCC'
  ];

  List<String> targetLetters = [
    'I', 'L', 'D', 'W', 'D', 'E', 'V', 'O', 'O', 'J', 'E', 'S'
  ];

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (timeLeft == 0) {
          timer.cancel();
          if (!found) {
            showRestartDialog();
          }
        } else {
          timeLeft--;
        }
      });
    });
  }

  void checkForLetter(String letter) {
    if (letter == targetLetter) {
      setState(() {
        found = true;
      });
      timer?.cancel();
      showCongratulationsDialog();
    }
  }

  void restartGame() {
    setState(() {
      sequenceIndex = (sequenceIndex + 1) % additionalSequences.length;
      sequence = additionalSequences[sequenceIndex];
      targetLetter = targetLetters[sequenceIndex];
      gameStarted = true;
      found = false;
      timeLeft = 10;
    });
    startTimer();
  }

  void showRestartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Better luck next time!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You found the letter "$targetLetter"!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                restartGame();
              },
              child: Text('Next'),
            ),
            TextButton(
              onPressed: () {
                restartGame();
                Navigator.of(context).pop();
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Letter Hunt'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Can you find the "$targetLetter" in this sequence?',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: sequence.length,
              itemBuilder: (context, index) {
                String letter = sequence[index];
                return InkWell(
                  onTap: () {
                    if (gameStarted) {
                      checkForLetter(letter);
                      if (letter == targetLetter) {
                        setState(() {
                          found = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: found && letter == targetLetter ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        letter,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            if (!found && gameStarted)
              Text(
                'Time Left: $timeLeft seconds',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 20),
            if (!found && !gameStarted)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    gameStarted = true;
                  });
                  startTimer();
                },
                child: Text('Start'),
              ),
            if (!found && gameStarted)
              ElevatedButton(
                onPressed: () {
                  restartGame();
                },
                child: Text('Restart'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
