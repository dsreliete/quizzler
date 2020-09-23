import 'package:flutter/material.dart';
import 'package:quizzler/QuizzBrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());

QuizzBrain quizzBrain = QuizzBrain();

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeperList = [];

  void checkAnswers(bool userAnswer) {
    setState(() {
      if (quizzBrain.checkAnswer(userAnswer)) {
        addPositiveScoreToScoreList();
      } else {
        addNegativeScoreToScoreList();
      }

      checkNextQuestionOrFinishQuizz();
    });
  }

  void addPositiveScoreToScoreList() {
    scoreKeeperList.add(
      Icon(Icons.check, color: Colors.green),
    );
  }

  void showCompletedQuizzAlert() {
    String answers = quizzBrain.getAnswersAmount();
    Alert(
      style: AlertStyle(
        backgroundColor: Colors.black,
        titleStyle: TextStyle(color: Colors.white),
        descStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      context: context,
      type: AlertType.success,
      title: "QUIZZLER \nYou\'ve reached the end of the quiz.",
      desc: "$answers",
      buttons: [
        DialogButton(
          child: Text(
            "Restart Quizz",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () {
            resetQuizz();
            Navigator.pop(context);
          },
          width: 120,
          color: Colors.green,
        )
      ],
    ).show();
  }

  void checkNextQuestionOrFinishQuizz() {
    if (!quizzBrain.checkEndList()) {
      quizzBrain.nextQuestion();
    } else {
      showCompletedQuizzAlert();
    }
  }

  void resetQuizz() {
    setState(() {
      scoreKeeperList.clear();
      quizzBrain.resetQuestionBank();
    });
  }

  void addNegativeScoreToScoreList() {
    scoreKeeperList.add(
      Icon(Icons.close, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizzBrain.getQuizzProgressionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizzBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswers(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswers(false);
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: scoreKeeperList,
        ),
      ],
    );
  }
}
