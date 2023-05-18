import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/providers/realtime_provider.dart';
import 'package:voicepassing/widgets/realtime_widget/list_item_widget.dart';
import 'package:voicepassing/widgets/realtime_widget/loading_list_widget.dart';

class RealtimeBodyWidget extends StatefulWidget {
  const RealtimeBodyWidget({super.key});

  @override
  State<RealtimeBodyWidget> createState() => _RealtimeBodyWidgetState();
}

class _RealtimeBodyWidgetState extends State<RealtimeBodyWidget> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<RealtimeProvider>().realtimeDataList;
    return SizedBox(
      width: double.infinity,
      child: Column(children: [
        for (ReceiveMessageModel item in data)
          if (item.result!.totalCategory >= 1) ...[
            ListItemWidget(jsonData: item),
            const SizedBox(height: 12),
          ],
        const LoadingListWidget(),
      ]),
    );
  }
}
