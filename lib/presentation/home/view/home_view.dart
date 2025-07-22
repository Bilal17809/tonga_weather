import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:tonga_weather/core/common_widgets/custom_appbar.dart';
import 'package:tonga_weather/presentation/home/controller/home_controller.dart';
import '../../../core/common_widgets/custom_drawer.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global/global_services/global_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../gen/assets.gen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    //ignore:deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        bool? exit = await PanaraConfirmDialog.show(
          context,
          title: "Exit App?",
          message: "Do you really want to exit the app?",
          confirmButtonText: "Exit",
          cancelButtonText: "Cancel",
          onTapCancel: () => Navigator.pop(context, false),
          onTapConfirm: () => SystemNavigator.pop(),
          panaraDialogType: PanaraDialogType.custom,
          color: primaryColorLight,
          barrierDismissible: false,
        );
        return exit ?? false;
      },
      child: Scaffold(
        key: globalKey,
        drawer: const CustomDrawer(),
        onDrawerChanged: (isOpen) {
          homeController.isDrawerOpen.value = isOpen;
        },
        body: Column(
          children: [
            Container(
              decoration: roundedBottomDecor(context),
              child: SafeArea(
                child: Column(
                  children: [
                    CustomAppBar(
                      useBackButton: false,
                      title: 'ISLAMABAD',
                      subtitle: '22/07/2025',
                      actions: [
                        IconActionButton(
                          onTap: () {},
                          // onTap: () => Get.to(const CitiesView()),
                          icon: Icons.add,
                          color: getIconColor(context),
                          size: secondaryIcon(context),
                        ),
                      ],
                    ),
                    Padding(
                      padding: kContentPadding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Assets.cloudy.path,
                            width: primaryIcon(context),
                          ),
                          SizedBox(width: kElementGap),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('22', style: headlineLargeStyle(context)),
                              Text('°', style: headlineLargeStyle(context)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: kContentPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: roundedDecor(context),
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'High : 29° C',
                                    style: titleSmallBoldStyle(context),
                                  ),
                                  Icon(Icons.north_east, color: kWhite),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: kElementGap),
                          Expanded(
                            child: Container(
                              decoration: roundedDecor(context),
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Low : 20° C',
                                    style: titleSmallBoldStyle(context),
                                  ),
                                  Icon(Icons.south_east, color: kRed),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kElementGap),
                    Padding(
                      padding: kContentPadding,
                      child: Container(
                        decoration: roundedDecor(context),
                        height: 74,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Humidity',
                                  style: bodyLargeStyle(context),
                                ),
                                Text(
                                  '60%',
                                  style: titleSmallBoldStyle(context),
                                ),
                              ],
                            ),
                            VerticalDivider(
                              color: kWhite,
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Wind', style: bodyLargeStyle(context)),
                                Text(
                                  '19/kmh',
                                  style: titleSmallBoldStyle(context),
                                ),
                              ],
                            ),
                            VerticalDivider(
                              color: kWhite,
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Rain', style: bodyLargeStyle(context)),
                                Text(
                                  '24%',
                                  style: titleSmallBoldStyle(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kElementGap),
            Column(
              children: [
                Image.asset(
                  Assets.homeIcon.path,
                  width: mobileWidth(context) * 0.5,
                ),
                const SizedBox(height: kElementGap),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 24,
                    itemBuilder: (context, index) {
                      final todayMidnight = DateTime.now().copyWith(
                        hour: 0,
                        minute: 0,
                      );
                      final hour = todayMidnight.add(Duration(hours: index));
                      final hourLabel = TimeOfDay.fromDateTime(
                        hour,
                      ).format(context);

                      return HourlyForecast(
                        day: hourLabel,
                        isSelected: index == 0,
                        isFirst: index == 0,
                        isLast: index == 23,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HourlyForecast extends StatelessWidget {
  final String day;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  // final ForecastModel? forecastData;

  const HourlyForecast({
    super.key,
    required this.day,
    required this.isSelected,
    this.isFirst = false,
    this.isLast = false,
    // this.forecastData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mobileWidth(context) * 0.2,
      margin: EdgeInsets.only(
        left: isFirst ? kBodyHp : 0,
        right: isLast ? kBodyHp : kElementGap,
      ),
      padding: const EdgeInsets.symmetric(vertical: kBodyHp),
      decoration: roundedSelectionDecoration(context, isSelected: isSelected),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                day,
                style: titleSmallBoldStyle(context).copyWith(color: kWhite),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: kElementInnerGap),
            // forecastData?.iconUrl.isNotEmpty == true
            //     ? Image.network(
            //   forecastData!.iconUrl,
            //   width: primaryIcon(context),
            //   height: primaryIcon(context),
            //   fit: BoxFit.contain,
            // )
            //      :
            Icon(Icons.wb_sunny, size: primaryIcon(context), color: kWhite),
            const SizedBox(height: kElementInnerGap),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                // forecastData != null
                //     ? '${forecastData!.maxTemp.round()}°/${forecastData!.minTemp.round()}°'
                //      :
                '0°/0°',
                style: titleSmallBoldStyle(context).copyWith(color: kWhite),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
