import 'package:flutter/material.dart';
import 'package:voicepassing/screens/analytics_screen.dart';
import 'package:voicepassing/screens/connect_wearable_screen.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/screens/request_permissions_screen.dart';
import 'package:voicepassing/screens/result_screen.dart';
import 'package:voicepassing/screens/search_screen.dart';
import 'package:voicepassing/screens/setting_screen.dart';
import 'package:voicepassing/screens/statics_screen.dart';
import 'package:voicepassing/screens/test_screen.dart';

class Routes {
  Routes._();

  static const String main = '/main';
  static const String result = '/result';
  static const String search = '/seasrch';
  static const String statistics = '/statistics';
  static const String analytics = '/analytics';
  static const String setting = '/setting';
  static const String permission = '/permission';
  static const String wearable = '/wearable';
  static const String realtime = '/realtime';

  static final routes = <String, WidgetBuilder>{
    '/main': (context) => const MainScreen(),
    '/result': (context) => const ResultScreen(),
    '/search': (context) => const SearchScreen(),
    '/statistics': (constext) => const StaticsScreen(),
    '/analytics': (context) => const AnalyticsScreen(),
    '/setting': (context) => const SettingScreen(),
    '/permission': (context) => const RequestPermissionsScreen(),
    '/wearable': (context) => const ConnectWearableScreen(),
    '/realtime': (context) => const TestScreen(),
  };
}
