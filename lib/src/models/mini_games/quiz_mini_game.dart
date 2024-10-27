import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import '../dialog.dart';
//inspired by https://www.geeksforgeeks.org/basic-quiz-app-in-flutter-api/

class QuizMiniGame extends StatefulWidget {
  final Function? onQuizMiniGameCompleted;
  const QuizMiniGame({Key? key, this.onQuizMiniGameCompleted}) : super(key: key);

  _QuizMiniGameState createState() => _QuizMiniGameState();
}

class _QuizMiniGameState extends State<QuizMiniGame> {
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
    TalkDialog.show(context, GameDialog.quizEndingDialog(), onFinish: () {
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
    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/cut_scenes/clean-city.jpg',
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
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Text(
                    _questions[_questionIndex]['question'] as String,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Answer Buttons with Black Text
                ...(_questions[_questionIndex]['answers']
                        as List<Map<String, Object>>)
                    .map((answer) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () => _selectAnswer(answer['score'] as bool),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.white,
                            ),
                          ),
                          child: Text(
                            answer['answerText'] as String,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
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


final _questions = const [
  {
    'question': 'How long is New Zealand’s Ninety Mile Beach?',
    'answers': [
      {'answerText': '88km, so 55 miles long.', 'score': true},
      {'answerText': '55km, so 34 miles long.', 'score': false},
      {'answerText': '90km, so 56 miles long.', 'score': false},
    ],
  },
  {
    'question':
        'In which month does the German festival of Oktoberfest mostly take place?',
    'answers': [
      {'answerText': 'January', 'score': false},
      {'answerText': 'October', 'score': false},
      {'answerText': 'September', 'score': true},
    ],
  },
  {
    'question': 'Who composed the music for Sonic the Hedgehog 3?',
    'answers': [
      {'answerText': 'Britney Spears', 'score': false},
      {'answerText': 'Timbaland', 'score': false},
      {'answerText': 'Michael Jackson', 'score': true},
    ],
  },
  {
    'question': 'In Georgia (the state), it’s illegal to eat what with a fork?',
    'answers': [
      {'answerText': 'Hamburgers', 'score': false},
      {'answerText': 'Fried chicken', 'score': true},
      {'answerText': 'Pizza', 'score': false},
    ],
  },
  {
    'question':
        'Which part of his body did musician Gene Simmons from Kiss insure for one million dollars?',
    'answers': [
      {'answerText': 'His tongue', 'score': true},
      {'answerText': 'His leg', 'score': false},
      {'answerText': 'His butt', 'score': false},
    ],
  },
  {
    'question': 'In which country are Panama hats made?',
    'answers': [
      {'answerText': 'Ecuador', 'score': true},
      {'answerText': 'Panama (duh)', 'score': false},
      {'answerText': 'Portugal', 'score': false},
    ],
  },
  {
    'question': 'From which country do French fries originate?',
    'answers': [
      {'answerText': 'Belgium', 'score': true},
      {'answerText': 'France (duh)', 'score': false},
      {'answerText': 'Switzerland', 'score': false},
    ],
  },
  {
    'question': 'Which sea creature has three hearts?',
    'answers': [
      {'answerText': 'Great White Sharks', 'score': false},
      {'answerText': 'Killer Whales', 'score': false},
      {'answerText': 'The Octopus', 'score': true},
    ],
  },
  {
    'question': 'Which European country eats the most chocolate per capita?',
    'answers': [
      {'answerText': 'Belgium', 'score': false},
      {'answerText': 'The Netherlands', 'score': false},
      {'answerText': 'Switzerland', 'score': true},
    ],
  },
];
