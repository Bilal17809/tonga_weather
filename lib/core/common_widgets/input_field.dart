import 'package:flutter/material.dart';
import '../constants/constant.dart';
import '/core/theme/theme.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final InputBorder? border;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Color? cursorColor;
  final Color? backgroundColor;

  const InputField({
    super.key,
    required this.controller,
    this.hintText = 'Enter text...',
    this.minLines = 1,
    this.maxLines = 1,
    this.contentPadding = const EdgeInsets.all(kBodyHp),
    this.hintStyle,
    this.textStyle,
    this.border,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.onSubmitted,
    this.cursorColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: cursorColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor ?? kWhite.withValues(alpha: 0.2),
        hintText: hintText,
        hintStyle:
            hintStyle ??
            bodyBoldSmallStyle(context).copyWith(color: primaryColorLight),
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(kCircularBorderRadius),
              borderSide: BorderSide(color: primaryColorLight),
            ),
        enabledBorder:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(kCircularBorderRadius),
              borderSide: BorderSide(color: primaryColorLight),
            ),
        focusedBorder:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(kCircularBorderRadius),
              borderSide: BorderSide(color: primaryColorLight, width: 2),
            ),
      ),
      style:
          textStyle ??
          bodyBoldSmallStyle(context).copyWith(color: primaryColorLight),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
