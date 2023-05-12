import 'package:flutter/material.dart';
import 'package:voicepassing/screens/main_screen.dart';

import 'widgets/alarm_widget/alarm_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/config/.env');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const App(),
  );
}

// 오버레이 위젯 설정
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AlarmWidget(),
    ),
  );
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
      home: Scaffold(
        body: MainScreen(),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
            // bodyText1: TextStyle(fontSize: 20),
            // bodyText2: TextStyle(fontSize: 20),
            ),
        fontFamily: 'NotoSansKR',
      ),
    );
  }
}
