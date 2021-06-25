import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:math';

import '../../constants.dart';
import '../../enumerations.dart';
import 'Question.dart';
import 'Vocabulary.dart';

class QuizSession {
  static const int MAXREQUEST = 5;
  static const int MAXPAGEITEM = 20;
  static const int MAXPAGE = 1000;
  static const int MAXID = 20000;

  static const int OPTIONAMOUNT = 4;

  final QuizFormat format;
  final QuizCategory category;
  final int questionAmount;
  final Function refresh;

  List<Question> questions = [];
  int currentQuestion = 0;

  QuizSession(this.format, this.category, this.questionAmount, this.refresh);

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

  Question getCurrentQuestion() =>
    questions[currentQuestion];

  bool nextQuestion() {
    if (currentQuestion == questionAmount - 1) {
      return false;
    }
    else {
      currentQuestion++;
      refresh();
      return true;
    }
  }

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

  String getFormatLabel() =>
    '${QUIZ_FORMAT_OPTIONS[format]}';

  String getCategoryLabel() =>
    '${QUIZ_CATEGORY_OPTIONS[category]}';

  String getQuestionAmountLabel() =>
    '$questionAmount questions';

  String getCurrentQuestionLabel() =>
    getQuestionLabel(currentQuestion);

  String getCurrentQuestionOptionLabel(int optionIndex) =>
    getOptionLabel(currentQuestion, optionIndex);

  String getQuestionLabel(int questionIndex) {
    Vocabulary word = questions[questionIndex].getAnswer();

    switch (format) {
      case QuizFormat.en_jp:
        return word.english;
      case QuizFormat.jp_en:
        return word.kanji == null ? word.kana : '${word.kanji}(${word.kana})';
      default:
        return "";
    }
  }

  String getOptionLabel(int questionIndex, int optionIndex) {
    Vocabulary word = questions[questionIndex].options[optionIndex];

    switch (format) {
      case QuizFormat.en_jp:
        return word.kanji == null ? word.kana : '${word.kanji}(${word.kana})';
      case QuizFormat.jp_en:
        return word.english;
      default:
        return "";
    }
  }
}