import 'package:flutter/foundation.dart';

enum MyRoutes { 
  home, 
  quiz,
  about 
}

enum QuizState {
  setting,
  inProgress,
  result
}

enum QuizFormat{
  en_jp,
  jp_en
}

enum QuizCategory{
  common,
  n5,
  n4,
  n3,
  n2,
  n1
}
extension QuizCategoryEx on QuizCategory {
  String get getString => describeEnum(this);
}