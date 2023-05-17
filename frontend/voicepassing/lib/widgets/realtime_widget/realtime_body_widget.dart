import 'package:flutter/material.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/realtime_widget/loading_list_widget.dart';

class RealtimeBodyWidget extends StatefulWidget {
  const RealtimeBodyWidget({super.key});

  @override
  State<RealtimeBodyWidget> createState() => _RealtimeBodyWidgetState();
}

class _RealtimeBodyWidgetState extends State<RealtimeBodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorStyles.themeLightBlue),
      width: double.infinity,
      child: const Column(children: [
        LoadingListWidget(),
      ]),
    );
  }
}
