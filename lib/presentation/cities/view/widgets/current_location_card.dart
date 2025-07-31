import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'package:tonga_weather/core/common_widgets/custom_toast.dart';
import 'package:tonga_weather/core/theme/app_theme.dart';
import '/core/common/app_exceptions.dart';
import '/core/constants/constant.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_styles.dart';
import '/core/theme/context.dart';
import '../../../home/controller/home_controller.dart';
import '../../controller/cities_controller.dart';

class CurrentLocationCard extends StatelessWidget {
  final CitiesController controller;
  const CurrentLocationCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();

    return Obx(() {
      final currentCity = homeController.currentLocationCity;
      final isCurrentlySelected =
          homeController.selectedCity.value?.city == currentCity?.city;

      return GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();
          if (currentCity != null) {
            await controller.selectCity(currentCity);
            Future.delayed(const Duration(milliseconds: 160), () {
              Get.back(result: currentCity);
            });
          } else {
            SimpleToast.showCustomToast(
              context: context,
              message: AppExceptions().deniedPermission,
              type: ToastificationType.error,
              icon: Icons.location_off,
              primaryColor: kRed,
            );
            return;
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: kBodyHp * 1.5),
          decoration: roundedDecor(context).copyWith(
            gradient: isDarkMode(context)
                ? kContainerGradient(context)
                : kGradient(context),
            borderRadius: BorderRadius.circular(24),
            border: isCurrentlySelected
                ? Border.all(color: getSecondaryColor(context), width: 2)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(kBodyHp),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.my_location,
                            color: kWhite,
                            size: smallIcon(context),
                          ),
                          const SizedBox(width: kElementWidthGap),
                          Expanded(
                            child: Text(
                              'Use Current Location',
                              style: titleSmallBoldStyle(
                                context,
                              ).copyWith(color: kWhite),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: kElementInnerGap),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                currentCity?.city ?? 'Error Fetching City',
                                style: bodyLargeStyle(context).copyWith(
                                  color: kWhite.withValues(alpha: 0.8),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isCurrentlySelected
                      ? Icons.my_location
                      : Icons.location_searching,
                  color: kWhite,
                  size: smallIcon(context),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
