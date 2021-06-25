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