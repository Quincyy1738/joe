import 'package:flutter/material.dart';


class FillInTheBlanksGame extends StatefulWidget {
  @override
  _FillInTheBlanksGameState createState() => _FillInTheBlanksGameState();
}

class _FillInTheBlanksGameState extends State<FillInTheBlanksGame> {
  List<String> _sentences = [
    'To be successful, one must __________.',
    'A healthy lifestyle includes regular exercise, a balanced diet, and enough __________.',
    'Time management skills are essential for __________.',
    'To achieve our goals, it is important to stay __________ and focused.',
    'Education is the key to __________.',
    'Practice makes __________.',
    'Never give up on your __________.',
    'Dream big and __________.',
    'The only way to do great work is to __________.',
    'Success is not the key to happiness. Happiness is the key to __________.'
  ];

  List<List<String>> _choices = [
    ['A. work hard', 'B. sleep all day', 'C. watch TV'],
    ['A. sleep', 'B. junk food', 'C. sleep and rest'],
    ['A. relaxation', 'B. prioritizing tasks', 'C. procrastination'],
    ['A. determined', 'B. distracted', 'C. lazy'],
    ['A. success', 'B. knowledge', 'C. happiness'],
    ['A. perfect', 'B. practice', 'C. mistakes'],
    ['A. dreams', 'B. goals', 'C. journey'],
    ['A. work hard', 'B. dream bigger', 'C. stay small'],
    ['A. start', 'B. believe', 'C. continue'],
    ['A. success', 'B. life', 'C. everything'],
  ];

  List<String> _answers = ['A', 'C', 'B', 'A', 'B', 'A', 'B', 'B', 'A', 'C']; // Correct answers for each question

  int _currentIndex = 0;
  String _selectedAnswer = '';
  bool _showAnswer = false;
  bool _showTryAgain = false;
  bool _canProceed = false;

  void _nextSentence() {
    if (_selectedAnswer.isNotEmpty) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _sentences.length;
        _selectedAnswer = '';
        _showAnswer = false;
        _showTryAgain = false;
        _canProceed = false;
      });
    }
  }

  void _checkAnswer() {
    if (_selectedAnswer == _answers[_currentIndex]) {
      setState(() {
        _showAnswer = true;
        _showTryAgain = false;
        _canProceed = true;
      });
    } else {
      setState(() {
        _showTryAgain = true;
        _canProceed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fill In The Blanks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _sentences[_currentIndex],
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: _choices[_currentIndex]
                        .map((choice) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedAnswer = choice.split('.').first.trim();
                            _checkAnswer();
                          });
                        },
                        child: Text(choice),
                      ),
                    ))
                        .toList(),
                  ),
                  SizedBox(height: 20),
                  if (_showAnswer) Text('Correct! The answer is ${_answers[_currentIndex]}'),
                  if (_showTryAgain) Text('Try Again!'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _canProceed ? _nextSentence : null,
              child: Text('Next Sentence'),
            ),
          ],
        ),
      ),
    );
  }
}
