import 'package:flutter/material.dart';

import 'QuizState.dart';
import 'QuizSettings.dart';
import 'QuizInProgress.dart';
import 'QuizResult.dart';
import 'class/QuizSession.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String title = 'Quiz - Setup';
  QuizState currentQuizState = QuizState.setting;
  QuizSession quizSession;

  @override
  Widget build(BuildContext context) {
    Function refresh = () {
      setState((){});
    };
    Function handleStart = (int format, int category, int questionAmount) async {
      quizSession = new QuizSession(format, category, questionAmount, refresh);
      await quizSession.generateQuestions();

      setState(() {
        currentQuizState = QuizState.inProgress;
      });
    };
    Function handleEnd = () {
      setState(() {
        currentQuizState = QuizState.result;
      });
    };

    Widget currentBody;
    switch (currentQuizState) {
      case QuizState.setting:
        title = 'Quiz - Setup';
        currentBody = QuizSettings(handleStart: handleStart);
        break;
      case QuizState.inProgress:
        title = 'Quiz - ${quizSession.currentQuestion+1}/${quizSession.questionAmount}';
        currentBody = QuizInProgress(quizSession: quizSession, handleEnd: handleEnd);
        break;
      case QuizState.result:
        title = 'Quiz - Result';
        currentBody = QuizResult(quizSession: quizSession);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (currentQuizState == QuizState.result)
            Container(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    currentQuizState = QuizState.setting;
                    quizSession = null;
                  });
                },
                child: Icon(Icons.north_east)
              )
            )
        ]
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: currentBody
      )
    );
  }
}