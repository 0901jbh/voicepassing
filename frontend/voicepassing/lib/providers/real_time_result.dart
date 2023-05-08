import 'package:flutter/material.dart';
import 'package:voicepassing/models/receive_message_model.dart';

class RealTimeResult with ChangeNotifier {
  ReceiveMessageModel _result = ReceiveMessageModel(
    totalCategory: -1,
    totalCategoryScore: -1,
    results: [
      Result(
        sentCategory: 1,
        sentCategoryScore: 0,
        sentKeyword: '',
        keywordScore: 0,
        sentence: '',
      ),
    ],
  );
  ReceiveMessageModel get result => _result;

  void update(ReceiveMessageModel nextResult) {
    _result = nextResult;
    notifyListeners();
  }
}
