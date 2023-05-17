import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsAnalyzing with ChangeNotifier {
  bool _isAnalyzing = false;

  bool get isAnalyzing => _isAnalyzing;

  void on() {
    _isAnalyzing = true;
    notifyListeners();
  }

  void off() {
    _isAnalyzing = false;
    notifyListeners();
  }
}
