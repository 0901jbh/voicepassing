import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';

class WearService extends StatefulWidget {
  const WearService({Key? key}) : super(key: key);

  @override
  State<WearService> createState() => _MyAndroidAppState();
}

class _MyAndroidAppState extends State<WearService> {
  final FlutterWearOsConnectivity _flutterWearOsConnectivity =
      FlutterWearOsConnectivity();
  List<WearOsDevice> _deviceList = [];
  WearOsDevice? _selectedDevice;
  WearOSMessage? _currentMessage;
  DataItem? _dataItem;
  final List<StreamSubscription<WearOSMessage>> _messageSubscriptions = [];
  final List<StreamSubscription<List<DataEvent>>> _dataEventsSubscriptions = [];
  StreamSubscription<CapabilityInfo>? _connectedDeviceCapabilitySubscription;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _flutterWearOsConnectivity.configureWearableAPI().then((_) {
      _flutterWearOsConnectivity.getConnectedDevices().then((value) {
        _updateDeviceList(value.toList());
      });
      _flutterWearOsConnectivity
          .findCapabilityByName("capability_1")
          .then((info) {
        debugPrint('노드는찾음');
        _updateDeviceList(info!.associatedDevices.toList());
      });
      _flutterWearOsConnectivity.getAllDataItems().then(inspect);
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
    final theme = Theme.of(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _devicesWidget(theme),
                if (_selectedDevice != null) _deviceUtils(theme)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _devicesWidget(ThemeData theme) {
    return Column(
      children: _deviceList.map((info) {
        bool isSelected = info.id == _selectedDevice?.id;
        Color mainColor = !isSelected ? theme.primaryColor : Colors.white;
        Color secondaryColor = isSelected ? theme.primaryColor : Colors.white;
        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(info.name,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: theme.primaryColor)),
                Text("Device ID: ${info.id}"),
                Text("Is nearby: ${info.isNearby}")
              ],
            )),
            CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(isSelected ? "Selected" : "Select",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: secondaryColor)),
                ),
                onPressed: () {
                  setState(() {
                    if (_selectedDevice != null) {
                      _selectedDevice = null;
                      for (var subscription in _messageSubscriptions) {
                        subscription.cancel();
                      }
                      _messageSubscriptions.clear();
                      for (var subscription in _dataEventsSubscriptions) {
                        subscription.cancel();
                      }
                      _dataEventsSubscriptions.clear();
                      return;
                    }
                    _selectedDevice = info;
                    _messageSubscriptions.add(_flutterWearOsConnectivity
                        .messageReceived(
                            pathURI: Uri(
                                scheme: "wear",
                                host: _selectedDevice?.id,
                                path: "/wearos-message-path"))
                        .listen((message) {
                      setState(() {
                        _currentMessage = message;
                      });
                    }));
                    _dataEventsSubscriptions.add(_flutterWearOsConnectivity
                        .dataChanged()
                        .listen((events) {
                      setState(() {
                        if (events[0].dataItem.pathURI.path ==
                            "/data-image-path") {
                          _imageFile = events[0].dataItem.files["sample-image"];
                        }
                        _dataItem = events[0].dataItem;
                      });
                    }));
                  });
                })
          ]),
        );
      }).toList(),
    );
  }

  Widget _deviceUtils(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Received message: ", style: theme.textTheme.titleLarge),
          ..._currentMessage != null
              ? [
                  Text("Raw Data: ${_currentMessage?.data.toString()}"),
                  Text(
                      "Decrypted Data: ${String.fromCharCodes(_currentMessage!.data).toString()}"),
                  Text("Message path: ${_currentMessage!.path}"),
                  Text("Request ID: ${_currentMessage!.requestId}"),
                  Text("Device id: ${_currentMessage!.sourceNodeId}")
                ]
              : [],
          CupertinoButton(
              padding: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Send example message",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
              onPressed: () {
                // Todo:나중에 위험도 숫자로 바꿀것
                List<int> list = "54".codeUnits;
                Uint8List bytes = Uint8List.fromList(list);
                print(_flutterWearOsConnectivity.toString());
                _flutterWearOsConnectivity.sendMessage(
                  bytes,
                  deviceId: _selectedDevice!.id,
                  path: "/data",
                );
                debugPrint('메세지이벤트');
              }),
          Text("Latest sync data: ", style: theme.textTheme.titleLarge),
          ..._dataItem != null
              ? [
                  Text("Raw Data: ${_dataItem!.data.toString()}"),
                  Text("Decrypted Data: ${_dataItem!.mapData["message"]}"),
                  Text("Data path: ${_dataItem!.pathURI.path}"),
                ]
              : [],
          CupertinoButton(
              padding: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Sync current data",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
              onPressed: () {
                _flutterWearOsConnectivity
                    .syncData(path: "/data-image-path", data: {
                  "message":
                      "Data sync by AndroidOS app at ${DateTime.now().millisecondsSinceEpoch}"
                }).then((value) {
                  _flutterWearOsConnectivity
                      .findDataItemOnURIPath(pathURI: value!.pathURI)
                      .then(inspect);
                });
              }),
          if (_imageFile != null) Image.file(_imageFile!),
          CupertinoButton(
              padding: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Pick image and sync image data",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
              onPressed: () async {
                _flutterWearOsConnectivity.syncData(
                  path: "/data-image-path",
                  data: {
                    "message":
                        "Data sync by AndroidOS app at ${DateTime.now().millisecondsSinceEpoch}",
                    "count": 10,
                    "bytearray8": Uint8List(8),
                    "bytearray16": Uint16List(16),
                    "sampleMap": {
                      "message":
                          "Data sync by AndroidOS app at ${DateTime.now().millisecondsSinceEpoch}",
                      "count": 10,
                      "bytearray8": Uint8List(8),
                      "bytearray16": Uint16List(16),
                      "sampleMap": {"key": "sadas"}
                    }
                  },
                );
              }),
        ],
      ),
    );
  }
}
