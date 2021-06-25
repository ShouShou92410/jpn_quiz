import 'package:flutter/material.dart';

import 'class/QuizSession.dart';

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

  @override
  Widget build(BuildContext context) {
    Function handleOptionTap = (int selection) async {
      setState(() {
        quizSession.getCurrentQuestion().submit(selection);
        if (!quizSession.nextQuestion()) {
          handleEnd();
        }
      });
    };

    Widget questionLabel = Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            quizSession.getCurrentQuestionLabel(),
            style: TextStyle(
              fontSize: 20,
            )
          ),
          Divider(
            color: Colors.black,
            height: 20,
            thickness: 3,
          )
        ],
      )
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
              child: Text(quizSession.getCurrentQuestionOptionLabel(x)),
            )
          )
        )
      ).toList()
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          questionLabel,
          optionSection
        ]
      )
    );
  }
}