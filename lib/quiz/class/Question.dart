import 'Vocabulary.dart';

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