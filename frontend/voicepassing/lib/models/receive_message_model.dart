class ReceiveMessageModel {
  bool isFinish;
  TotalResult result;

  ReceiveMessageModel({
    required this.isFinish,
    required this.result,
  });

  factory ReceiveMessageModel.fromJson(Map<String, dynamic> jsonData) {
    return ReceiveMessageModel(
      isFinish: jsonData['isFinish'],
      result: jsonData['result'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isFinish': isFinish,
      'result': result,
    };
  }
}

class TotalResult {
  int totalCategory;
  double totalCategoryScore;
  late List<ResultItem?> results;

  TotalResult({
    required this.totalCategory,
    required this.totalCategoryScore,
    required this.results,
  });
}

class ResultItem {
  int sentCategory;
  double sentCategoryScore;
  String sentKeyword;
  double keywordScore;
  String sentence;

  ResultItem({
    required this.sentCategory,
    required this.sentCategoryScore,
    required this.sentKeyword,
    required this.keywordScore,
    required this.sentence,
  });
}
