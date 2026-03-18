import 'dart:math';
import 'package:flutter/material.dart';

enum SketchPatternType {
  diamond,
  foxFace,
  catFace,
  mandalaBloom,
  fish,
  owlFace,
  leaf,
  butterfly,
  mountainSun,
  spiralFlower,
}

class SketchPattern {
  final SketchPatternType type;
  final double rotation;
  final double scale;

  const SketchPattern({required this.type, this.rotation = 0, this.scale = 1});
}

class SketchGenerator {
  static final Random _random = Random();

  static const List<SketchPatternType> _types = [
    SketchPatternType.diamond,
    SketchPatternType.foxFace,
    SketchPatternType.catFace,
    SketchPatternType.mandalaBloom,
    SketchPatternType.fish,
    SketchPatternType.owlFace,
    SketchPatternType.leaf,
    SketchPatternType.butterfly,
    SketchPatternType.mountainSun,
    SketchPatternType.spiralFlower,
  ];

  static SketchPattern randomPattern() {
    final type = _types[_random.nextInt(_types.length)];
    return SketchPattern(
      type: type,
      rotation: (_random.nextDouble() - 0.5) * 0.35,
      scale: 0.92 + (_random.nextDouble() * 0.12),
    );
  }

  static void drawPattern(
    Canvas canvas,
    Size size,
    Paint paint,
    SketchPattern pattern,
    double reveal,
  ) {
    canvas.save();

    final center = Offset(size.width / 2, size.height / 2);
    canvas.translate(center.dx, center.dy);
    canvas.rotate(pattern.rotation);
    canvas.scale(pattern.scale);

    switch (pattern.type) {
      case SketchPatternType.diamond:
        _drawDiamond(canvas, size, paint, reveal);
        break;
      case SketchPatternType.foxFace:
        _drawFoxFace(canvas, size, paint, reveal);
        break;
      case SketchPatternType.catFace:
        _drawCatFace(canvas, size, paint, reveal);
        break;
      case SketchPatternType.mandalaBloom:
        _drawMandalaBloom(canvas, size, paint, reveal);
        break;
      case SketchPatternType.fish:
        _drawFish(canvas, size, paint, reveal);
        break;
      case SketchPatternType.owlFace:
        _drawOwlFace(canvas, size, paint, reveal);
        break;
      case SketchPatternType.leaf:
        _drawLeaf(canvas, size, paint, reveal);
        break;
      case SketchPatternType.butterfly:
        _drawButterfly(canvas, size, paint, reveal);
        break;
      case SketchPatternType.mountainSun:
        _drawMountainSun(canvas, size, paint, reveal);
        break;
      case SketchPatternType.spiralFlower:
        _drawSpiralFlower(canvas, size, paint, reveal);
        break;
    }

    canvas.restore();
  }

  static void _drawPartialPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double t,
  ) {
    final metrics = path.computeMetrics().toList();
    for (final metric in metrics) {
      final extracted = metric.extractPath(
        0,
        metric.length * t.clamp(0.0, 1.0),
      );
      canvas.drawPath(extracted, paint);
    }
  }

  static void _drawDiamond(
    Canvas canvas,
    Size size,
    Paint paint,
    double reveal,
  ) {
    final path = Path()
      ..moveTo(0, -78)
      ..lineTo(52, -18)
      ..lineTo(40, 58)
      ..lineTo(0, 92)
      ..lineTo(-40, 58)
      ..lineTo(-52, -18)
      ..close()
      ..moveTo(0, -78)
      ..lineTo(0, 92)
      ..moveTo(-52, -18)
      ..lineTo(52, -18);

    _drawPartialPath(canvas, path, paint, reveal);
  }

  static void _drawFoxFace(
    Canvas canvas,
    Size size,
    Paint paint,
    double reveal,
  ) {
    final path = Path()
      ..moveTo(-75, 20)
      ..quadraticBezierTo(-62, -18, -38, -54)
      ..lineTo(-8, -18)
      ..lineTo(0, -62)
      ..lineTo(8, -18)
      ..lineTo(38, -54)
      ..quadraticBezierTo(62, -18, 75, 20)
      ..quadraticBezierTo(52, 70, 0, 86)
      ..quadraticBezierTo(-52, 70, -75, 20)
      ..close()
      ..moveTo(-22, 12)
      ..quadraticBezierTo(-14, 2, -6, 12)
      ..moveTo(22, 12)
      ..quadraticBezierTo(14, 2, 6, 12)
      ..moveTo(-18, 42)
      ..quadraticBezierTo(0, 56, 18, 42)
      ..moveTo(-12, 28)
      ..lineTo(0, 36)
      ..lineTo(12, 28);

    _drawPartialPath(canvas, path, paint, reveal);
  }

  static void _drawCatFace(
    Canvas canvas,
    Size size,
    Paint paint,
    double reveal,
  ) {
    final path = Path()
      ..moveTo(-68, 28)
      ..lineTo(-52, -36)
      ..lineTo(-12, -8)
      ..quadraticBezierTo(0, -52, 12, -8)
      ..lineTo(52, -36)
      ..lineTo(68, 28)
      ..quadraticBezierTo(56, 84, 0, 88)
      ..quadraticBezierTo(-56, 84, -68, 28)
      ..close()
      ..moveTo(-22, 16)
      ..quadraticBezierTo(-16, 10, -10, 16)
      ..moveTo(22, 16)
      ..quadraticBezierTo(16, 10, 10, 16)
      ..moveTo(-10, 34)
      ..lineTo(0, 46)
      ..lineTo(10, 34)
      ..moveTo(-16, 56)
      ..quadraticBezierTo(0, 64, 16, 56);

    _drawPartialPath(canvas, path, paint, reveal);
  }

  static void _drawMandalaBloom(
    Canvas canvas,
    Size size,
    Paint paint,
    double reveal,
  ) {
    final path = Path();

    for (int i = 0; i < 8; i++) {
      final angle = (pi * 2 / 8) * i;
      final x = cos(angle) * 42;
      final y = sin(angle) * 42;

      path
        ..moveTo(0, 0)
        ..addOval(Rect.fromCenter(center: Offset(x, y), width: 36, height: 62));
    }

    path.addOval(Rect.fromCenter(center: Offset.zero, width: 54, height: 54));

    _drawPartialPath(canvas, path, paint, reveal);
  }

  static void _drawFish(Canvas canvas, Size size, Paint paint, double reveal) {
    final path = Path()
      ..moveTo(-72, 0)
      ..quadraticBezierTo(-20, -54, 44, -20)
      ..quadraticBezierTo(78, 0, 44, 20)
      ..quadraticBezierTo(-20, 54, -72, 0)
      ..close()
      ..moveTo(44, -20)
      ..lineTo(76, -54)
      ..lineTo(76, 54)
      ..lineTo(44, 20)
      ..moveTo(-24, -10)
      ..addOval(Rect.fromCircle(center: const Offset(-24, -6), radius: 4))
      ..moveTo(-4, 4)
      ..quadraticBezierTo(14, 14, 32, 4);

    _drawPartialPath(canvas, path, paint, reveal);
  }

  static void _drawOwlFace(
    Canvas canvas,
    Size size,
    Paint paint,
    double reveal,
  ) {
    final path = Path()
      ..moveTo(-62, 70)
      ..lineTo(-62, -18)
      ..lineTo(-34, -58)
      ..lineTo(-12, -14)
      ..lineTo(12, -14)
      ..lineTo(34, -58)
      ..lineTo(62, -18)
      ..lineTo(62, 70)
      ..quadraticBezierTo(0, 92, -62, 70)
      ..close()
      ..addOval(
        Rect.fromCenter(center: const Offset(-20, 14), width: 34, height: 34),
      )
      ..addOval(
        Rect.fromCenter(center: const Offset(20, 14), width: 34, height: 34),
      )
      ..moveTo(0, 24)
      ..lineTo(-10, 40)
      ..lineTo(10, 40)
      ..close();

    _drawPartialPath(canvas, path, paint, reveal);
  }

  static void _drawLeaf(Canvas canvas, Size size, Paint paint, double reveal) {
    final path = Path()
      ..moveTo(0, -84)
      ..quadraticBezierTo(62, -26, 34, 60)
      ..quadraticBezierTo(10, 90, 0, 96)
      ..quadraticBezierTo(-10, 90, -34, 60)
      ..quadraticBezierTo(-62, -26, 0, -84)
      ..close()
      ..moveTo(0, -84)
      ..lineTo(0, 96)
      ..moveTo(-20, -24)
      ..lineTo(0, -4)
      ..moveTo(20, -24)
      ..lineTo(0, -4)
      ..moveTo(-24, 26)
      ..lineTo(0, 12)
      ..moveTo(24, 26)
      ..lineTo(0, 12)
      ..moveTo(-16, 64)
      ..lineTo(0, 46)
      ..moveTo(16, 64)
      ..lineTo(0, 46);

    _drawPartialPath(canvas, path, paint, reveal);
  }

  static void _drawButterfly(
    Canvas canvas,
    Size size,
    Paint paint,
    double reveal,
  ) {
    final path = Path()
      ..moveTo(0, -50)
      ..quadraticBezierTo(-12, -34, -8, 12)
      ..quadraticBezierTo(-28, 44, -8, 84)
      ..moveTo(0, -50)
      ..quadraticBezierTo(12, -34, 8, 12)
      ..quadraticBezierTo(28, 44, 8, 84)
      ..addOval(
        Rect.fromCenter(center: const Offset(-40, -18), width: 60, height: 76),
      )
      ..addOval(
        Rect.fromCenter(center: const Offset(40, -18), width: 60, height: 76),
      )
      ..addOval(
        Rect.fromCenter(center: const Offset(-34, 42), width: 44, height: 58),
      )
      ..addOval(
        Rect.fromCenter(center: const Offset(34, 42), width: 44, height: 58),
      );

    _drawPartialPath(canvas, path, paint, reveal);
  }

  static void _drawMountainSun(
    Canvas canvas,
    Size size,
    Paint paint,
    double reveal,
  ) {
    final path = Path()
      ..addOval(Rect.fromCircle(center: const Offset(0, -34), radius: 26))
      ..moveTo(-90, 72)
      ..lineTo(-34, 8)
      ..lineTo(0, 52)
      ..lineTo(22, 24)
      ..lineTo(90, 72)
      ..moveTo(-96, 72)
      ..lineTo(96, 72)
      ..moveTo(0, -74)
      ..lineTo(0, -98)
      ..moveTo(-38, -34)
      ..lineTo(-58, -34)
      ..moveTo(38, -34)
      ..lineTo(58, -34)
      ..moveTo(-28, -62)
      ..lineTo(-44, -78)
      ..moveTo(28, -62)
      ..lineTo(44, -78);

    _drawPartialPath(canvas, path, paint, reveal);
  }

  static void _drawSpiralFlower(
    Canvas canvas,
    Size size,
    Paint paint,
    double reveal,
  ) {
    final path = Path();

    for (int i = 0; i < 6; i++) {
      final angle = i * (pi / 3);
      final x = cos(angle) * 34;
      final y = sin(angle) * 34;
      path.addOval(
        Rect.fromCenter(center: Offset(x, y), width: 42, height: 60),
      );
    }

    path.addOval(Rect.fromCircle(center: Offset.zero, radius: 20));

    final spiral = Path();
    double r = 4;
    spiral.moveTo(0, 0);
    for (double a = 0; a < 5 * pi; a += 0.18) {
      r += 0.7;
      spiral.lineTo(cos(a) * r, sin(a) * r);
    }

    _drawPartialPath(canvas, path, paint, reveal.clamp(0.0, 1.0));
    if (reveal > 0.55) {
      _drawPartialPath(
        canvas,
        spiral,
        paint,
        ((reveal - 0.55) / 0.45).clamp(0.0, 1.0),
      );
    }
  }
}
