class ReceiveMessageModel {
  late TotalResult? result;
  late bool isFinish;

  ReceiveMessageModel({
    required this.result,
    required this.isFinish,
  });

  ReceiveMessageModel.fromJson(Map<String, dynamic> jsonData) {
    result = jsonData['result'] != null
        ? TotalResult.fromJson(jsonData['result'])
        : null;
    isFinish = jsonData['isFinish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['isFinish'] = isFinish;
    return data;
  }
}

class TotalResult {
  late int totalCategory;
  late double totalCategoryScore;
  late List<ResultItem>? results;

  TotalResult({
    required this.totalCategory,
    required this.totalCategoryScore,
    required this.results,
  });

  TotalResult.fromJson(Map<String, dynamic> jsonData) {
    totalCategory = jsonData['totalCategory'];
    totalCategoryScore = jsonData['totalCategoryScore'];
    if (jsonData['results'] != null) {
      results = <ResultItem>[];
      jsonData['results'].forEach((item) {
        results!.add(ResultItem.fromJson(item));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalCategory'] = totalCategory;
    data['totalCategoryScore'] = totalCategoryScore;
    if (results != null) {
      data['results'] = results!.map((item) => item.toJson()).toList();
    }
    return data;
  }
}

class ResultItem {
  late int sentCategory;
  late double sentCategoryScore;
  late String sentKeyword;
  late double keywordScore;
  late String sentence;

  ResultItem({
    required this.sentCategory,
    required this.sentCategoryScore,
    required this.sentKeyword,
    required this.keywordScore,
    required this.sentence,
  });

  ResultItem.fromJson(Map<String, dynamic> jsonData) {
    sentCategory = jsonData['sentCategory'];
    sentCategoryScore = jsonData['sentCategoryScore'];
    sentKeyword = jsonData['sentKeyword'];
    keywordScore = jsonData['keywordScore'];
    sentence = jsonData['sentence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sentCategory'] = sentCategory;
    data['sentCategoryScore'] = sentCategoryScore;
    data['sentKeyword'] = sentKeyword;
    data['keywordScore'] = keywordScore;
    data['sentence'] = sentence;
    return data;
  }
}
