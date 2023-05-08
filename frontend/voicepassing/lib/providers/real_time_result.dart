import 'package:flutter/material.dart';
import 'package:voicepassing/models/receive_message_model.dart';

class RealTimeResult with ChangeNotifier {
  TotalResult _result = TotalResult(
    totalCategory: -1,
    totalCategoryScore: -1,
    results: [
      ResultItem(
        sentCategory: 1,
        sentCategoryScore: 0,
        sentKeyword: '',
        keywordScore: 0,
        sentence: '',
      ),
    ],
  );
  TotalResult get result => _result;

  void update(TotalResult nextResult) {
    _result = nextResult;
    notifyListeners();
  }
}
