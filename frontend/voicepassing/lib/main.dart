import 'package:flutter/material.dart';
import 'package:voicepassing/screens/main_screen.dart';

import '../widgets/alarm_widget/real_time_result_widget.dart';

// 오버레이 위젯 설정
@pragma("vm:entry-point")
void overlayMain() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RealTimeResultWidget(),
    ),
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
            child: child!);
      },
      home: const Scaffold(
        body: MainScreen(),
      ),
      theme: ThemeData(
        textTheme: const TextTheme(

            // bodyText1: TextStyle(fontSize: 20),
            // bodyText2: TextStyle(fontSize: 20),
            ),
      ),
    );
  }
}
