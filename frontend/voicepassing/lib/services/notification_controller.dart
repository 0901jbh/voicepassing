import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:voicepassing/main.dart';
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
            enableVibration: true,
            vibrationPattern: highVibrationPattern,
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
    } else {
      Navigator.pushNamed(
        App.navigatorKey.currentContext!,
        '/realtime',
      );
    }
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
        id: -1,
        channelKey: 'voicepassing',
        color: Colors.white,
        backgroundColor: resultData.result != null &&
                resultData.result!.totalCategoryScore * 100 > 80
            ? ColorStyles.themeRed
            : ColorStyles.themeYellow,
        title: resultData.result != null &&
                resultData.result!.totalCategoryScore * 100 > 80
            ? "<span style='color: #FF525E;'>⚠️보이스피싱 위험도 : ${(resultData.result!.totalCategoryScore * 100).round()}</span>"
            : "<span style='color: #FFC041;'>⚠️보이스피싱 위험도 : ${(resultData.result!.totalCategoryScore * 100).round()}</span>",
        body: resultData.result != null &&
                resultData.result!.totalCategoryScore * 100 > 80
            ? "<span style='color: #FF525E;'>${getKeywords().join(', ')}</span> 등의 단어가 감지되었습니다.<br> 이러한 단어가 사용되는 통화의 경우 보이스피싱의 가능성이 높으니 주의하세요. 자세한 정보를 보시려면 알림을 터치하세요."
            : "<span style='color: #FFC041;'>${getKeywords().join(', ')}</span> 등의 단어가 감지되었습니다.<br> 이러한 단어가 사용되는 통화의 경우 보이스피싱의 가능성이 높으니 주의하세요. 자세한 정보를 보시려면 알림을 터치하세요.",
        notificationLayout: NotificationLayout.BigText,
        payload: {'resultData': jsonEncode(resultData)},
        category: NotificationCategory.Service,
        actionType: ActionType.Default,
      ),
    );
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
