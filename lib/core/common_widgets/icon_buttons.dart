import 'package:flutter/material.dart';

import '../constants/constant.dart';
import '../theme/app_colors.dart';

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
          borderRadius:
              isCircular ? null : BorderRadius.circular(kBorderRadius),
        ),
        child: Icon(icon, color: color, size: resolvedSize),
      ),
    );
  }
}

class ImageActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String assetPath;
  final Color? color;
  final double? size;
  final double? width;
  final double? height;
  final bool isCircular;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  const ImageActionButton({
    super.key,
    this.onTap,
    required this.assetPath,
    this.color,
    this.size,
    this.width,
    this.isCircular = false,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius,
    this.height,
  });
  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      assetPath,
      width: size,
      height: size,
      color: color,
      fit: BoxFit.contain,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius:
              isCircular ? null : borderRadius ?? BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: greyColor.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: image),
      ),
    );
  }
}
