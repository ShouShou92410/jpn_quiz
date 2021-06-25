import 'enumerations.dart';

const Map<QuizFormat, String> QUIZ_FORMAT_OPTIONS = {
  QuizFormat.en_jp: 'EN → JP',
  QuizFormat.jp_en: 'JP → EN'
};

const Map<QuizCategory, String> QUIZ_CATEGORY_OPTIONS = {
  QuizCategory.common: 'Common Words',
  QuizCategory.n5: 'N5',
  QuizCategory.n4: 'N4',
  QuizCategory.n3: 'N3',
  QuizCategory.n2: 'N2',
  QuizCategory.n1: 'N1'
};
const Map<QuizCategory, int> QUIZ_CATEGORY_MAX_PAGE = {
  QuizCategory.common: 1000,
  QuizCategory.n5: 33,
  QuizCategory.n4: 29,
  QuizCategory.n3: 89,
  QuizCategory.n2: 90,
  QuizCategory.n1: 172
};