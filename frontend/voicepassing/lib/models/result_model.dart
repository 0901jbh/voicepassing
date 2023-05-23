class ResultModel {
  final double? score;
  final String? date;
  // category
  final int? type;
  final List<String>? words, sentences;
  final String? androidId;
  final String? phoneNumber;
  final List<double>? scores;

  ResultModel.toJson(Map<String, dynamic> json)
      : score = json['risk'] ?? 75.0,
        type = json['category'] ?? 0,
        date = json['createdTime'] ?? DateTime(2023).toString(),
        words = json['keyword'] != null
            ? List<String>.from(json['keyword'])
            : ['단어'],
        sentences = json['sentence'] != null
            ? List<String>.from(json['sentence'])
            : ['단어를 포함한 문장'],
        androidId = json['androidId'] ?? '',
        phoneNumber = json['phoneNumber'] ?? '',
        scores = json['scores'] != null
            ? List<double>.from(json['scores'])
            : List.filled(List<String>.from(json['sentence']).length, 0.7);

  ResultModel.fromJson(Map<String, dynamic> json)
      : score = json['result']?['totalCategoryScore'] ?? 75.0,
        type = json['result']?['totalCategory'] ?? 0,
        date = json['createdTime'] ?? DateTime.now().toString(),
        words = json['result']?['results'] != null &&
                json['result']?['results'].isNotEmpty
            ? List<String>.from(json['result']['results']
                .map((result) => result['sentKeyword']))
            : ['단어'],
        sentences = json['result']?['results'] != null &&
                json['result']?['results'].isNotEmpty
            ? List<String>.from(
                json['result']['results'].map((result) => result['sentence']))
            : ['단어를 포함한 문장'],
        androidId = json['androidId'] ?? '',
        phoneNumber = json['phoneNumber'] ?? '',
        scores = json['result']?['results'] != null &&
                json['result']?['results'].isNotEmpty
            ? List<double>.from(json['result']['results']
                .map((result) => result['sentCategoryScore']))
            : [0.0];
}
