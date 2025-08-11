import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '/core/services/services.dart';
import '/presentation/splash/controller/splash_controller.dart';

class WidgetUpdateManager {
  static Timer? _timer;

  static void startPeriodicUpdate() async {
    _timer?.cancel();
    if (!await WidgetUpdaterService.isWidgetActive()) return;
    updateWeatherWidget();
    _timer = Timer.periodic(const Duration(minutes: 10), (_) {
      updateWeatherWidget();
    });
  }

  static void updateWeatherWidget() {
    try {
      final splashController = Get.find<SplashController>();
      final conditionService = Get.find<ConditionService>();
      final selectedCity = splashController.selectedCity.value;
      if (selectedCity == null) return;

      final weather = conditionService.allCitiesWeather[selectedCity.cityAscii];
      if (weather == null) return;

      String minTemp = '--';
      String maxTemp = '--';
      if (conditionService.weeklyForecast.isNotEmpty) {
        final today = conditionService.weeklyForecast.firstWhere(
          (d) => d['day'] == 'Today',
          orElse: () => conditionService.weeklyForecast.first,
        );
        minTemp = today['minTemp']?.round()?.toString() ?? '--';
        maxTemp = today['temp']?.round()?.toString() ?? '--';
      }
      WidgetUpdaterService.updateWidget({
        'cityName': selectedCity.city,
        'temperature': weather.temperature.round().toString(),
        'condition': weather.condition,
        'iconUrl': weather.iconUrl,
        'minTemp': minTemp,
        'maxTemp': maxTemp,
      });
    } catch (e) {
      debugPrint("Widget update failed: $e");
    }
  }

  static void stopPeriodicUpdate() => _timer?.cancel();
}

class WidgetUpdaterService {
  static const _channel = MethodChannel(
    'com.unisoftapps.tongaweatherforecast/widget',
  );
  static Future<void> updateWidget(Map<String, String> data) async {
    try {
      await _channel.invokeMethod('updateWidget', data);
    } catch (e) {
      debugPrint("Widget update error: $e");
    }
  }

  static Future<void> requestPinWidget() async {
    try {
      await _channel.invokeMethod('requestPinWidget');
    } catch (e) {
      debugPrint("Error requesting widget pin: $e");
    }
  }

  static Future<bool> isWidgetActive() async {
    try {
      return await _channel.invokeMethod('isWidgetActive') ?? false;
    } catch (_) {
      return false;
    }
  }

  static void setupMethodChannelHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "widgetTapped":
          debugPrint("Widget tapped => Triggering update...");
          WidgetUpdateManager.startPeriodicUpdate();
          break;
        default:
          debugPrint("Unhandled method: ${call.method}");
      }
    });
  }
}
