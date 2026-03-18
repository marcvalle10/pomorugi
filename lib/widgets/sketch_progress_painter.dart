import 'dart:math';
import 'package:flutter/material.dart';

import '../services/sketch_generator.dart';

class SketchProgressPainter extends CustomPainter {
  final double progress;
  final double sketchReveal;
  final double chaosVisibility;
  final bool isBreak;
  final SketchPattern pattern;

  SketchProgressPainter({
    required this.progress,
    required this.sketchReveal,
    required this.chaosVisibility,
    required this.isBreak,
    required this.pattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.39;

    final trackColor = isBreak
        ? const Color(0xFFAEE8DA).withOpacity(0.45)
        : const Color(0xFFEBCF7B).withOpacity(0.32);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    _drawChaos(canvas, size, center, radius);
    _drawSketch(canvas, size);
    _drawCaterpillar(canvas, center, radius);
  }

  void _drawChaos(Canvas canvas, Size size, Offset center, double radius) {
    if (chaosVisibility <= 0) return;

    final chaosPaint = Paint()
      ..color = const Color(0xFF5C5148).withOpacity(0.10 * chaosVisibility)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final random = Random(pattern.type.index * 97 + 11);

    for (int i = 0; i < 14; i++) {
      final p = Path();

      final startAngle = random.nextDouble() * pi * 2;
      final startRadius = radius * (0.15 + random.nextDouble() * 0.55);
      final start = Offset(
        center.dx + cos(startAngle) * startRadius,
        center.dy + sin(startAngle) * startRadius,
      );

      p.moveTo(start.dx, start.dy);

      final segments = 2 + random.nextInt(3);
      Offset current = start;

      for (int j = 0; j < segments; j++) {
        final angle = random.nextDouble() * pi * 2;
        final length = 24 + random.nextDouble() * 42;

        current = Offset(
          current.dx + cos(angle) * length,
          current.dy + sin(angle) * length,
        );

        p.lineTo(current.dx, current.dy);
      }

      canvas.drawPath(p, chaosPaint);
    }
  }

  void _drawSketch(Canvas canvas, Size size) {
    final reveal = Curves.easeOutCubic.transform(sketchReveal.clamp(0.0, 1.0));
    if (reveal <= 0) return;

    final sketchPaint = Paint()
      ..color = const Color(0xFF4A3739).withOpacity(0.26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    SketchGenerator.drawPattern(canvas, size, sketchPaint, pattern, reveal);
  }

  void _drawCaterpillar(Canvas canvas, Offset center, double radius) {
    final easedProgress = Curves.easeInOutCubic.transform(
      progress.clamp(0.0, 1.0),
    );

    final headAngle = -pi / 2 + (pi * 2 * easedProgress);

    final maxSegments = 36;
    final bodySegments = max(0, (maxSegments * easedProgress).round());

    final segmentSpacing = 0.165;
    final segmentWidth = radius * 0.13;
    final segmentHeight = radius * 0.085;

    final bodyBaseColor = isBreak
        ? const Color(0xFF9DEFE6)
        : const Color(0xFFF47E8E);

    final bodyAccentColor = isBreak
        ? const Color(0xFFCFFAF4)
        : const Color(0xFFFFB07A);

    final outline = const Color(0xFF5A4647);

    for (int i = bodySegments; i >= 1; i--) {
      final t = i / maxSegments;
      final angle = headAngle - (i * segmentSpacing);

      final pos = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      final rotation = angle + pi / 2;
      final colorLerp = (0.25 + 0.75 * (1 - t)).clamp(0.0, 1.0);
      final fillColor = Color.lerp(bodyAccentColor, bodyBaseColor, colorLerp)!;

      _drawSegment(
        canvas,
        pos,
        rotation,
        segmentWidth,
        segmentHeight,
        fillColor,
        outline,
      );
    }

    final headCenter = Offset(
      center.dx + cos(headAngle) * radius,
      center.dy + sin(headAngle) * radius,
    );

    _drawHead(
      canvas,
      headCenter,
      headAngle + pi / 2,
      radius * 0.17,
      isBreak ? const Color(0xFF9DEFE6) : const Color(0xFFF0627E),
      outline,
    );
  }

  void _drawSegment(
    Canvas canvas,
    Offset center,
    double rotation,
    double width,
    double height,
    Color fill,
    Color outline,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: width,
      height: height,
    );

    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(height * 0.7));

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    canvas.drawRRect(rrect.shift(const Offset(1.2, 1.4)), shadowPaint);

    final fillPaint = Paint()..color = fill;
    canvas.drawRRect(rrect, fillPaint);

    final stripeRect = Rect.fromCenter(
      center: Offset(0, 0),
      width: width * 0.42,
      height: height * 0.58,
    );

    final stripe = RRect.fromRectAndRadius(
      stripeRect,
      Radius.circular(height * 0.45),
    );

    final stripePaint = Paint()..color = Colors.white.withOpacity(0.18);
    canvas.drawRRect(stripe, stripePaint);

    final outlinePaint = Paint()
      ..color = outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    canvas.drawRRect(rrect, outlinePaint);

    canvas.restore();
  }

  void _drawHead(
    Canvas canvas,
    Offset center,
    double rotation,
    double radius,
    Color fill,
    Color outline,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(const Offset(1.5, 2), radius, shadowPaint);

    final fillPaint = Paint()..color = fill;
    canvas.drawCircle(Offset.zero, radius, fillPaint);

    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.18);
    canvas.drawCircle(
      Offset(-radius * 0.25, -radius * 0.22),
      radius * 0.38,
      highlightPaint,
    );

    final outlinePaint = Paint()
      ..color = outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(Offset.zero, radius, outlinePaint);

    final facePaint = Paint()
      ..color = outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset(-radius * 0.28, -radius * 0.10),
      radius * 0.06,
      Paint()..color = outline,
    );
    canvas.drawCircle(
      Offset(radius * 0.22, -radius * 0.08),
      radius * 0.06,
      Paint()..color = outline,
    );

    final smile = Path()
      ..moveTo(-radius * 0.24, radius * 0.18)
      ..quadraticBezierTo(0, radius * 0.38, radius * 0.26, radius * 0.16);

    canvas.drawPath(smile, facePaint);

    canvas.drawLine(
      Offset(-radius * 0.18, -radius * 0.85),
      Offset(-radius * 0.28, -radius * 1.38),
      facePaint,
    );
    canvas.drawLine(
      Offset(radius * 0.18, -radius * 0.85),
      Offset(radius * 0.34, -radius * 1.30),
      facePaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SketchProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.sketchReveal != sketchReveal ||
        oldDelegate.chaosVisibility != chaosVisibility ||
        oldDelegate.isBreak != isBreak ||
        oldDelegate.pattern != pattern;
  }
}
