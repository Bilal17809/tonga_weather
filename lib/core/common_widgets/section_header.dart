import 'package:flutter/material.dart';
import '../constants/constant.dart';
import '../theme/app_styles.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String? title;
  final String actionText;
  final VoidCallback onTap;
  final IconData? actionIcon;

  const SectionHeader({
    super.key,
    this.title,
    required this.actionText,
    required this.onTap,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title ?? '', style: titleSmallBoldStyle(context)),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              if (actionIcon != null)
                Icon(
                  actionIcon,
                  size: smallIcon(context),
                  color: getIconColor(context),
                ),
              const SizedBox(width: 4),
              Text(actionText, style: bodyBoldMediumStyle(context)),
            ],
          ),
        ),
      ],
    );
  }
}
