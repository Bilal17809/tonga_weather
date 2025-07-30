import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tonga_weather/presentation/splash/view/splash_view.dart';
import 'ads_manager/app_open_ads.dart';
import 'ads_manager/banner_ads.dart';
import 'ads_manager/interstitial_ads.dart';
import 'ads_manager/splash_interstitial.dart';
import 'core/binders/dependency_injection.dart';
import 'core/local_storage/local_storage.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  Get.put(AppOpenAdController());
  DependencyInjection.init();
  Get.put(SplashInterstitialAdController());
  Get.put(BannerAdController());
  Get.put(InterstitialAdController());
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
