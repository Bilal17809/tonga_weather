import 'dart:io';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OnesignalService {
  static Future<void> init() async {
    if (Platform.isAndroid) {
      OneSignal.initialize("f7c3a91b-c522-4730-a7bd-2554bd9d1822");
      await OneSignal.Notifications.requestPermission(true);
    } else if (Platform.isIOS) {
      OneSignal.initialize("54df0907-3214-46d8-ba21-82405aea910a");
      await OneSignal.Notifications.requestPermission(true);
    } else {
      debugPrint("Platform not supported");
    }
  }
}
