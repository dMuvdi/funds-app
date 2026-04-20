import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Static sparkline data matching the HTML mock (30-day portfolio curve).
const List<double> _kSparkData = [
  54, 48.6, 43.7, 39.5, 36.4, 34.4, 33.7, 34.1, 35.4, 37.3,
  39.3, 41.1, 42.3, 42.6, 41.7, 39.5, 36.2, 31.9, 26.9, 21.5,
  16.2, 11.3, 7.3, 4.3, 2.5, 2.0, 2.6, 4.0, 5.9, 7.9, 7.3,
];

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color fillColor;

  const SparklinePainter({
    this.data = _kSparkData,
    this.lineColor = AppColors.ink,
    this.fillColor = AppColors.ink,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);
    final rangeY = maxY - minY == 0 ? 1.0 : maxY - minY;

    double xStep = size.width / (data.length - 1);

    Path linePath = Path();
    Path fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = i * xStep;
      final y = size.height - ((data[i] - minY) / rangeY) * size.height;
      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = fillColor.withValues(alpha: 0.08)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(SparklinePainter old) =>
      old.data != data || old.lineColor != lineColor;
}

class Sparkline extends StatelessWidget {
  final double width;
  final double height;
  final List<double> data;

  const Sparkline({
    super.key,
    this.width = double.infinity,
    this.height = 56,
    this.data = _kSparkData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: SparklinePainter(data: data)),
    );
  }
}
