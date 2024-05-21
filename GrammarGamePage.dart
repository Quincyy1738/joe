import 'dart:math';
import 'package:flutter/material.dart';

class GrammarGamePage extends StatefulWidget {
  @override
  _GrammarGamePageState createState() => _GrammarGamePageState();
}

class _GrammarGamePageState extends State<GrammarGamePage> {
  List<String> sentences = [
    "I am happy to see you.",
    "The cat is sleeping on the mat.",
    "She go to school everyday.",
    "They is playing in the park.",
    "He eats lunch at 12 PM.",
    "You are a good friend.",
    "She did won't like chocolate.",
    "They is swimming in the pool.",
    "We can go to the movies tomorrow.",
    "The book is of the table.",
  ];

  List<String> correctAnswers = [
    "I am happy to see you.",
    "The cat is sleeping on the mat.",
    "She goes to school everyday.",
    "They are playing in the park.",
    "He eats lunch at 12 PM.",
    "You are a good friend.",
    "She doesn't like chocolate.",
    "They are swimming in the pool.",
    "We can go to the movies tomorrow.",
    "The book is on the table.",
  ];

  // List to indicate which sentences should have "Yes" as the correct answer
  List<bool> yesAnswers = [
    true, // I am happy to see you. (Yes)
    true, // The cat is sleeping on the mat. (Yes)
    false, // She goes to school everyday.
    false, // They are playing in the park.
    true, // He eats lunch at 12 PM.
    true, // You are a good friend. (Yes)
    false, // She doesn't like chocolate.
    false, // They are swimming in the pool.
    true, // We can go to the movies tomorrow. (Yes)
    false, // The book is on the table.
  ];

  int currentSentenceIndex = 0;
  bool? userAnswer;
  int chances = 3;
  bool canProceed = false;

  void checkAnswer(bool answer) {
    setState(() {
      userAnswer = answer;
      if (answer == yesAnswers[currentSentenceIndex]) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Correct!'),
            backgroundColor: Colors.green,
          ),
        );
        canProceed = true;
      } else {
        chances = (chances - 1).clamp(0, 3); // Ensure chances are between 0 and 3
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect. The correct answer is: "${correctAnswers[currentSentenceIndex]}".'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void tryAgain() {
    setState(() {
      currentSentenceIndex = 0;
      chances = 3;
    });
  }

  void showCongratulationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Congratulations!'),
        content: Text('You have answered all questions correctly!'),
        actions: <Widget>[
          TextButton(
            child: Text('Play Again'),
            onPressed: () {
              Navigator.of(ctx).pop();
              tryAgain();
            },
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Correct The Grammar'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Is this sentence grammatically correct?',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              sentences[currentSentenceIndex],
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => checkAnswer(true),
                  child: Text('Yes'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => checkAnswer(false),
                  child: Text('No'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Chances: ${chances.clamp(0, 3)}/3',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (userAnswer != null &&
                currentSentenceIndex < sentences.length &&
                canProceed)
              ElevatedButton(
                onPressed: chances > 0
                    ? () {
                  setState(() {
                    if (currentSentenceIndex < sentences.length - 1) {
                      // Only increment if there are more questions remaining
                      currentSentenceIndex++; // Incrementing currentSentenceIndex here
                      userAnswer = null; // Reset user's answer for the next sentence
                      canProceed = false; // Prevent proceeding until user answers correctly
                    } else {
                      // Handle the case when all questions are answered
                      showCongratulationDialog();
                    }
                  });
                }
                    : null, // Disable button if no chances left
                child: Text('Next'),
              ),

            if (chances == 0)
              ElevatedButton(
                onPressed: tryAgain,
                child: Text('Try Again'),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GrammarGamePage(),
  ));
}


