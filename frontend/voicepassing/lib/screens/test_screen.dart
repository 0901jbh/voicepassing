import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Are you here?');
    // final receivedAction =
    //     ModalRoute.of(context)?.settings.arguments ? ModalRoute.of(context)?.settings.arguments as ReceivedAction : null;
    // ReceiveMessageModel res = ReceiveMessageModel.fromJson(
    //     jsonDecode(receivedAction.payload!['resultData']!));
    return const Scaffold(
      body: Center(
        // child: Text(res.result!.totalCategoryScore.toString()),
        child: Text('dsafewfer'),
      ),
    );
  }
}
