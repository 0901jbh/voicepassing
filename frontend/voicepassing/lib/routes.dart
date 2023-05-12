import 'package:flutter/material.dart';
import 'package:voicepassing/screens/analytics_screen.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/screens/result_screen.dart';
import 'package:voicepassing/screens/search_screen.dart';
import 'package:voicepassing/screens/statics_screen.dart';

class Routes {
  Routes._();

  static const String main = '/main';
  static const String result = '/result';
  static const String search = '/seasrch';
  static const String statistics = '/statistics';
  static const String analytics = '/analytics';

  static final routes = <String, WidgetBuilder>{
    '/main': (context) => MainScreen(),
    '/result': (context) => const ResultScreen(),
    '/search': (context) => const SearchScreen(),
    '/statistics': (constext) => const StaticsScreen(),
    '/analytics': (context) => const AnalyticsScreen(),
  };
}
