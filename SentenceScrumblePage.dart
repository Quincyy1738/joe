import 'package:flutter/material.dart';


class SentenceScramblePage extends StatefulWidget {
  @override
  _SentenceScramblePageState createState() => _SentenceScramblePageState();
}

class _SentenceScramblePageState extends State<SentenceScramblePage> {
  List<String> sentences = [
    "The sun rose over the city",
    "She found a magic book",
    "Kid laughed as they played",
    "He thought hard about the clue",
    "Leaves whispered in the wind",
    "The cat yawned in the sun",
    "Cars beeped on the busy street",
    "She enjoyed her warm coffee",
    "The clock kept ticking",
    "Stars sparkled in the night sky"
  ];
  int currentSentenceIndex = 0;
  List<String> shuffledWords = [];
  List<String> completedSentences = [];  // List to hold completed sentences

  @override
  void initState() {
    super.initState();
    loadNewSentence();
  }

  void loadNewSentence() {
    shuffledWords = sentences[currentSentenceIndex].split(' ')..shuffle();
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final String word = shuffledWords.removeAt(oldIndex);
      shuffledWords.insert(newIndex, word);
    });
  }

  void checkSentence() {
    final currentSentence = shuffledWords.join(' ');
    if (currentSentence == sentences[currentSentenceIndex]) {
      setState(() {
        completedSentences.add(sentences[currentSentenceIndex]); // Add the completed sentence to the list
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Congratulations!'),
          content: Text('Excellent job! You`ve arranged the words correctly to form a proper sentence.'),
          actions: [
            TextButton(
              child: Text('Next Sentence'),
              onPressed: () {
                Navigator.of(context).pop();
                if (currentSentenceIndex < sentences.length - 1) {
                  setState(() {
                    currentSentenceIndex++;
                    loadNewSentence();
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Congratulations!'),
                      content: Text('You have completed all the challenges!'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The sentence is not correct yet.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentence Scramble'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ReorderableListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    key: Key('$index'),
                    color: Colors.orange[200],
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(Icons.drag_handle),
                      title: Text(shuffledWords[index], style: TextStyle(fontSize: 18)),
                    ),
                  );
                },
                itemCount: shuffledWords.length,
                onReorder: onReorder,
              ),
            ),
            SizedBox(height: 20),
            Center( // Center the button horizontally
              child: ElevatedButton(
                onPressed: checkSentence,
                child: Text('Check Sentence'),
              ),
            ),
            SizedBox(height: 20),
            if (completedSentences.isNotEmpty) // Display completed sentences list if not empty
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Completed Sentences:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: completedSentences.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${index + 1}. ${completedSentences[index]}'),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
