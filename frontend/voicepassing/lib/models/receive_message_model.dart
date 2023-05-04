class ReceiveMessageModel {
  int totalCategory;
  double totalCategoryScore;
  late List<Result?> results;

  ReceiveMessageModel({
    required this.totalCategory,
    required this.totalCategoryScore,
    required this.results,
  });

  factory ReceiveMessageModel.fromJson(Map<String, dynamic> jsonData) {
    return ReceiveMessageModel(
      totalCategory: jsonData['totalCategory'],
      totalCategoryScore: jsonData['totalCategoryScore'],
      results: jsonData['results'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCategory': totalCategory,
      'totalCategoryScore': totalCategoryScore,
      'results': results,
    };
  }
}

class Result {
  int sentCategory;
  double sentCategoryScore;
  String sentKeyword;
  double keywordScore;
  String sentence;

  Result({
    required this.sentCategory,
    required this.sentCategoryScore,
    required this.sentKeyword,
    required this.keywordScore,
    required this.sentence,
  });
}
