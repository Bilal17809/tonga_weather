import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/theme/theme.dart';
import 'package:tonga_weather/presentation/cities/view/widgets/city_card.dart';
import 'package:tonga_weather/presentation/cities/view/widgets/current_location_card.dart';
import '/core/animation/view/animated_bg_builder.dart';
import '/ads_manager/ads_manager.dart';
import 'package:tonga_weather/core/common_widgets/common_widgets.dart';
import '/core/constants/constant.dart';
import '../controller/cities_controller.dart';

class CitiesView extends StatelessWidget {
  const CitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final CitiesController controller = Get.find();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedBgImageBuilder(),
            SafeArea(
              child: Column(
                children: [
                  TitleBar(subtitle: 'Manage Cities'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      kBodyHp,
                      kBodyHp,
                      kBodyHp,
                      0,
                    ),
                    child: Obx(() {
                      final dark = isDarkMode(context);
                      return SearchBarField(
                        controller: controller.searchController,
                        onSearch: (value) => controller.searchCities(value),
                        backgroundColor: dark
                            ? kWhite.withValues(alpha: 0.3)
                            : getPrimaryColor(context),
                        borderColor: controller.hasSearchError.value
                            ? kRed
                            : getSecondaryColor(context),
                        iconColor: controller.hasSearchError.value
                            ? kRed
                            : getSecondaryColor(context),
                        textColor: getTextColor(context),
                      );
                    }),
                  ),
                  Obx(
                    () => controller.hasSearchError.value
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(
                              kBodyHp,
                              kElementInnerGap,
                              kBodyHp,
                              0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: kRed,
                                  size: smallIcon(context),
                                ),
                                const SizedBox(width: kElementWidthGap),
                                Expanded(
                                  child: Text(
                                    controller.searchErrorMessage.value,
                                    style: bodyBoldSmallStyle(
                                      context,
                                    ).copyWith(color: kRed),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      kBodyHp,
                      kBodyHp,
                      kBodyHp,
                      0,
                    ),
                    child: CurrentLocationCard(controller: controller),
                  ),
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          kBodyHp,
                          0,
                          kBodyHp,
                          0,
                        ),
                        itemCount: controller.filteredCities.length,
                        itemBuilder: (BuildContext context, index) {
                          final city = controller.filteredCities[index];
                          return CityCard(controller: controller, city: city);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(() {
          final interstitialManager = Get.find<InterstitialAdManager>();
          final bannerAdManager = Get.find<BannerAdManager>();
          return interstitialManager.isShow.value
              ? const SizedBox()
              : bannerAdManager.showBannerAd('ad3');
        }),
      ),
    );
  }
}
