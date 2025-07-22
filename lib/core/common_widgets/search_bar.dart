import 'package:flutter/material.dart';
import '../constants/constant.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'common_text_field.dart';

class SearchBarField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String value) onSearch;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final String? fontFamily;

  const SearchBarField({
    super.key,
    required this.controller,
    required this.onSearch,
    this.backgroundColor = transparent,
    this.borderColor = primaryColorLight,
    this.iconColor = kWhite,
    this.textColor = kBlack,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      controller: controller,
      hintText: 'Search',
      textStyle: bodyBoldMediumStyle(
        context,
      ).copyWith(color: textColor, fontFamily: fontFamily),
      hintStyle: bodyBoldMediumStyle(context).copyWith(
        color: textColor.withValues(alpha: 0.7),
        fontFamily: fontFamily,
      ),
      cursorColor: textColor,
      backgroundColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kCircularBorderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      onChanged: onSearch,
      onSubmitted: onSearch,
      prefixIcon: Icon(Icons.search, color: iconColor, size: 24),
    );
  }
}
