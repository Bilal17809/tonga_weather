import 'package:flutter/material.dart';
import 'package:tonga_weather/core/theme/app_theme.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../controller/cities_controller.dart';

class CurrentLocationCard extends StatelessWidget {
  final CitiesController controller;

  const CurrentLocationCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // await controller.addCurrentLocationToSelected(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: kBodyHp * 1.5),
        decoration: roundedDecor(context).copyWith(
          gradient: isDarkMode(context)
              ? kContainerGradient(context)
              : kGradient(context),
          // : LinearGradient(
          //     begin: Alignment.bottomCenter,
          //     end: Alignment.topCenter,
          //     colors: [
          //       kOrange.withValues(alpha: 0.9),
          //       kOrange.withValues(alpha: 0.6),
          //     ],
          //     stops: [0.3, 0.85],
          //   ),
          borderRadius: BorderRadius.circular(24),
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
                            'Get Current Location',
                            style: titleSmallBoldStyle(
                              context,
                            ).copyWith(color: kWhite),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Islamabad',
                        style: bodyLargeStyle(
                          context,
                        ).copyWith(color: kWhite.withValues(alpha: 0.8)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Obx(() {
                    //   final currentCity = 'Tallinn';
                    //   // controller.homeController.currentLocationCity;
                    //   if (currentCity != null) {
                    //     return Padding(
                    //       padding: const EdgeInsets.only(top: 4),
                    //       child: Text(
                    //         'Tallinn',
                    //         // currentCity.city,
                    //         style: bodyLargeStyle(
                    //           context,
                    //         ).copyWith(color: kWhite.withValues(alpha: 0.8)),
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     );
                    //   }
                    //   return const SizedBox.shrink();
                    // }),
                  ],
                ),
              ),
              Icon(
                Icons.add_location,
                color: kWhite,
                size: smallIcon(context) * 0.8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
