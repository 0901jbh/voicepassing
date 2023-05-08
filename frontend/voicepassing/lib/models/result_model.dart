class ResultModel {
  final double? score;
  final String? date;
  // category
  final int? type;
  final List<String>? words, sentences;
  final String? androidId;
  final String? phoneNumber;

  ResultModel.toJson(Map<String, dynamic> json)
      : score = json['risk'] ?? 75.0,
        type = json['category'] ?? 0,
        date = json['createdTime'] ?? DateTime(2023).toString(),
        words = List<String>.from(json['keyword']) ?? ['단어'],
        sentences = List<String>.from(json['sentence']) ?? ['단어를 포함한 문장'],
        androidId = json['androidId'] ?? '',
        phoneNumber = json['phoneNumber'] ?? '';
}