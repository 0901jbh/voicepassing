import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SelectedWearable with ChangeNotifier {
  String? _deviceId;

  String? get deviceId => _deviceId;

  void update(String newDeviceId) {
    _deviceId = newDeviceId;
    notifyListeners();
  }
}
