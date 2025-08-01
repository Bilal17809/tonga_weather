import 'package:flutter/material.dart';
import '/core/constants/constant.dart';
import 'theme.dart';

TextStyle headlineLargeStyle(BuildContext context) => TextStyle(
  fontSize: mobileHeight(context) * 0.14,
  fontWeight: FontWeight.w700,
  color: getTextColor(context),
  shadows: kShadow,
);

TextStyle headlineMediumStyle(BuildContext context) => TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w700,
  color: getTextColor(context),
);

TextStyle headlineSmallStyle(BuildContext context) => TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w500,
  color: getTextColor(context),
);

TextStyle titleBoldMediumStyle(BuildContext context) => TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: getTextColor(context),
);

TextStyle titleBoldLargeStyle(BuildContext context) => TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: getTitleTextColor(context),
);

TextStyle titleSmallStyle(BuildContext context) => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: getTextColor(context),
);

TextStyle titleSmallBoldStyle(BuildContext context) => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: getTextColor(context),
);

TextStyle bodyLargeStyle(BuildContext context) => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: getTextColor(context),
);

TextStyle bodyMediumStyle(BuildContext context) => TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: getSubTextColor(context),
);

TextStyle bodyBoldMediumStyle(BuildContext context) => TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: getSubTextColor(context),
);

TextStyle bodyBoldSmallStyle(BuildContext context) => TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: getTextColor(context),
);
final List<Shadow> kShadow = [
  Shadow(
    offset: Offset(3, 3),
    blurRadius: 4,
    color: kBlack.withValues(alpha: 0.7),
  ),
];
