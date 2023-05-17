import 'package:flutter/material.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/widgets/head_bar.dart';
import 'package:voicepassing/widgets/realtime_widget/realtime_body_widget.dart';
import 'package:voicepassing/widgets/realtime_widget/realtime_head_widget.dart';

class RealtimeScreen extends StatefulWidget {
  const RealtimeScreen({super.key});

  @override
  State<RealtimeScreen> createState() => _RealtimeScreenState();
}

class _RealtimeScreenState extends State<RealtimeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadBar(
        navPage: MainScreen(),
        title: const Text('실시간 통화 분석'),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return const SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                RealtimeHeadwidget(),
                SizedBox(height: 20),
                RealtimeBodyWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
