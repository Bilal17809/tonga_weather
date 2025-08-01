import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tonga_weather/presentation/home/view/home_view.dart';
import '../../../core/animation/view/animated_weather_icon.dart';
import '/core/constants/constant.dart';
import '../controller/splash_controller.dart';
import 'package:tonga_weather/core/common_widgets/common_widgets.dart';
import '/core/theme/theme.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();
    return Scaffold(
      backgroundColor: kWhite,
      body: Obx(
        () => Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/splash.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kBodyHp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: kElementInnerGap),
                  Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'TONGA',
                          style: headlineLargeStyle(
                            context,
                          ).copyWith(color: kOrange, fontSize: 80),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: AnimatedDefaultTextStyle(
                          style: headlineLargeStyle(context).copyWith(
                            color: controller.title.value,
                            fontSize: 100,
                          ),
                          duration: const Duration(milliseconds: 1500),
                          child: Text.rich(TextSpan(text: 'Weather')),
                        ),
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: List.generate(
                        'Real Time Tonga Forecast Updates'.length,
                        (index) {
                          final isVisible =
                              index < controller.visibleLetters.value;
                          return TextSpan(
                            text: 'Real Time Tonga Forecast Updates'[index],
                            style: titleSmallStyle(
                              context,
                            ).copyWith(color: isVisible ? kWhite : transparent),
                          );
                        },
                      ),
                    ),
                  ),
                  AnimatedWeatherIcon(
                    imagePath: 'images/splash-icon.png',
                    condition: 'thunderstorm',
                    width: mobileHeight(context) * 0.3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: mobileHeight(context) * 0.12,
                    ),
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
                                  width: mobileWidth(context) * 0.4,
                                  height: 50,
                                  backgroundColor: kOrange,
                                  shadowColor: kDarkOrange,
                                  textColor: kBlack,
                                  onPressed: () async {
                                    Get.to(() => HomeView());
                                  },
                                  text: "Let's Go",
                                ),
                              ),
                            )
                          : LoadingAnimationWidget.hexagonDots(
                              color: kOrange,
                              size: mobileWidth(context) * 0.1,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
