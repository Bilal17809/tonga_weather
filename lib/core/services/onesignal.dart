import 'dart:io';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OnesignalService {
  static Future<void> init() async {
    if (Platform.isAndroid) {
      OneSignal.initialize("957552b2-1643-4005-a7c0-ddf13a7cb342");
      await OneSignal.Notifications.requestPermission(true);
    } else if (Platform.isIOS) {
      OneSignal.initialize("63ee6b62-850f-4126-b21a-a264c8ae7cc4");
      await OneSignal.Notifications.requestPermission(true);
    } else {
      debugPrint("Platform not supported");
    }
  }
}
