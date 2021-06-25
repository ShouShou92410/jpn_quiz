import 'package:flutter/material.dart';

import 'class/QuizSession.dart';

class QuizResult extends StatefulWidget {
  final QuizSession quizSession;
  QuizResult({@required this.quizSession});

  @override
  _QuizResultState createState() => _QuizResultState(quizSession);
}

class _QuizResultState extends State<QuizResult> {
  final QuizSession quizSession;
  List<bool> isExpandedList;
  _QuizResultState(this.quizSession) {
    this.isExpandedList = List<bool>.generate(quizSession.questions.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          _buildTopSection(),
          _buildPanelList()
        ]
      )
    );
  }

  Widget _buildPanelList() {
    return Card(
        child: SingleChildScrollView(
          child: Container(
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded){
                setState(() {
                  isExpandedList[index] = !isExpanded;
                });
              },
              children: quizSession.questions.asMap().entries.map(
                (question) {
                  Icon icon = quizSession.questions[question.key].isCorrect() 
                    ? Icon(Icons.check, color: Colors.green)
                    : Icon(Icons.close, color: Colors.red);

                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        child: ListTile(
                          leading: icon,
                          title: Text(quizSession.getQuestionLabel(question.key)),
                        )
                      );
                    },
                    body: Container(
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey))
                        ),
                        child: Column(
                          children: question.value.options.asMap().entries.map(
                            (option) {
                              Icon icon = Icon(null);
                              if (!quizSession.questions[question.key].isCorrect() && quizSession.questions[question.key].userAnswer == option.key) {
                                icon = Icon(Icons.close, color: Colors.red);
                              }
                              else if (quizSession.questions[question.key].answer == option.key) {
                                icon = Icon(Icons.check, color: Colors.green);
                              }

                              return ListTile(
                                leading: icon,
                                title: Text(quizSession.getOptionLabel(question.key, option.key)),
                              );
                            }
                          ).toList()
                        )
                      ),
                    isExpanded: isExpandedList[question.key],
                    canTapOnHeader: true
                  );
                }
              ).toList()
            )
          )
        )
      );
  }

  Widget _buildTopSection() {
    int questionAmount = quizSession.questions.length;
    int correctAmount = quizSession.questions.where((x) => x.isCorrect()).length;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('EN → JP'),
                  Text('Common Words'),
                  Text('10 questions')
                ]
              )
            )
          ),
          Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text('Score: $correctAmount/$questionAmount (${(correctAmount/questionAmount*100).toStringAsFixed(1)}%)')
            )
          )
        ]
      )
    );
  }
}