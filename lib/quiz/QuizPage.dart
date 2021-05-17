import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:math';

import 'QuizState.dart';
import 'QuizSettings.dart';
import 'QuizInProgress.dart';
import 'QuizResult.dart';

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
    Function handleStart = (int format, int category, int questionAmount) async {
      quizSession = new QuizSession(format, category, questionAmount);
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
        title = 'Quiz - In Progress...';
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

class QuizSession {
  static const int MAXREQUEST = 5;
  static const int MAXPAGEITEM = 20;
  static const int MAXPAGE = 1000;
  static const int MAXID = 20000;

  static const int OPTIONAMOUNT = 4;

  final int format;
  final int category;
  final int questionAmount;

  List<Question> questions = [];

  QuizSession(this.format, this.category, this.questionAmount);

    //todo: Update Random question generation
  Future<void> generateQuestions() async {
    Random rand = new Random();

    List<Vocabulary> vocabularies = [];
    for (var i = 0; i < MAXREQUEST; i++) {
      int page = rand.nextInt(MAXPAGE-1) + 1;
      Uri uri = Uri.https('cors-anywhere.herokuapp.com', 'https://jisho.org/api/v1/search/words', {'keyword': '#common', 'page': page.toString()});   // For dev
      // Uri uri = Uri.https('jisho.org', 'api/v1/search/words', {'keyword': '#common', 'page': page.toString()});
      Response response = await http.get(uri);
      vocabularies.addAll(_parseResponse(response.body));
    }

    for (var i = 0; i < questionAmount; i++) {
      int answer = rand.nextInt(OPTIONAMOUNT);
      List<Vocabulary> options = [];

      for (var j = 0; j < OPTIONAMOUNT; j++) {
        int index = rand.nextInt(vocabularies.length);
        options.add(vocabularies.removeAt(index));
      }

      this.questions.add(new Question(answer, options));
    }
  }

  int _getPageById(int id) => 
    (id ~/ MAXPAGEITEM) + 1;

  int _getLocalIdById(int id) =>
    id % MAXPAGEITEM;

  List<Vocabulary> _parseResponse(String body) {
    Map<String, dynamic> json = jsonDecode(body);
    List<Vocabulary> result = [];
    for (var item in json['data']) {
      if (Vocabulary.isValid(item)) {
        result.add(Vocabulary.fromJson(item));
      }
    }
    return result;
  }

  String getQuestionLabel(int index) {
    Vocabulary word = questions[index].getAnswer();

    switch (format) {
      case 0:
        return word.english;
      case 1:
        return word.kanji == null ? word.kana : '${word.kanji}(${word.kana})';
      default:
        return "";
    }
  }

  String getOptionLabel(int questionIndex, int index) {
    Vocabulary word = questions[questionIndex].options[index];

    switch (format) {
      case 0:
        return word.kanji == null ? word.kana : '${word.kanji}(${word.kana})';
      case 1:
        return word.english;
      default:
        return "";
    }
  }
}

class Question {
  final int answer;
  final List<Vocabulary> options;
  int userAnswer;

  Question(this.answer, this.options);

  Vocabulary getAnswer() =>
    options[answer];

  Vocabulary getUserAnswer() =>
    options[userAnswer];

  void submit(int value) {
    userAnswer = value;
  }

  bool isCorrect() =>
    userAnswer == answer;

  String toString() => '{answer: $answer, userAnswer: $userAnswer, options: $options}';
}

class Vocabulary {
  final String english;
  final String kana;
  final String kanji;

  Vocabulary(this.english, this.kana, this.kanji);

  factory Vocabulary.fromJson(dynamic json) {
    String english = json['senses'][0]['english_definitions'][0];
    String kana = json['japanese'][0]['reading'];
    String kanji = json['japanese'][0]['word'];

    if (json['senses'][0]['part_of_speech'] == 'Numeric') {
      english = json['senses'][0]['english_definitions'][1];
      kanji = json['slug'];
    }

    return Vocabulary(english, kana, kanji);
  }

  static bool isValid(dynamic json) {
    RegExp number = new RegExp(r'[0-9]');

    return 
      json['is_common'] == true; //&& !json['slug'].contains(number);
  }

  String toString() => '{english: $english, kana: $kana, kanji: $kanji}';
}