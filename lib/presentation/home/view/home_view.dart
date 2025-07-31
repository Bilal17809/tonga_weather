import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:tonga_weather/core/theme/app_theme.dart';
import 'package:tonga_weather/presentation/home/controller/home_controller.dart';
import 'package:tonga_weather/animation/view/animated_bg_builder.dart';
import 'package:tonga_weather/presentation/home/view/widgets/weather_body.dart';
import 'package:tonga_weather/presentation/home/view/widgets/weather_header.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/app_drawer.dart';
import '../../../core/global/global_keys/global_key.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, value) async {
        if (didPop) return;
        final shouldExit = await _showExitConfirmation(context);
        if (shouldExit == true) SystemNavigator.pop();
      },
      child: Scaffold(
        key: globalKey,
        drawer: const CustomDrawer(),
        onDrawerChanged: (isOpen) {
          homeController.isDrawerOpen.value = isOpen;
        },
        body: Stack(
          children: [
            AnimatedBgImageBuilder(),
            Column(children: const [WeatherHeader(), WeatherBody()]),
          ],
        ),
        bottomNavigationBar: Obx(() {
          final interstitialReady =
              Get.find<InterstitialAdController>().isAdReady;
          final bannerAdController = Get.find<BannerAdController>();
          final isDrawerOpen = homeController.isDrawerOpen.value;

          if (!interstitialReady && !isDrawerOpen) {
            return bannerAdController.getBannerAdWidget('ad1');
          } else {
            return const SizedBox();
          }
        }),
      ),
    );
  }

  Future<bool?> _showExitConfirmation(BuildContext context) async {
    return await PanaraConfirmDialog.show(
      context,
      title: "Exit App?",
      message: "Do you really want to exit the app?",
      confirmButtonText: "Exit",
      cancelButtonText: "Cancel",
      onTapCancel: () => Navigator.of(context).pop(false),
      onTapConfirm: () => Navigator.of(context).pop(true),
      panaraDialogType: PanaraDialogType.custom,
      color: getSecondaryColor(context),
      barrierDismissible: false,
    );
  }
}
