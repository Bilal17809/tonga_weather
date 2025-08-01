import 'package:flutter/material.dart';
import '../constants/constant.dart';
import '/core/theme/theme.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double? height;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? shadowColor;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.textColor,
    this.backgroundColor,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = width ?? double.infinity;
    final double buttonHeight = height ?? 48;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -8,
          right: -8,
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            decoration: BoxDecoration(
              color: shadowColor ?? kBlack,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor ?? primaryColorLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: onPressed,
            child: Text(
              text,
              style: titleSmallBoldStyle(
                context,
              ).copyWith(color: textColor ?? kWhite),
            ),
          ),
        ),
      ],
    );
  }
}

class IconActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color color;
  final double? size;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final bool isCircular;

  const IconActionButton({
    super.key,
    this.onTap,
    required this.icon,
    required this.color,
    this.size,
    this.padding = const EdgeInsets.all(kElementInnerGap),
    this.backgroundColor,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size ?? secondaryIcon(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircular
              ? null
              : BorderRadius.circular(kBorderRadius),
        ),
        child: Icon(icon, color: color, size: resolvedSize),
      ),
    );
  }
}
