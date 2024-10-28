import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import '../../dialog.dart';
//inspired by https://www.geeksforgeeks.org/basic-quiz-app-in-flutter-api/

class QuizMiniGame extends StatefulWidget {
  final Function? onQuizMiniGameCompleted;
  const QuizMiniGame({super.key, this.onQuizMiniGameCompleted});

  @override
  QuizMiniGameState createState() => QuizMiniGameState();
}

class QuizMiniGameState extends State<QuizMiniGame> {
  bool hasShownIntroDialog = false;
  int _questionIndex = 0;
  bool correctAnswerSelected = false;
  String feedbackMessage = '';
  Color feedbackColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    // Show the intro dialog when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showIntroDialog();
    });
  }

  void _showIntroDialog() {
    if (!hasShownIntroDialog) {
      TalkDialog.show(context, GameDialog.quizIntroDialog(), onFinish: () {
        setState(() {
          hasShownIntroDialog = true; // Mark as shown after the dialog finishes
        });
      });
    }
  }

  void _completeQuizMiniGame() {
    TalkDialog.show(context, GameDialog.quizEndingDialog(), backgroundColor: Colors.transparent, onFinish: () {
      widget.onQuizMiniGameCompleted?.call(); // Trigger completion callback
      Navigator.pop(context); // Close the RecyclingMinigame screen after completion
    });
  }

  void _nextQuestion() {
    if (_questionIndex == _questions.length - 1) {
      _completeQuizMiniGame();
    }
    setState(() {
      _questionIndex++;
      feedbackMessage = '';
      feedbackColor = Colors.transparent;
    });
    
  }

  void _selectAnswer(bool isCorrect) {
    setState(() {
      feedbackMessage = isCorrect ? '' : 'Wrong answer, try again';
      feedbackColor = isCorrect ? Colors.transparent : Colors.red;
      if (isCorrect) {
        _nextQuestion();
      }
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        feedbackMessage = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questionIndex >= _questions.length) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/cut_scenes/clean-city.jpg',
                fit: BoxFit.cover,
              ),
            ),
            const Center(
              child: Text(
                'Quiz completed!',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(offset: Offset(4.0, 4.0), blurRadius: 6.0, color: Colors.black)],
                ),
              ),
            ),
          ],
        )
      );
    }

    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/cut_scenes/dirty-city.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Question Container
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Text(
                    _questions[_questionIndex]['question'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Answer Buttons with Black Text
                ...(_questions[_questionIndex]['answers'] as List<Map<String, Object>>).map((answer) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () => _selectAnswer(answer['score'] as bool),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.white,
                        ),
                      ),
                      child: Text(
                        answer['answerText'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Align( // could change to sounds instead.
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                feedbackMessage,
                style: TextStyle(
                  color: feedbackColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


const _questions = [
  {
    'question': "Why shouldn't you throw your trash in nature?",
    'answers': [
      {'answerText': "The trash might get hungry and eat all the flowers.", 'score': false},
      {'answerText': "The trash can harm animals, plants and trees.", 'score': true},
      {'answerText': "The trash does not like the nature.", 'score': false},
    ],
  },
  {
    'question': "What is the best thing you can do with trash you find on the ground?",
    'answers': [
      {'answerText': "Hide it under a rock so no one sees it.", 'score': false},
      {'answerText': "Recycle it.", 'score': true},
      {'answerText': "Collect it and keep it at home.", 'score': false},
    ],
  },
  {
    'question': "What can happen if you cut down too many trees?",
    'answers': [
      {'answerText': "The air quality gets worse since there are no trees to absorb carbon dioxide.", 'score': true},
      {'answerText': "Trees grow back instantly, so it doesn't matter.", 'score': false},
      {'answerText': "The sky will turn green to compensate for the trees.", 'score': false},
    ],
  },
  {
    'question': "How can you save electricity in your home?",
    'answers': [
      {'answerText': "Turn off lamps and electronics when they're not used.", 'score': true},
      {'answerText': "Clean the house, because a clean house uses less electricity.", 'score': false},
      {'answerText': "Keep all your windows open all day and night.", 'score': false},
    ],
  },
  {
    'question': "Why is it important to save electricity?",
    'answers': [
      {'answerText': "Saving energy is part of keeping cities sustainable and saving resources.", 'score': true},
      {'answerText': "To make the internet faster.", 'score': false},
      {'answerText': "To make sure our lights shine brighter than the stars.", 'score': false},
    ],
  },
];
