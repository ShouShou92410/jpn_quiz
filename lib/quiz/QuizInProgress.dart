import 'package:flutter/material.dart';

import 'QuizPage.dart';

class QuizInProgress extends StatefulWidget {
  final QuizSession quizSession;
  final Function handleEnd;
  QuizInProgress({@required this.quizSession, @required this.handleEnd});

  @override
  _QuizInProgressState createState() => _QuizInProgressState(quizSession, handleEnd);
}

class _QuizInProgressState extends State<QuizInProgress> {
  final QuizSession quizSession;
  final Function handleEnd;
  _QuizInProgressState(this.quizSession, this.handleEnd);

  int currentQuestion = 0;

  @override
  Widget build(BuildContext context) {
    Function handleOptionTap = (int selection) async {
      quizSession.questions[currentQuestion].submit(selection);

      if (currentQuestion == quizSession.questions.length - 1) {
        handleEnd();
      }
      else {
        setState(() {
          currentQuestion++;
        });
      }
    };

    Widget questionLabel = Center(
      child: Text(quizSession.getQuestionLabel(currentQuestion))
    );
    
    Widget optionSection = Column(
      children: List<int>.generate(QuizSession.OPTIONAMOUNT, (x) => x).map(
        (x) => Container(
          margin: EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20)
              ),
              onPressed: (){
                handleOptionTap(x);
              },
              child: Text(quizSession.getOptionLabel(currentQuestion, x)),
            )
          )
        )
      ).toList()
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          questionLabel,
          optionSection
        ]
      )
    );
  }
}