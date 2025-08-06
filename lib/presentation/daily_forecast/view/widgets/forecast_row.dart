import 'package:flutter/material.dart';
import '/core/constants/constant.dart';
import '/core/theme/theme.dart';

class ForecastRow extends StatelessWidget {
  final String day;
  final String iconUrl;
  final int maxTemp;
  final int minTemp;
  final String condition;

  const ForecastRow({
    super.key,
    required this.day,
    required this.iconUrl,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kBodyHp,
        horizontal: kElementGap,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: mobileWidth(context) * 0.15,
            child: Text(day, style: bodyMediumStyle(context)),
          ),
          iconUrl.isNotEmpty
              ? Image.network(
                  iconUrl.startsWith('http') ? iconUrl : 'https:$iconUrl',
                  width: mediumIcon(context),
                  height: mediumIcon(context),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.wb_sunny,
                    size: mediumIcon(context),
                    color: kWhite,
                  ),
                )
              : Icon(Icons.wb_sunny, size: mediumIcon(context)),
          Spacer(),
          Text(
            '$maxTemp°/$minTemp°',
            style: bodyMediumStyle(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(width: mobileWidth(context) * 0.08),
          Flexible(
            flex: 2,
            child: Text(
              condition,
              style: bodyMediumStyle(context),
              textAlign: TextAlign.start,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
