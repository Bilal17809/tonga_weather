import 'package:flutter/material.dart';
import '/core/theme/theme.dart';

class TrianglePainter extends CustomPainter {
  final BuildContext context;

  TrianglePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode(context)
          ? secondaryColorLight.withValues(alpha: 0.6)
          : kWhite;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
