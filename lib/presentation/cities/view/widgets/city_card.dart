import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/theme/theme.dart';
import '/core/constants/constant.dart';
import '/core/services/services.dart';
import '/presentation/home/controller/home_controller.dart';
import '../../controller/cities_controller.dart';
import '/data/model/city_model.dart';

class CityCard extends StatelessWidget {
  final CitiesController controller;
  final CityModel city;

  const CityCard({super.key, required this.controller, required this.city});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() {
      final isCurrentlySelectedCity =
          homeController.selectedCity.value?.city == city.cityAscii;
      final weather =
          controller.conditionController.allCitiesWeather[city.cityAscii];
      final temp = weather?.temperature.round().toString() ?? '--';
      final condition = weather?.condition ?? 'Loading...';
      final airQuality = weather?.airQuality != null
          ? 'AQI ${weather!.airQuality!.calculatedAqi} - ${weather.airQuality!.category}'
          : 'Loading...';

      return GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();
          await controller.selectCity(city);
          if (controller.splashController.selectedCity.value != null &&
              LocationUtilsService.fromCityModel(
                    controller.splashController.selectedCity.value!,
                  ) ==
                  LocationUtilsService.fromCityModel(city)) {
            Future.delayed(const Duration(milliseconds: 160), () {
              Get.back(result: city);
            });
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: kElementGap),
          decoration: roundedStylizedDecor(context).copyWith(
            gradient: isDarkMode(context) ? null : kContainerGradient(context),
            color: isDarkMode(context)
                ? secondaryColorLight.withValues(alpha: 0.35)
                : null,
            border: isCurrentlySelectedCity
                ? Border.all(color: getSecondaryColor(context), width: 2)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(kBodyHp),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            city.city,
                            style: titleSmallBoldStyle(
                              context,
                            ).copyWith(color: kWhite),
                          ),
                          const SizedBox(width: kElementWidthGap),
                          Icon(
                            isCurrentlySelectedCity
                                ? Icons.my_location
                                : Icons.location_on,
                            color: kWhite,
                            size: smallIcon(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: kElementInnerGap),
                      Text(
                        airQuality,
                        style: bodyMediumStyle(context).copyWith(color: kWhite),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$temp°',
                        style: headlineMediumStyle(
                          context,
                        ).copyWith(color: kWhite),
                      ),
                      Text(
                        condition,
                        style: bodyMediumStyle(context).copyWith(color: kWhite),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
