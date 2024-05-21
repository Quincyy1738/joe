import 'package:flutter/material.dart';
import 'dart:async';

class LetterMatchingPage extends StatefulWidget {
  @override
  _LetterMatchingPageState createState() => _LetterMatchingPageState();
}

class _LetterMatchingPageState extends State<LetterMatchingPage> {
  List<String> _letters = [];
  List<String> _selectedLetters = [];
  Map<String, String> _matches = {};
  bool _isGameComplete = false;
  bool _isGameStarted = false;
  Timer? _timer;
  int _timeLeft = 60;
  int? _bestTime;

  @override
  void initState() {
    super.initState();
    _initializeLetters();
  }

  void _initializeLetters() {
    List<String> uppercaseLetters = List.generate(26, (index) => String.fromCharCode(index + 65));
    List<String> lowercaseLetters = List.generate(26, (index) => String.fromCharCode(index + 97));
    _letters = uppercaseLetters + lowercaseLetters;
    _letters.shuffle();
  }

  void _startGame() {
    setState(() {
      _isGameStarted = true;
      _isGameComplete = false;
      _timeLeft = 60;
      _matches.clear();
      _selectedLetters.clear();
      _initializeLetters();
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _isGameStarted = false;
          _isGameComplete = true;
          timer.cancel();
        }
      });
    });
  }

  void _checkMatch() {
    if (_selectedLetters.length == 2) {
      if (_selectedLetters[0].toLowerCase() == _selectedLetters[1].toLowerCase()) {
        setState(() {
          _matches[_selectedLetters[0]] = _selectedLetters[1];
          _selectedLetters.clear();
          if (_matches.length == 26) {
            _isGameComplete = true;
            _isGameStarted = false;
            _timer?.cancel();
            int timeTaken = 60 - _timeLeft;
            if (timeTaken <= 30 && (_bestTime == null || timeTaken < _bestTime!)) {
              _bestTime = timeTaken;
            }
          }
        });
      } else {
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _selectedLetters.clear();
          });
        });
      }
    }
  }

  void _onLetterTap(String letter) {
    if (_isGameStarted && _selectedLetters.length < 2 && !_selectedLetters.contains(letter) && !_matches.containsKey(letter) && !_matches.containsValue(letter)) {
      setState(() {
        _selectedLetters.add(letter);
      });
      _checkMatch();
    }
  }

  Widget _buildLetterCard(String letter) {
    bool isSelected = _selectedLetters.contains(letter);
    bool isMatched = _matches.containsKey(letter) || _matches.containsValue(letter);

    return GestureDetector(
      onTap: () => _onLetterTap(letter),
      child: Card(
        color: isMatched ? Colors.green : (isSelected ? Colors.blue : Colors.white),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 24,
              color: isMatched ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _letters.length,
      itemBuilder: (context, index) {
        String letter = _letters[index];
        return _buildLetterCard(letter);
      },
    );
  }

  Widget _buildEndMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _matches.length == 26
                ? 'Congratulations! You matched all the letters!'
                : 'Better luck next time!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          if (_bestTime != null && _matches.length == 26)
            Text(
              'Your best time: $_bestTime seconds',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _startGame,
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Letter Matching Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instructions: Match each uppercase letter with its corresponding lowercase letter. Tap a letter to select it, then tap another letter to find its match. If the letters match, they will be locked in place. Try to match all the letters within 60 seconds!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _buildGameGrid(),
            ),
            if (!_isGameStarted)
              Center(
                child: ElevatedButton(
                  onPressed: _startGame,
                  child: Text('Start'),
                ),
              ),
            if (_isGameStarted)
              Text(
                'Time Left: $_timeLeft seconds',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            if (_isGameComplete) _buildEndMessage(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
