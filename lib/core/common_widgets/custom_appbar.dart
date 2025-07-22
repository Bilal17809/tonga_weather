import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../theme/app_theme.dart';
import 'icon_buttons.dart';
import '../constants/constant.dart';

class CustomAppBar extends StatelessWidget {
  final List<Widget>? actions;
  final String? title;
  final String subtitle;
  final bool useBackButton;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    super.key,
    required this.subtitle,
    this.useBackButton = true,
    this.actions,
    this.onBackTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasTitle = title != null;

    return SafeArea(
      child: Padding(
        padding: kContentPaddingSmall,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            useBackButton
                ? IconActionButton(
                    isCircular: true,
                    backgroundColor: primaryColorLight,
                    onTap: () => Get.back(),
                    icon: Icons.arrow_back,
                    color: getTextColor(context),
                    size: secondaryIcon(context) * 0.6,
                  )
                : IconActionButton(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    icon: Icons.menu,
                    color: getIconColor(context),
                    size: secondaryIcon(context),
                  ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasTitle)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: getIconColor(context),
                            size: secondaryIcon(context),
                          ),
                        ],
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasTitle)
                          Text(title!, style: titleBoldMediumStyle(context)),
                        Text(
                          subtitle,
                          style: (hasTitle
                              ? bodyMediumStyle(context)
                              : titleBoldMediumStyle(context)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}
