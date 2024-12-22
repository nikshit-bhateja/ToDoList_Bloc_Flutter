import 'package:flutter/material.dart';
import 'package:to_do_list_yt/resources/app_colors.dart';

class ChevronToCrossPainter extends CustomPainter {
  /*
  The progress parameter (ranging from 0.0 to 1.0) determines the animation state:
  0.0: Fully in chevron shape.
  1.0: Fully in cross shape.
  */
  final double progress;

  ChevronToCrossPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    print("Animation.value -> ${progress.toString()}");
    final paint = Paint()
      ..color = AppColors.icon
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Chevron points
    final startPoint = Offset(centerX - 6, centerY - 6);
    final midPoint = Offset(centerX, centerY);
    final endPoint = Offset(centerX - 6, centerY + 6);

    // Cross points (left diagonal)
    final crossStart1 = Offset(centerX - 6, centerY - 6);
    final crossEnd1 = Offset(centerX + 6, centerY + 6);

    // Cross points (right diagonal)
    final crossStart2 = Offset(centerX + 6, centerY - 6);
    final crossEnd2 = Offset(centerX - 6, centerY + 6);

    // Draw chevron morphing to cross
    final interpolatedStart1 =
        Offset.lerp(startPoint, crossStart1, progress) ?? startPoint;
    final interpolatedEnd1 =
        Offset.lerp(midPoint, crossEnd1, progress) ?? midPoint;

    final interpolatedStart2 =
        Offset.lerp(endPoint, crossStart2, progress) ?? endPoint;
    final interpolatedEnd2 =
        Offset.lerp(midPoint, crossEnd2, progress) ?? midPoint;

    canvas.drawLine(interpolatedStart1, interpolatedEnd1, paint);
    canvas.drawLine(interpolatedStart2, interpolatedEnd2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
