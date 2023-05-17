import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicepassing/providers/selected_wearable.dart';
import 'package:voicepassing/routes.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/services/notification_controller.dart';

import 'widgets/alarm_widget/alarm_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/config/.env');
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SelectedWearable()),
      ],
      child: const App(),
    ),
  );
}

// 오버레이 위젯 설정
@pragma("vm:entry-point")
void overlayMain() async {
  await dotenv.load(fileName: 'assets/config/.env');
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotifications();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AlarmWidget(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    NotificationController.startListeningNotificationEvents();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: App.navigatorKey,
      routes: Routes.routes,
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
            child: child!);
      },
      home: const Scaffold(
        body: MainScreen(),
        // body: Column(children: [children: ],)
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
