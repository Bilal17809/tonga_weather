import 'package:flutter/material.dart';
import '../constants/constant.dart';
import 'app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColorLight,
    scaffoldBackgroundColor: lightBgColor,
    colorScheme: ColorScheme.light(
      primary: primaryColorLight,
      secondary: secondaryColorLight,
      surface: lightBgColor,
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: textWhiteColor),
      bodyMedium: TextStyle(color: textWhiteColor),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    scaffoldBackgroundColor: darkBgColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColorDark,
      secondary: secondaryColorDark,
      surface: darkBgColor,
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: textBlackColor),
      bodyMedium: TextStyle(color: textGreyColor),
    ),
  );
}

//decoration
BoxDecoration roundedDecor(BuildContext context) => BoxDecoration(
  color: getSecondaryColor(context),
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: isDarkMode(context)
          ? darkBgColor.withValues(alpha: 0.3)
          : secondaryColorLight.withValues(alpha: 0.3),
      blurRadius: 6,
      spreadRadius: 1,
      offset: Offset(0, 2),
    ),
  ],
);
BoxDecoration roundedForecastDecor(BuildContext context) => BoxDecoration(
  color: isDarkMode(context)
      ? secondaryColorLight.withValues(alpha: 0.6)
      : kWhite,
  borderRadius: BorderRadius.circular(10),
);

BoxDecoration roundedStylizedDecor(BuildContext context) => BoxDecoration(
  color: getSecondaryColor(context),
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(24),
    bottomLeft: Radius.circular(24),
  ),
  boxShadow: [
    BoxShadow(
      color: isDarkMode(context)
          ? darkBgColor.withValues(alpha: 0.3)
          : secondaryColorLight.withValues(alpha: 0.3),
      blurRadius: 6,
      spreadRadius: 1,
      offset: Offset(0, 2),
    ),
  ],
);

BoxDecoration roundedBottomDecor(BuildContext context) => BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
    colors: isDarkMode(context)
        ? [kWhite.withValues(alpha: 0.1), kWhite.withValues(alpha: 0.2)]
        : [getPrimaryColor(context), getSecondaryColor(context)],
    stops: [0.15, 1.0],
  ),
  borderRadius: const BorderRadius.only(
    bottomLeft: Radius.circular(50),
    bottomRight: Radius.circular(50),
  ),
  boxShadow: [
    BoxShadow(
      color: isDarkMode(context)
          ? darkBgColor.withValues(alpha: 0.3)
          : primaryColorLight.withValues(alpha: 0.15),
      blurRadius: 6,
      spreadRadius: 1,
      offset: Offset(0, 1),
    ),
  ],
);

BoxDecoration roundedSelectionDecoration(
  BuildContext context, {
  required bool isSelected,
}) {
  final isDark = isDarkMode(context);

  return BoxDecoration(
    color: isDark
        ? (isSelected
              ? kWhite.withValues(alpha: 0.5)
              : kWhite.withValues(alpha: 0.25))
        : (isSelected ? Color(0xFF8ABAF3) : Color(0xFF538ED9)),
    borderRadius: BorderRadius.circular(28),
    boxShadow: [
      BoxShadow(
        color: isDark
            ? darkBgColor.withValues(alpha: 0.3)
            : primaryColorLight.withValues(alpha: 0.3),
        blurRadius: 6,
        spreadRadius: 1,
        offset: Offset(0, 2),
      ),
    ],
  );
}

Color getPrimaryColor(BuildContext context) =>
    isDarkMode(context) ? primaryColorDark : primaryColorLight;

Color getSecondaryColor(BuildContext context) => isDarkMode(context)
    ? secondaryColorDark.withValues(alpha: 0.1)
    : secondaryColorLight;

Color getBgColor(BuildContext context) =>
    isDarkMode(context) ? darkBgColor : lightBgColor;

Color getTextColor(BuildContext context) =>
    isDarkMode(context) ? textWhiteColor : textWhiteColor;

Color getTitleTextColor(BuildContext context) =>
    isDarkMode(context) ? textWhiteColor : primaryColorLight;

// Color getButtonTextColor(BuildContext context) =>
//     isDarkMode(context) ? kWhite : secondaryColorLight;

Color getSubTextColor(BuildContext context) =>
    isDarkMode(context) ? textWhiteColor : kBlack;

Color getIconColor(BuildContext context) =>
    isDarkMode(context) ? kWhite : kWhite;

LinearGradient kGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: isDarkMode(context)
        ? [kWhite.withValues(alpha: 0.08), kWhite.withValues(alpha: 0.06)]
        : [primaryColorLight, secondaryColorLight],
    stops: [0.3, 0.95],
  );
}

LinearGradient kContainerGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: isDarkMode(context)
        ? [kWhite, kWhite.withValues(alpha: 0.75)]
        : [primaryColorLight, secondaryColorLight],
    stops: [0.05, 0.85],
  );
}
