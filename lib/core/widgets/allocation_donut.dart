import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AllocationDonut extends StatelessWidget {
  final double fpvAmount;
  final double ficAmount;
  final double available;

  const AllocationDonut({
    super.key,
    required this.fpvAmount,
    required this.ficAmount,
    required this.available,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: CustomPaint(
        painter: _DonutPainter(
          fpvAmount: fpvAmount,
          ficAmount: ficAmount,
          available: available,
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double fpvAmount;
  final double ficAmount;
  final double available;

  const _DonutPainter({
    required this.fpvAmount,
    required this.ficAmount,
    required this.available,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 8.0;
    const startAngle = -math.pi / 2; // top

    final total = fpvAmount + ficAmount + available;
    if (total == 0) {
      // All available — draw full ring in lineStrong color
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = AppColors.lineStrong
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
      return;
    }

    final rect = Rect.fromCircle(center: center, radius: radius);
    final segments = [
      (fpvAmount / total, AppColors.ink),
      (ficAmount / total, AppColors.accent),
      (available / total, AppColors.lineStrong),
    ];

    double currentAngle = startAngle;
    for (final seg in segments) {
      final sweep = seg.$1 * 2 * math.pi;
      if (sweep > 0) {
        canvas.drawArc(
          rect,
          currentAngle,
          sweep,
          false,
          Paint()
            ..color = seg.$2
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.butt,
        );
        currentAngle += sweep;
      }
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.fpvAmount != fpvAmount ||
      old.ficAmount != ficAmount ||
      old.available != available;
}
