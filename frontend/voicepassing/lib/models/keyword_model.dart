class KeywordModel {
  final List keywordSentence1;
  final List keywordSentence2;
  final List keywordSentence3;

  const KeywordModel(
      {required this.keywordSentence1,
      required this.keywordSentence2,
      required this.keywordSentence3});

  factory KeywordModel.fromJson(Map<String, dynamic> json) {
    return KeywordModel(
      keywordSentence1: json["1"],
      keywordSentence2: json["2"],
      keywordSentence3: json["3"],
    );
  }
}
