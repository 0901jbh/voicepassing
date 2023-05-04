class SendMessageModel {
  int stateCode;
  String androidId;

  SendMessageModel({
    required this.stateCode,
    required this.androidId,
  });

  factory SendMessageModel.fromJson(Map<String, dynamic> jsonData) {
    return SendMessageModel(
      stateCode: jsonData['stateCode'],
      androidId: jsonData['androidId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stateCode': stateCode,
      'androidId': androidId,
    };
  }
}
