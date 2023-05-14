import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/style/color_style.dart';

///  *********************************************
///     NOTIFICATION CONTROLLER
///  *********************************************
///
class NotificationController {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
            channelKey: 'voicepassing',
            channelName: 'voicepassing',
            channelDescription: 'voicepassing',
            playSound: false,
            onlyAlertOnce: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: ColorStyles.themeLightBlue,
            ledColor: ColorStyles.themeLightBlue,
          ),
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      debugPrint(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
    } else {}
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    debugPrint("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    debugPrint(re.body);
    debugPrint("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification(
      ReceiveMessageModel resultData) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) return;

    List<String> getKeywords() {
      List<String> keywords = [];
      if (resultData.result != null &&
          resultData.result!.results != null &&
          resultData.result!.results!.isNotEmpty) {
        var rawData = resultData.result!.results!;
        rawData
            .sort((a, b) => a.sentCategoryScore.compareTo(b.sentCategoryScore));
        if (rawData.length > 3) {
          for (var item in rawData.sublist(0, 3)) {
            keywords.add(item.sentKeyword);
          }
        } else {
          for (var item in rawData) {
            keywords.add(item.sentKeyword);
          }
        }
      }
      return keywords;
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1, // -1 is replaced by a random number
        channelKey: 'alerts',
        color: Colors.white,
        backgroundColor: resultData.result != null &&
                resultData.result!.totalCategoryScore * 100 > 70
            ? ColorStyles.themeRed
            : ColorStyles.themeYellow,
        title: '⚠️현재 통화가 보이스피싱으로 의심됩니다',
        body: resultData.result != null &&
                resultData.result!.totalCategoryScore * 100 > 70
            ? "상대방이 <span style='color: #FF525E;'>${getKeywords().join(', ')}</span> 등의 단어를 사용하는 경우 보이스피싱의 가능성이 높으니 주의하세요"
            : "상대방이 <span style='color: #FFC041;'>${getKeywords().join(', ')}</span> 등의 단어를 사용하는 경우 보이스피싱의 가능성이 높으니 주의하세요",
        bigPicture:
            'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
        largeIcon:
            'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
        //'asset://assets/images/balloons-in-sky.jpg',
        notificationLayout: NotificationLayout.BigText,
        payload: {'notificationId': '1234567890'},
        category: NotificationCategory.Service,
        // criticalAlert:
      ),
      // actionButtons: [
      //   NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
      //   NotificationActionButton(
      //       key: 'REPLY',
      //       label: 'Reply Message',
      //       requireInputText: true,
      //       actionType: ActionType.SilentAction),
      //   NotificationActionButton(
      //       key: 'DISMISS',
      //       label: 'Dismiss',
      //       actionType: ActionType.DismissAction,
      //       isDangerousOption: true)
      // ],
    );
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
