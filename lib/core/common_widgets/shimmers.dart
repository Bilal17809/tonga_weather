import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '/core/theme/theme.dart';

class ShimmerListView extends StatelessWidget {
  final int itemCount;
  final double? itemWidth;
  final double? itemHeight;
  final Axis scrollDirection;
  final EdgeInsets Function(int index)? itemMargin;
  final BorderRadius borderRadius;
  final Color color;
  final BoxDecoration? itemDecoration;
  final bool shimmerEnabled;

  const ShimmerListView({
    super.key,
    this.itemCount = 5,
    this.itemWidth,
    this.itemHeight,
    this.scrollDirection = Axis.horizontal,
    this.itemMargin,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.color = kWhite,
    this.itemDecoration,
    this.shimmerEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final listView = ListView.builder(
      scrollDirection: scrollDirection,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          width: itemWidth,
          height: itemHeight,
          margin: itemMargin?.call(index) ?? EdgeInsets.zero,
          decoration:
              itemDecoration ??
              BoxDecoration(color: color, borderRadius: borderRadius),
        );
      },
    );

    return shimmerEnabled
        ? Shimmer.fromColors(
            baseColor: kWhite,
            highlightColor: primaryColorLight.withValues(alpha: 0.01),
            child: listView,
          )
        : listView;
  }
}
