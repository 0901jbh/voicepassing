import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionChecker {
  Future<List<bool>> isPermissioned() async {
    List<bool> result = [];

    result.add(await Permission.phone.isDenied);
    result.add(await Permission.manageExternalStorage.isDenied);
    result.add(!(await FlutterOverlayWindow.isPermissionGranted()));
    result.add(!await AwesomeNotifications().isNotificationAllowed());
    return result;
  }

  Future<bool> isGranted() async {
    if ((await isPermissioned()).contains(true)) {
      return false;
    }
    return true;
  }
}
