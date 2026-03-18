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

  static const Color focusPink = Color(0xFFF26076);
  static const Color progressOrange = Color(0xFFFF9760);
  static const Color breakBlue = Color(0xFF000B58);
  static const Color breakTeal = Color(0xFF7DE3D6);
  static const Color focusBgGuide = Color(0xFFF1C85A);
  static const Color breakBgGuide = Color(0xFF8CC9B3);
  static const Color ink = Color(0xFF4A3739);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2 - 24;
    final ringRect = Rect.fromCircle(center: center, radius: radius);

    final guide = Paint()
      ..color = (isBreak ? breakBgGuide : focusBgGuide).withOpacity(0.34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(ringRect, 0, pi * 2, false, guide);

    _paintBodySegments(canvas, center, radius, progress);
    _paintHead(canvas, center, radius, progress);
    _paintDecorations(canvas, center, radius);
    _paintSketch(canvas, Rect.fromCircle(center: center, radius: radius - 30));
  }

  void _paintBodySegments(Canvas canvas, Offset center, double radius, double progress) {
    final segmentCount = max(3, (progress * 16).ceil());
    final segmentSpacing = 0.17;
    final segmentSize = isBreak ? 16.0 : 17.5;

    for (int i = 0; i < segmentCount; i++) {
      final t = (progress - (i * 0.03)).clamp(0.0, 1.0);
      final angle = -pi / 2 + (pi * 2 * t) - (i * segmentSpacing);
      final offset = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      final wobble = sin(i * 0.65 + progress * pi * 5) * 0.8;
      final rect = Rect.fromCenter(
        center: offset,
        width: segmentSize + max(0, 7 - i * 0.5),
        height: segmentSize - (i * 0.45) + wobble,
      );
      final color = Color.lerp(
            isBreak ? breakTeal : focusPink,
            isBreak ? const Color(0xFFA9EFE6) : progressOrange,
            i / max(1, segmentCount - 1),
          ) ??
          (isBreak ? breakTeal : focusPink);

      final fill = Paint()..color = color;
      final outline = Paint()
        ..color = ink.withOpacity(0.86)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle + pi / 2 + wobble * 0.02);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: rect.width, height: rect.height),
        const Radius.circular(50),
      );
      canvas.drawRRect(rrect, fill);
      canvas.drawRRect(rrect, outline);

      if (i > 0 && i < segmentCount - 1) {
        final spotPaint = Paint()..color = Colors.white.withOpacity(0.18);
        canvas.drawCircle(const Offset(0, 0), 2.2, spotPaint);
      }
      canvas.restore();
    }
  }

  void _paintHead(Canvas canvas, Offset center, double radius, double progress) {
    final angle = -pi / 2 + (pi * 2 * progress);
    final headCenter = Offset(
      center.dx + cos(angle) * radius,
      center.dy + sin(angle) * radius,
    );
    final headColor = isBreak ? const Color(0xFF9EF4E7) : focusPink;

    canvas.save();
    canvas.translate(headCenter.dx, headCenter.dy);
    canvas.rotate(angle + pi / 2);

    final headRect = Rect.fromCenter(center: Offset.zero, width: 42, height: 42);
    final fill = Paint()..color = headColor;
    final outline = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    canvas.drawOval(headRect, fill);
    canvas.drawOval(headRect, outline);

    final cheek = Paint()..color = Colors.white.withOpacity(0.18);
    canvas.drawCircle(const Offset(-6, 8), 3.2, cheek);
    canvas.drawCircle(const Offset(6, 8), 3.2, cheek);

    final antenna = Paint()
      ..color = ink
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(-10, -16), const Offset(-14, -29), antenna);
    canvas.drawLine(const Offset(10, -16), const Offset(14, -29), antenna);

    final eye = Paint()..color = ink;
    canvas.drawCircle(const Offset(-6, -2), 2.4, eye);
    canvas.drawCircle(const Offset(6, -2), 2.4, eye);

    final smile = Path()
      ..moveTo(-8, 8)
      ..quadraticBezierTo(0, 14, 8, 8);
    canvas.drawPath(
      smile,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    canvas.restore();
  }

  void _paintDecorations(Canvas canvas, Offset center, double radius) {
    final decor = Paint()
      ..color = ink.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final sparkle = Path()
      ..moveTo(center.dx - radius * 0.9, center.dy - radius * 0.45)
      ..lineTo(center.dx - radius * 0.82, center.dy - radius * 0.35)
      ..moveTo(center.dx - radius * 0.86, center.dy - radius * 0.50)
      ..lineTo(center.dx - radius * 0.86, center.dy - radius * 0.30)
      ..moveTo(center.dx + radius * 0.65, center.dy + radius * 0.62)
      ..lineTo(center.dx + radius * 0.78, center.dy + radius * 0.50)
      ..moveTo(center.dx + radius * 0.72, center.dy + radius * 0.42)
      ..lineTo(center.dx + radius * 0.72, center.dy + radius * 0.58);
    canvas.drawPath(sparkle, decor);
  }

  void _paintSketch(Canvas canvas, Rect rect) {
    final chaosPaint = Paint()
      ..color = ink.withOpacity(0.18 * chaosVisibility)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final stroke in pattern.chaosStrokes) {
      chaosPaint.strokeWidth = stroke.width;
      final path = _strokePath(stroke, rect, 1);
      canvas.drawPath(path, chaosPaint);
    }

    final revealCount =
        (pattern.guideStrokes.length * sketchReveal).ceil().clamp(0, pattern.guideStrokes.length);
    final revealPaint = Paint()
      ..color = ink.withOpacity(0.75)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < revealCount; i++) {
      final stroke = pattern.guideStrokes[i];
      revealPaint.strokeWidth = stroke.width;
      final localFraction = (sketchReveal * pattern.guideStrokes.length) - i;
      final path = _strokePath(stroke, rect, localFraction.clamp(0, 1));
      canvas.drawPath(path, revealPaint);
    }
  }

  Path _strokePath(SketchStroke stroke, Rect rect, double fraction) {
    final pts = stroke.points;
    if (pts.isEmpty) return Path();
    final maxPoints = (pts.length * fraction).ceil().clamp(1, pts.length);
    final path = Path();
    final first = _map(pts.first, rect);
    path.moveTo(first.dx, first.dy);
    for (int i = 1; i < maxPoints; i++) {
      final p = _map(pts[i], rect);
      path.lineTo(p.dx, p.dy);
    }
    return path;
  }

  Offset _map(Offset unit, Rect rect) => Offset(rect.left + unit.dx * rect.width, rect.top + unit.dy * rect.height);

  @override
  bool shouldRepaint(covariant SketchProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.sketchReveal != sketchReveal ||
        oldDelegate.chaosVisibility != chaosVisibility ||
        oldDelegate.isBreak != isBreak ||
        oldDelegate.pattern != pattern;
  }
}
