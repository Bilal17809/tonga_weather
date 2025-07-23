import 'package:flutter/material.dart';

/// ========== Theme Related ==========
bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

const fontPrimary = 'Montserrat';
const fontSecondary = 'Poppins';

/// ========== Padding ==========
const double kBodyHp = 16.0;
const double kElementGap = 12.0;
const double kElementInnerGap = 8.0;
const double kElementWidthGap = 10.0;
const kContentPaddingSmall = EdgeInsets.symmetric(horizontal: 12, vertical: 4);
const kContentPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 4);

/// ========== Margins ==========
const kPaginationMargin = EdgeInsets.symmetric(horizontal: 3);

/// ========== Border ==========
const double kBorderRadius = 8.0;
const double kCircularBorderRadius = 50.0;

/// ========== Icon Sizes ==========
double primaryIcon(BuildContext context) => mobileWidth(context) * 0.24;
double secondaryIcon(BuildContext context) => mobileWidth(context) * 0.075;
double smallIcon(BuildContext context) => mobileWidth(context) * 0.06;

/// ========== MediaQuery Helpers ==========
double mobileWidth(BuildContext context) => MediaQuery.of(context).size.width;
double mobileHeight(BuildContext context) => MediaQuery.of(context).size.height;
