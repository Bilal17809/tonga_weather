import 'package:flutter/material.dart';

/// ========== Padding ==========
const double kBodyHp = 16.0;
const double kElementGap = 12.0;
const double kElementInnerGap = 8.0;
const double kElementWidthGap = 10.0;

/// ========== Border ==========
const double kBorderRadius = 8.0;
const double kCircularBorderRadius = 50.0;

/// ========== Icon Sizes ==========
double primaryIcon(BuildContext context) => mobileWidth(context) * 0.34;
double secondaryIcon(BuildContext context) => mobileWidth(context) * 0.075;
double mediumIcon(BuildContext context) => mobileWidth(context) * 0.1;
double smallIcon(BuildContext context) => mobileWidth(context) * 0.06;

/// ========== MediaQuery Helpers ==========
double mobileWidth(BuildContext context) => MediaQuery.of(context).size.width;
double mobileHeight(BuildContext context) => MediaQuery.of(context).size.height;
