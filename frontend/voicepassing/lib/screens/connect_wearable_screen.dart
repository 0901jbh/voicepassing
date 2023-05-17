import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:voicepassing/providers/selected_wearable.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/head_bar.dart';

class ConnectWearableScreen extends StatefulWidget {
  const ConnectWearableScreen({super.key});

  @override
  State<ConnectWearableScreen> createState() => _ConnectWearableScreenState();
}

class _ConnectWearableScreenState extends State<ConnectWearableScreen> {
  final FlutterWearOsConnectivity _flutterWearOsConnectivity =
      FlutterWearOsConnectivity();
  List<WearOsDevice> _deviceList = [];
  WearOsDevice? _selectedDevice;
  WearOSMessage? _currentMessage;
  DataItem? _dataItem;
  final List<StreamSubscription<WearOSMessage>> _messageSubscriptions = [];
  final List<StreamSubscription<List<DataEvent>>> _dataEventsSubscriptions = [];
  StreamSubscription<CapabilityInfo>? _connectedDeviceCapabilitySubscription;
  bool isLoaded = false;
  Iterable<CapabilityInfo> caps = [];

  @override
  void initState() {
    super.initState();
  }

  void findAvailableDevices() {
    _flutterWearOsConnectivity.configureWearableAPI().then((_) {
      _flutterWearOsConnectivity.getConnectedDevices().then((value) {
        _updateDeviceList(value.toList());
      });
      // _flutterWearOsConnectivity.getAllCapabilities().then((value) {
      //   setState(() {
      //     caps = value.values;
      //   });
      // });
      _flutterWearOsConnectivity.registerNewCapability('capability_1');
      _flutterWearOsConnectivity
          .findCapabilityByName("capability_1")
          .then((info) {
        debugPrint('노드는찾음');
        _updateDeviceList(info!.associatedDevices.toList());
      });
      // _flutterWearOsConnectivity.getAllDataItems().then(inspect);
      _connectedDeviceCapabilitySubscription = _flutterWearOsConnectivity
          .capabilityChanged(
              capabilityPathURI: Uri(
                  scheme: "wear", // Default scheme for WearOS app
                  host: "*", // Accept all path
                  path: "/data" // Capability path
                  ))
          .listen((info) {
        if (info.associatedDevices.isEmpty) {
          setState(() {
            _selectedDevice = null;
          });
        }
        _updateDeviceList(info.associatedDevices.toList());
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _flutterWearOsConnectivity.dispose();
    _clearAllListeners();
  }

  _clearAllListeners() {
    _connectedDeviceCapabilitySubscription?.cancel();
  }

  void _updateDeviceList(List<WearOsDevice> devices) {
    setState(() {
      _deviceList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadBar(
        navPage: MainScreen(),
        title: const Text('웨어러블 기기 연결'),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: !isLoaded
                ? TextButton(
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
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(10)),
                    ),
                    onPressed: () async {
                      if (await Permission.bluetoothScan.isGranted == false) {
                        await Permission.bluetoothScan.request();
                      }
                      if (await Permission.bluetoothConnect.isGranted ==
                          false) {
                        await Permission.bluetoothConnect.request();
                      }
                      if (await Permission.bluetoothAdvertise.isGranted ==
                          false) {
                        await Permission.bluetoothAdvertise.request();
                      }
                      findAvailableDevices();
                      setState(() {
                        isLoaded = true;
                      });
                    },
                    child: const Text(
                      '웨어러블 기기 연결하기',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                : _deviceList.isEmpty
                    ? const Center(
                        child: Text('스마트폰과 연결된 기기가 없습니다.'),
                      )
                    : Column(
                        children: [
                          for (var device in _deviceList)
                            TextButton(
                              onPressed: () async {
                                context
                                    .read<SelectedWearable>()
                                    .update(device.id);

                                FlutterWearOsConnectivity()
                                    .registerNewCapability('capability_1');
                              },
                              child: Text(device.name),
                            ),
                          TextButton(
                            onPressed: () async {
                              if (context.read<SelectedWearable>().deviceId !=
                                  null) {
                                List<int> list = '65'.codeUnits;
                                Uint8List bytes = Uint8List.fromList(list);
                                await _flutterWearOsConnectivity.sendMessage(
                                  bytes,
                                  deviceId: context
                                      .read<SelectedWearable>()
                                      .deviceId!,
                                  path: '/data',
                                );
                              }
                            },
                            child: Text(
                                context.watch<SelectedWearable>().deviceId ??
                                    'none'),
                          ),
                          Text(caps.toString()),
                        ],
                      ),
          );
        },
      ),
    );
  }
}
