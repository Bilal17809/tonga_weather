import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:tonga_weather/core/theme/app_theme.dart';
import 'package:tonga_weather/presentation/home/controller/home_controller.dart';
import 'package:tonga_weather/presentation/home/view/widgets/weather_body.dart';
import 'package:tonga_weather/presentation/home/view/widgets/weather_header.dart';
import '../../../core/common_widgets/custom_drawer.dart';
import '../../../core/global/global_services/global_key.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, value) async {
        if (didPop) return;
        final shouldExit = await _showExitConfirmation(context);
        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        key: globalKey,
        drawer: const CustomDrawer(),
        onDrawerChanged: (isOpen) {
          homeController.isDrawerOpen.value = isOpen;
        },
        body: Column(
          children: const [
            WeatherHeader(),
            Expanded(child: SingleChildScrollView(child: WeatherBody())),
          ],
        ),
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
