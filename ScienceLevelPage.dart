import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final List<String> correctWords = [
    'HISTORY',
    'PHYSICS',
    'LITERATURE',
    'BIOLOGY',
    'CHEMISTRY',
    'GEOGRAPHY',
    'MATH',
    'LANGUAGE',
    'ART',
    'MUSIC'
  ];

  final List<String> descriptions = [
  'The study of past events, particularly in human affairs. It helps us understand how societies, cultures, and individuals have evolved over time, and how past events continue to shape the present.',
  'The systematic study of the structure and behavior of the physical and natural world through observation and experiment. It explores fundamental concepts such as motion, energy, forces, and the properties of matter and light.',
  'refers to written works, especially those considered of superior or lasting artistic merit. It encompasses various forms of creative expression, including novels, poetry, drama, and essays, and offers insights into human experiences, emotions, and ideas.',
  'The scientific study of life and living organisms, including their structure, function, growth, evolution, distribution, and taxonomy. It explores a wide range of topics such as genetics, ecology, physiology, and anatomy.',
  'The branch of science that deals with the composition, structure, properties, and reactions of matter. It investigates the substances that make up the universe and how they interact with each other, providing insights into the natural world and practical applications in various industries.',
  'The study of the Earth`s landscapes, environments, and the relationships between people and their surroundings. It explores physical features such as mountains, rivers, and climates, as well as human activities like population distribution, urbanization, and globalization.',
  'The study of numbers, quantity, space, patterns, and structure. It provides tools and techniques for solving problems, analyzing data, and understanding complex systems in fields such as science, engineering, economics, and finance.',
  'Encompasses the systems of communication used by humans, including spoken, written, and signed forms. It plays a crucial role in expressing thoughts, conveying information, and connecting people across cultures and societies.',
  'The expression of creative imagination and skill through visual, auditory, or performing media. It encompasses a wide range of disciplines such as painting, sculpture, music, dance, literature, and theater, serving as a means of personal expression, cultural representation, and social commentary.',
  'The art form that uses sound organized in time to express ideas, emotions, and aesthetic qualities. It encompasses various styles, genres, and traditions, and has been an integral part of human culture and society throughout history.'
  ];


  int currentQuestionIndex = 0;
  String currentWord = '';
  String constructedWord = '';
  int chancesLeft = 3;
  bool gameActive = true;


  void _addLetter(String letter) {
    setState(() {
      if (gameActive && !constructedWord.contains(letter)) {
        constructedWord += letter;
      }

      bool letterFound = false;
      for (int i = 0; i < currentWord.length; i++) {
        if (currentWord[i] == letter) {
          letterFound = true;
          break;
        }
      }

      if (!letterFound) {
        chancesLeft--;
        if (chancesLeft == 0) {
          gameActive = false;
          _showChancesZeroDialog(); // Call the dialog method directly
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Warning: $letter is not in the word.'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    });
  }


  void _showChancesZeroDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Feedback"),
          content: Text("Your chances are zero. Do you want to try again?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the current dialog
                _tryAgain(); // Restart the game
              },
              child: Text("Yes"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the current dialog
                _tryAgain(); // Restart the game
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }




  void _clearWord() {
    setState(() {
      constructedWord = '';
    });
  }

  void _submitWord() {
    setState(() {
      if (gameActive) {
        if (constructedWord.toUpperCase() == currentWord) {
          _showFeedbackDialog('Your answer is correct!');
        } else {
          // Show feedback for incorrect answers
          _showFeedbackDialog('Your answer is correct!');
        } // Load the next question
      }
    });
  }




  void _loadNextQuestion() {
    setState(() { // Add setState here
      currentQuestionIndex++;
      if (currentQuestionIndex < descriptions.length) {
        currentWord = correctWords[currentQuestionIndex]; // Update currentWord for the new question
        constructedWord = ''; // Reset constructedWord
        chancesLeft = 3;
        gameActive = true;
      } else {
        // All questions have been answered
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Congratulations! You have completed all questions.'),
            duration: Duration(seconds: 3),
          ),
        );
        // Reset to the first question
        currentQuestionIndex = 0;
        currentWord = correctWords[currentQuestionIndex];
      }
    });
  }






  void _tryAgain() {
    setState(() {
      chancesLeft = 3;
      constructedWord = '';
      gameActive = true;
    });
  }

  void _showFeedbackDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Feedback"),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the current dialog
                if (currentQuestionIndex < descriptions.length) {
                  _loadNextQuestion(); // Load the next question
                }
              },
              child: Text("Next Question"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    currentWord = correctWords[currentQuestionIndex];
  }

  @override
  Widget build(BuildContext context) {
    String wordMask = '';
    for (int i = 0; i < currentWord.length; i++) {
      String letter = currentWord[i];
      if (constructedWord.contains(letter)) {
        wordMask += letter;
      } else {
        wordMask += '_';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Guess The Word'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Description:',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 10),
          Text(
            descriptions[currentQuestionIndex], // Display the current question description
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Word to Guess:',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 10),
          Text(
            wordMask,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'].map((letter) {
              return ElevatedButton(
                onPressed: gameActive ? () => _addLetter(letter) : null,
                child: Text(letter),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Chances Left: $chancesLeft',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: gameActive ? _submitWord : null,
                child: Text('Submit'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: gameActive ? _clearWord : null,
                child: Text('Clear'),
                style: ElevatedButton.styleFrom(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
