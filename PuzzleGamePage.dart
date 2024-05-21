import 'dart:math';

import 'package:flutter/material.dart';

class WordSearchPage extends StatefulWidget {
  @override
  _WordSearchPageState createState() => _WordSearchPageState();
}

class _WordSearchPageState extends State<WordSearchPage> {
  final List<String> words = ['CAT', 'DOG', 'BIRD', 'FISH'];
  List<List<String>> grid = [];
  List<String> foundWords = [];
  List<int> selectedIndices = [];
  int chances = 5;
  bool gameActive = true;

  @override
  void initState() {
    super.initState();
    _generateGrid();
  }

  void _generateGrid() {
    final int gridSize = 10;
    final List<String> letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    final random = Random();

    // Initialize the grid with random letters
    grid = List.generate(gridSize, (index) => List.generate(gridSize, (index) => letters[random.nextInt(26)]));

    // Add words to the grid
    for (final word in words) {
      bool placed = false;
      while (!placed) {
        final row = random.nextInt(gridSize);
        final column = random.nextInt(gridSize);
        final direction = random.nextBool();

        if (direction) {
          if (_canPlaceWord(word, row, column, gridSize, direction)) {
            _placeWord(word, row, column, direction);
            placed = true;
          }
        } else {
          if (_canPlaceWord(word, row, column, gridSize, direction)) {
            _placeWord(word, row, column, direction);
            placed = true;
          }
        }
      }
    }
  }

  bool _canPlaceWord(String word, int row, int column, int gridSize, bool direction) {
    final int length = word.length;

    if (direction) {
      if (column + length > gridSize) return false;
      for (int i = 0; i < length; i++) {
        if (grid[row][column + i] != word[i] && grid[row][column + i] != ' ') return false;
      }
    } else {
      if (row + length > gridSize) return false;
      for (int i = 0; i < length; i++) {
        if (grid[row + i][column] != word[i] && grid[row + i][column] != ' ') return false;
      }
    }
    return true;
  }

  void _placeWord(String word, int row, int column, bool direction) {
    final int length = word.length;

    for (int i = 0; i < length; i++) {
      if (direction) {
        grid[row][column + i] = word[i];
      } else {
        grid[row + i][column] = word[i];
      }
    }
  }

  void _checkWord() {
    final word = selectedIndices.map((index) {
      final row = index ~/ grid.length;
      final column = index % grid.length;
      return grid[row][column];
    }).join('');

    if (words.contains(word) && !foundWords.contains(word)) {
      setState(() {
        foundWords.add(word);
        selectedIndices.clear();
        if (foundWords.length == words.length) {
          gameActive = false;
        }
      });
    } else {
      setState(() {
        selectedIndices.clear();
        chances--;
        if (chances == 0) {
          gameActive = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Search'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: grid.length,
              ),
              itemCount: grid.length * grid.length,
              itemBuilder: (context, index) {
                final row = index ~/ grid.length;
                final column = index % grid.length;
                final isSelected = selectedIndices.contains(index);
                final isPartOfWord = foundWords.any((word) => word.contains(grid[row][column]));
                return GestureDetector(
                  onTap: gameActive
                      ? () {
                    setState(() {
                      selectedIndices.add(index);
                      _checkWord();
                    });
                  }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: isSelected || isPartOfWord ? Colors.blue : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      grid[row][column],
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20.0),
            if (!gameActive)
              Text(
                'Game Over! ${foundWords.length == words.length ? 'You found all the words!' : 'Try again!'}',
                style: TextStyle(fontSize: 20.0),
              ),
            SizedBox(height: 20.0),
            Wrap(
              spacing: 10.0,
              children: words.map((word) {
                final bool found = foundWords.contains(word);
                return Chip(
                  label: Text(word),
                  backgroundColor: found ? Colors.green : null,
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Text('Chances left: $chances'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WordSearchPage(),
  ));
}
