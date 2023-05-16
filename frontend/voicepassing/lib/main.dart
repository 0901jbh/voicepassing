import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepassing/routes.dart';
import 'package:voicepassing/screens/main_screen.dart';
// import 'package:voicepassing/services/notification_controller.dart';

import 'widgets/alarm_widget/alarm_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/config/.env');
  WidgetsFlutterBinding.ensureInitialized();
  // await NotificationController.initializeLocalNotifications();
  runApp(
    const App(),
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: false,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  debugPrint('Flutter Background Service');
}

// 오버레이 위젯 설정
@pragma("vm:entry-point")
void overlayMain() async {
  await dotenv.load(fileName: 'assets/config/.env');
  WidgetsFlutterBinding.ensureInitialized();
  // await NotificationController.initializeLocalNotifications();
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
      routes: Routes.routes,
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
            child: child!);
      },
      home: Scaffold(
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
