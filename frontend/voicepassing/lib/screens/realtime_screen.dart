import 'package:flutter/material.dart';
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
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RealtimeHeadwidget(),
                SizedBox(height: 30),
                RealtimeBodyWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
