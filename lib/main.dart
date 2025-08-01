import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tonga_weather/core/services/aqi_service.dart';
import 'package:tonga_weather/presentation/splash/view/splash_view.dart';
import 'ads_manager/app_open_ads.dart';
import 'core/binders/dependency_injection.dart';
import 'core/local_storage/local_storage.dart';
import '/core/theme/theme.dart';
import 'core/services/weather_codes_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await WeatherCodesLoader.loadWeatherCodes();
  await AqiService.initialize();
  Get.put(AppOpenAdManager());
  DependencyInjection.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final storage = LocalStorage();
  final isDark = await storage.getBool('isDarkMode');
  runApp(
    TongaWeather(
      themeMode: isDark == true
          ? ThemeMode.dark
          : isDark == false
          ? ThemeMode.light
          : ThemeMode.system,
    ),
  );
}

class TongaWeather extends StatelessWidget {
  final ThemeMode themeMode;
  const TongaWeather({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Estonia Weather',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashView(),
    );
  }
}
