import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/core/theme/app_theme.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
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
          if (currentCity != null) {
            await controller.selectCity(currentCity);
            Get.back();
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
                                currentCity?.city ?? 'Detecting location...',
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
                      ? Icons.check_circle
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
