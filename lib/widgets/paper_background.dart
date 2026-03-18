import 'dart:math';
import 'package:flutter/material.dart';

class PaperBackground extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final bool notebookLines;
  final bool leaves;

  const PaperBackground({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0xFFFAF4DD),
    this.notebookLines = false,
    this.leaves = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PaperBackgroundPainter(
        backgroundColor: backgroundColor,
        notebookLines: notebookLines,
        leaves: leaves,
      ),
      child: child,
    );
  }
}

class _PaperBackgroundPainter extends CustomPainter {
  final Color backgroundColor;
  final bool notebookLines;
  final bool leaves;

  _PaperBackgroundPainter({
    required this.backgroundColor,
    required this.notebookLines,
    required this.leaves,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBase(canvas, size);
    _drawPaperTexture(canvas, size);

    if (notebookLines) {
      _drawNotebookLines(canvas, size);
      _drawMarginBand(canvas, size);
    } else {
      _drawDottedGrid(canvas, size);
      _drawMarginBand(canvas, size, opacity: 0.18);
    }

    _drawThemedDoodles(canvas, size);
  }

  void _drawBase(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, bgPaint);
  }

  void _drawPaperTexture(Canvas canvas, Size size) {
    final texturePaint = Paint()
      ..color = Colors.white.withOpacity(0.035)
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.02)
      ..style = PaintingStyle.fill;

    final random = Random(21);

    for (int i = 0; i < 110; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final w = 18 + random.nextDouble() * 36;
      final h = 8 + random.nextDouble() * 18;

      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: w, height: h),
        i.isEven ? texturePaint : shadowPaint,
      );
    }
  }

  void _drawNotebookLines(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF8A7A62).withOpacity(0.14)
      ..strokeWidth = 1.0;

    const spacing = 58.0;
    for (double y = 18; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  void _drawDottedGrid(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0xFF8E816A).withOpacity(0.16)
      ..style = PaintingStyle.fill;

    const spacing = 22.0;
    for (double y = 12; y < size.height; y += spacing) {
      for (double x = 12; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1.15, dotPaint);
      }
    }
  }

  void _drawMarginBand(Canvas canvas, Size size, {double opacity = 0.24}) {
    final bandPaint = Paint()
      ..color = const Color(0xFFB9A786).withOpacity(opacity);

    canvas.drawRect(Rect.fromLTWH(34, 0, 6, size.height), bandPaint);
  }

  void _drawThemedDoodles(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = leaves
          ? Colors.white.withOpacity(0.12)
          : const Color(0xFF7D6F60).withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final accent = Paint()
      ..color = leaves
          ? Colors.white.withOpacity(0.08)
          : const Color(0xFF6A5B4B).withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final softFill = Paint()
      ..color = leaves
          ? Colors.white.withOpacity(0.07)
          : const Color(0xFFF4D97D).withOpacity(0.10)
      ..style = PaintingStyle.fill;

    // Distribución manual para que no se amontonen.
    _drawSun(canvas, Offset(size.width - 54, 120), 28, stroke);
    _drawDiamond(canvas, Offset(size.width - 68, 300), 26, accent);
    _drawSmallCross(canvas, Offset(86, 208), 12, accent);
    _drawSmallCross(
      canvas,
      Offset(size.width * 0.28, size.height * 0.22),
      10,
      accent,
    );
    _drawSmallCross(
      canvas,
      Offset(size.width * 0.72, size.height * 0.78),
      10,
      accent,
    );

    _drawLeaf(canvas, Offset(56, size.height * 0.34), 34, stroke, softFill);
    _drawLeaf(
      canvas,
      Offset(size.width - 52, size.height * 0.28),
      30,
      stroke,
      softFill,
    );
    _drawLeaf(canvas, Offset(72, size.height * 0.74), 26, accent, softFill);

    _drawButterfly(
      canvas,
      Offset(size.width * 0.18, size.height * 0.86),
      24,
      accent,
    );
    _drawSpiral(
      canvas,
      Offset(size.width * 0.78, size.height * 0.48),
      18,
      accent,
    );
    _drawFlower(
      canvas,
      Offset(size.width * 0.22, size.height * 0.48),
      20,
      accent,
    );
    _drawMountain(
      canvas,
      Offset(size.width * 0.78, size.height * 0.12),
      30,
      accent,
    );

    _drawTinyDiamond(
      canvas,
      Offset(size.width * 0.14, size.height * 0.46),
      9,
      accent,
    );
    _drawTinyDiamond(
      canvas,
      Offset(size.width * 0.82, size.height * 0.66),
      10,
      accent,
    );

    _drawShortLine(
      canvas,
      Offset(size.width * 0.22, size.height * 0.60),
      34,
      accent,
    );
    _drawShortLine(
      canvas,
      Offset(size.width * 0.62, size.height * 0.32),
      28,
      accent,
    );
    _drawShortLine(
      canvas,
      Offset(size.width * 0.12, size.height * 0.84),
      24,
      accent,
    );

    if (leaves) {
      _drawBotanicalSprout(canvas, Offset(46, 184), 24, stroke);
      _drawBotanicalSprout(
        canvas,
        Offset(size.width - 58, size.height - 160),
        22,
        accent,
      );
    } else {
      _drawStar(canvas, Offset(96, size.height * 0.40), 16, accent);
      _drawStar(canvas, Offset(size.width - 82, 188), 14, accent);
    }
  }

  void _drawSun(Canvas canvas, Offset c, double r, Paint paint) {
    canvas.drawCircle(c, r * 0.78, paint);
    for (int i = 0; i < 8; i++) {
      final a = (pi * 2 / 8) * i;
      final p1 = Offset(c.dx + cos(a) * (r + 6), c.dy + sin(a) * (r + 6));
      final p2 = Offset(c.dx + cos(a) * (r + 16), c.dy + sin(a) * (r + 16));
      canvas.drawLine(p1, p2, paint);
    }
  }

  void _drawDiamond(Canvas canvas, Offset c, double s, Paint paint) {
    final path = Path()
      ..moveTo(c.dx, c.dy - s)
      ..lineTo(c.dx + s * 0.7, c.dy)
      ..lineTo(c.dx, c.dy + s)
      ..lineTo(c.dx - s * 0.7, c.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawTinyDiamond(Canvas canvas, Offset c, double s, Paint paint) {
    final path = Path()
      ..moveTo(c.dx, c.dy - s)
      ..lineTo(c.dx + s, c.dy)
      ..lineTo(c.dx, c.dy + s)
      ..lineTo(c.dx - s, c.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawSmallCross(Canvas canvas, Offset c, double s, Paint paint) {
    canvas.drawLine(Offset(c.dx - s, c.dy), Offset(c.dx + s, c.dy), paint);
    canvas.drawLine(Offset(c.dx, c.dy - s), Offset(c.dx, c.dy + s), paint);
  }

  void _drawShortLine(Canvas canvas, Offset c, double len, Paint paint) {
    canvas.drawLine(
      Offset(c.dx - len / 2, c.dy),
      Offset(c.dx + len / 2, c.dy),
      paint,
    );
  }

  void _drawLeaf(Canvas canvas, Offset c, double s, Paint stroke, Paint fill) {
    final path = Path()
      ..moveTo(c.dx, c.dy - s)
      ..quadraticBezierTo(c.dx + s * 0.8, c.dy - s * 0.1, c.dx, c.dy + s)
      ..quadraticBezierTo(c.dx - s * 0.8, c.dy - s * 0.1, c.dx, c.dy - s)
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
    canvas.drawLine(
      Offset(c.dx, c.dy - s),
      Offset(c.dx, c.dy + s * 0.8),
      stroke,
    );
  }

  void _drawButterfly(Canvas canvas, Offset c, double s, Paint paint) {
    final leftTop = Rect.fromCenter(
      center: Offset(c.dx - s * 0.55, c.dy - s * 0.25),
      width: s * 1.1,
      height: s * 1.4,
    );
    final rightTop = Rect.fromCenter(
      center: Offset(c.dx + s * 0.55, c.dy - s * 0.25),
      width: s * 1.1,
      height: s * 1.4,
    );
    final leftBottom = Rect.fromCenter(
      center: Offset(c.dx - s * 0.45, c.dy + s * 0.6),
      width: s * 0.9,
      height: s * 1.0,
    );
    final rightBottom = Rect.fromCenter(
      center: Offset(c.dx + s * 0.45, c.dy + s * 0.6),
      width: s * 0.9,
      height: s * 1.0,
    );

    canvas.drawOval(leftTop, paint);
    canvas.drawOval(rightTop, paint);
    canvas.drawOval(leftBottom, paint);
    canvas.drawOval(rightBottom, paint);

    canvas.drawLine(
      Offset(c.dx, c.dy - s * 0.9),
      Offset(c.dx, c.dy + s * 1.0),
      paint,
    );
  }

  void _drawSpiral(Canvas canvas, Offset c, double s, Paint paint) {
    final path = Path();
    double r = 2;
    path.moveTo(c.dx, c.dy);
    for (double a = 0; a < 4.5 * pi; a += 0.22) {
      r += 0.55;
      path.lineTo(c.dx + cos(a) * r, c.dy + sin(a) * r);
    }
    canvas.drawPath(path, paint);
  }

  void _drawFlower(Canvas canvas, Offset c, double s, Paint paint) {
    for (int i = 0; i < 6; i++) {
      final a = (pi * 2 / 6) * i;
      final petalCenter = Offset(c.dx + cos(a) * s, c.dy + sin(a) * s);
      canvas.drawOval(
        Rect.fromCenter(center: petalCenter, width: s * 0.9, height: s * 1.4),
        paint,
      );
    }
    canvas.drawCircle(c, s * 0.35, paint);
  }

  void _drawMountain(Canvas canvas, Offset c, double s, Paint paint) {
    final path = Path()
      ..moveTo(c.dx - s, c.dy + s * 0.7)
      ..lineTo(c.dx - s * 0.35, c.dy - s * 0.4)
      ..lineTo(c.dx, c.dy + s * 0.2)
      ..lineTo(c.dx + s * 0.35, c.dy - s * 0.2)
      ..lineTo(c.dx + s, c.dy + s * 0.7);

    canvas.drawPath(path, paint);
    canvas.drawLine(
      Offset(c.dx - s * 1.1, c.dy + s * 0.72),
      Offset(c.dx + s * 1.1, c.dy + s * 0.72),
      paint,
    );
  }

  void _drawBotanicalSprout(Canvas canvas, Offset c, double s, Paint paint) {
    final path = Path()
      ..moveTo(c.dx, c.dy + s)
      ..quadraticBezierTo(c.dx, c.dy + s * 0.1, c.dx, c.dy - s * 0.9)
      ..moveTo(c.dx, c.dy)
      ..quadraticBezierTo(
        c.dx - s * 0.8,
        c.dy - s * 0.2,
        c.dx - s * 0.45,
        c.dy - s * 0.95,
      )
      ..moveTo(c.dx, c.dy)
      ..quadraticBezierTo(
        c.dx + s * 0.8,
        c.dy - s * 0.2,
        c.dx + s * 0.45,
        c.dy - s * 0.95,
      );

    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Offset c, double s, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerA = -pi / 2 + (i * 2 * pi / 5);
      final innerA = outerA + pi / 5;

      final outer = Offset(c.dx + cos(outerA) * s, c.dy + sin(outerA) * s);
      final inner = Offset(
        c.dx + cos(innerA) * s * 0.45,
        c.dy + sin(innerA) * s * 0.45,
      );

      if (i == 0) {
        path.moveTo(outer.dx, outer.dy);
      } else {
        path.lineTo(outer.dx, outer.dy);
      }
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PaperBackgroundPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.notebookLines != notebookLines ||
        oldDelegate.leaves != leaves;
  }
}
