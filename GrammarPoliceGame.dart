import 'package:flutter/material.dart';
import 'package:language_tool/language_tool.dart';


class GrammarPoliceGame extends StatefulWidget {
  @override
  _GrammarPoliceGameState createState() => _GrammarPoliceGameState();
}

class _GrammarPoliceGameState extends State<GrammarPoliceGame> {
  LanguageTool _languageTool = LanguageTool();

  String _enteredSentence = '';
  bool _isLoading = false;
  List<String> _correctSentences = [];
  List<String> _incorrectSentences = [];

  Future<void> _checkGrammar(String sentence) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _languageTool.check(sentence);
      setState(() {
        _isLoading = false;
      });

      if (result.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Warning: Grammar may not be correct. Please review the sentence.'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          _incorrectSentences.add(sentence);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Congratulations! Your sentence is grammatically correct!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _correctSentences.add(sentence);
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking grammar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onTextChanged(String value) {
    setState(() {
      _enteredSentence = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grammar Police'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter a sentence:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: _onTextChanged,
              decoration: InputDecoration(
                hintText: 'Type your sentence here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enteredSentence.isEmpty
                  ? null
                  : () {
                _checkGrammar(_enteredSentence);
              },
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Check Grammar'),
            ),
            SizedBox(height: 20),
            Text(
              'Correct Grammar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _correctSentences.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_correctSentences[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Incorrect Grammar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _incorrectSentences.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_incorrectSentences[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
