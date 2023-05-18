import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/services/permissionChecker.dart';
import 'package:voicepassing/services/set_stream.dart';
import 'package:voicepassing/style/color_style.dart';

class RequestPermissionsScreen extends StatefulWidget {
  final bool? fromMain;

  const RequestPermissionsScreen({super.key, this.fromMain});

  @override
  State<RequestPermissionsScreen> createState() =>
      _RequestPermissionsScreenState();
}

class _RequestPermissionsScreenState extends State<RequestPermissionsScreen> {
  Future<void> requestPermissions() async {
    var result = await PermissionChecker().isPermissioned();
    if (result[0]) {
      await Permission.phone.request();
    }
    if (true) {
      await Permission.manageExternalStorage.request();
    }
    if (true) {
      await FlutterOverlayWindow.requestPermission();
    }
    if (result[3]) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    setStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: ColorStyles.textDarkGray,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    '약관 및 개인정보 처리 동의',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 27,
              ),
              Expanded(
                child: Container(
                  child: const SingleChildScrollView(
                    child: Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                  text:
                                      '이 약관은 A607에 의해 제공되는 Voice Passing(이하 "어플")의 사용 조건과 개인정보 처리에 대해 설명합니다. 어플을 사용함으로써 이 약관에 동의하고 아래의 개인정보 처리 방식에 동의하는 것입니다. 이 약관을 주의 깊게 읽어보시고, 동의하지 않을 경우 어플의 사용을 중단해주시기 바랍니다.\n\n'),
                              TextSpan(
                                text: '1. 서비스 개요\n',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                  text:
                                      '1.1 어플은 Voice Passing 기능을 제공하여 통화 내용 데이터를 확인하고 관리할 수 있습니다. 사용자는 어플을 통해 통화 내용 데이터를 효율적으로 관리할 수 있습니다.\n\n'),
                              TextSpan(
                                text: '2. 개인정보 수집 및 이용\n',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                  text:
                                      '2.1 어플은 Voice Passing 기능을 위해 다음과 같은 권한을 필요로 합니다: "전화", "파일 및 미디어", "알림", "다른 앱 위에 표시". 이러한 권한은 통화 내용 데이터를 확인하고 처리하기 위해 필요합니다.\n'),
                              TextSpan(
                                  text:
                                      '2.2 A607은 사용자의 개인정보를 보호하기 위해 관련 법령과 정책을 준수합니다. 사용자의 개인정보는 안전하게 저장되며, 무단으로 제3자에게 제공되지 않습니다. 개인정보 처리에 대한 자세한 내용은 개인정보 처리 방침을 읽고 이해해주시기 바랍니다.\n\n'),
                              TextSpan(
                                text: '3. 서비스 이용 제한\n',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                  text:
                                      '3.1 어플의 일부 기능은 사용자의 개인정보 동의에 따라 제한될 수 있습니다. 개인정보 수집에 대한 동의를 거부할 경우, 해당 기능의 이용이 제한될 수 있습니다.\n\n'),
                              TextSpan(
                                text: '4. 개인정보의 보유 및 삭제\n',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                  text:
                                      '4.1 A607은 사용자의 개인정보를 사용자가 동의한 목적 범위 내에서만 보유합니다. 개인정보 보유 기간은 개인정보 처리 방침에서 정하는 바에 따릅니다. 사용자가 동의를 철회하거나 서비스 해지를 요청한 경우, A607은 즉시 해당 사용자의 개인정보를 삭제합니다.'),
                            ],
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 27,
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      await requestPermissions();
                      if (widget.fromMain == null) {
                        Navigator.pop(context);
                      }
                      final loadedData = await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorStyles.themeLightBlue),
                      overlayColor:
                          MaterialStateProperty.all(ColorStyles.themeSkyBlue),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      fixedSize: MaterialStateProperty.all(
                        Size.fromWidth(MediaQuery.of(context).size.width),
                      ),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(10)),
                    ),
                    child: const Text(
                      '동의하고 계속하기',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorStyles.subGray),
                      overlayColor:
                          MaterialStateProperty.all(ColorStyles.subLightGray),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      fixedSize: MaterialStateProperty.all(
                        Size.fromWidth(MediaQuery.of(context).size.width),
                      ),
                      minimumSize: MaterialStateProperty.all(Size.zero),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(10)),
                    ),
                    child: const Text(
                      '동의하지 않고 계속하기',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
