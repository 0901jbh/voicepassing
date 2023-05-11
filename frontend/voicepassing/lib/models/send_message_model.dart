class SendMessageModel {
  int state;
  String androidId;
  String? phoneNumber;

  SendMessageModel({
    required this.state,
    required this.androidId,
    this.phoneNumber,
  });

  factory SendMessageModel.fromJson(Map<String, dynamic> jsonData) {
    return SendMessageModel(
      state: jsonData['state'],
      androidId: jsonData['androidId'],
      phoneNumber: jsonData['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'androidId': androidId,
      'phoneNumber': phoneNumber,
    };
  }
}
