class SendMessageModel {
  int state;
  String androidId;

  SendMessageModel({
    required this.state,
    required this.androidId,
  });

  factory SendMessageModel.fromJson(Map<String, dynamic> jsonData) {
    return SendMessageModel(
      state: jsonData['state'],
      androidId: jsonData['androidId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'androidId': androidId,
    };
  }
}
