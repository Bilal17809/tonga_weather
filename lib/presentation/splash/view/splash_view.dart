import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tonga_weather/core/theme/app_colors.dart';
import 'package:tonga_weather/presentation/home/view/home_view.dart';
import '../../../core/common_widgets/custom_text_button.dart';
import '../../../core/constants/constant.dart';
import '../controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: Get.find<SplashController>(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: kWhite,
          body: Obx(
            () => Center(
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: controller.showButton.value
                    ? AnimatedOpacity(
                        opacity: controller.showButton.value ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 600),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kBodyHp,
                          ),
                          child: CustomButton(
                            width: mobileWidth(context) * 0.6,
                            backgroundColor: secondaryColorLight,
                            textColor: kWhite,
                            onPressed: () async {
                              Get.to(() => HomeView());
                            },
                            text: "Let's Go",
                          ),
                        ),
                      )
                    : LoadingAnimationWidget.fourRotatingDots(
                        color: secondaryColorLight,
                        size: mobileWidth(context) * 0.2,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
