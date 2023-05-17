import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voicepassing/models/receive_message_model.dart';

class RealtimeProvider with ChangeNotifier {
  final List<ReceiveMessageModel> _realtimeDataList = [];

  List<ReceiveMessageModel> get realtimeDataList => _realtimeDataList;

  void add(ReceiveMessageModel newData) {
    _realtimeDataList.add(newData);
    notifyListeners();
  }
}
