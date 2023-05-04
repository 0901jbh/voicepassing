class ResultModel {
  final double score;
  final DateTime date;
  // category
  final String type;
  final List<String> words, sentences;
  final String androidId;
  final String phoneNumber;

  ResultModel(this.score, this.date, this.type, this.words, this.sentences,
      this.androidId, this.phoneNumber);
}
