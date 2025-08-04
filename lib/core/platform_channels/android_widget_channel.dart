import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '/core/services/services.dart';

class WidgetUpdateManager {
  static Timer? _timer;

  static void startPeriodicUpdate() async {
    _timer?.cancel();
    if (!await WidgetUpdaterService.isWidgetActive()) return;

    await _waitForWeatherData();
    updateWeatherWidget();

    _timer = Timer.periodic(const Duration(minutes: 15), (_) {
      updateWeatherWidget();
    });
  }

  static Future<void> _waitForWeatherData() async {
    final controller = Get.find<ConditionService>();
    for (var i = 0; i < 60; i++) {
      if (controller.mainCityWeather.value != null &&
          controller.mainCityName.value.isNotEmpty &&
          controller.mainCityName.value != 'Loading...' &&
          controller.weeklyForecast.isNotEmpty) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  static void updateWeatherWidget() {
    try {
      final controller = Get.find<ConditionService>();
      final weather = controller.mainCityWeather.value;
      final city = controller.mainCityName.value;

      if (weather == null || city.isEmpty || city == 'Loading...') return;

      WidgetUpdaterService.updateWidget({
        'cityName': city,
        'temperature': weather.temperature.round().toString(),
        'condition': weather.condition,
        'iconUrl': weather.iconUrl,
        'minTemp': controller.minTemp,
        'maxTemp': controller.maxTemp,
      });
    } catch (e) {
      debugPrint("Widget update failed: $e");
    }
  }

  static void stopPeriodicUpdate() => _timer?.cancel();
}

class WidgetUpdaterService {
  static const _channel = MethodChannel('com.unisoftapps.tonga_weather/widget');

  static Future<void> updateWidget(Map<String, String> data) async {
    try {
      await _channel.invokeMethod('updateWidget', data);
    } catch (e) {
      debugPrint("Widget update error: $e");
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
      if (call.method == "widgetTapped") {
        WidgetUpdateManager.startPeriodicUpdate();
      }
    });
  }
}
