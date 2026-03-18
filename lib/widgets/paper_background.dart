import 'package:flutter/material.dart';

class PaperBackground extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final bool notebookLines;
  final bool dotted;
  final bool leaves;

  const PaperBackground({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0xFFFFD150),
    this.notebookLines = true,
    this.dotted = false,
    this.leaves = false,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: backgroundColor),
      child: CustomPaint(
        painter: _PaperPainter(
          notebookLines: notebookLines,
          dotted: dotted,
          leaves: leaves,
          backgroundColor: backgroundColor,
        ),
        child: child,
      ),
    );
  }
}

class _PaperPainter extends CustomPainter {
  final bool notebookLines;
  final bool dotted;
  final bool leaves;
  final Color backgroundColor;

  const _PaperPainter({
    required this.notebookLines,
    required this.dotted,
    required this.leaves,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (notebookLines) {
      final linePaint = Paint()
        ..color = const Color(0xFF6B5F46).withOpacity(0.08)
        ..strokeWidth = 1;
      const gap = 34.0;
      for (double y = 24; y < size.height; y += gap) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
      }
    }

    if (dotted) {
      final dotPaint = Paint()..color = const Color(0xFF1C140D).withOpacity(0.10);
      for (double x = 18; x < size.width; x += 22) {
        for (double y = 18; y < size.height; y += 22) {
          canvas.drawCircle(Offset(x, y), 1.2, dotPaint);
        }
      }
    }

    final wrinklePaint = Paint()
      ..color = Colors.black.withOpacity(0.025)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final path = Path()
      ..moveTo(size.width * .12, 0)
      ..quadraticBezierTo(size.width * .16, size.height * .18, size.width * .14, size.height * .35)
      ..quadraticBezierTo(size.width * .12, size.height * .55, size.width * .18, size.height);
    canvas.drawPath(path, wrinklePaint);

    final edgePaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawLine(Offset(size.width * .15, 0), Offset(size.width * .15, size.height), edgePaint);

    final doodlePaint = Paint()
      ..color = Colors.black.withOpacity(0.045)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final doodle = Path()
      ..moveTo(size.width * .86, size.height * .12)
      ..quadraticBezierTo(size.width * .91, size.height * .09, size.width * .94, size.height * .14)
      ..moveTo(size.width * .90, size.height * .08)
      ..lineTo(size.width * .90, size.height * .18)
      ..moveTo(size.width * .85, size.height * .13)
      ..lineTo(size.width * .95, size.height * .13)
      ..moveTo(size.width * .08, size.height * .78)
      ..quadraticBezierTo(size.width * .11, size.height * .76, size.width * .13, size.height * .81)
      ..moveTo(size.width * .10, size.height * .74)
      ..lineTo(size.width * .10, size.height * .84);
    canvas.drawPath(doodle, doodlePaint);

    if (leaves) {
      final leafPaint = Paint()
        ..color = const Color(0xFFF8FAFC).withOpacity(0.15)
        ..style = PaintingStyle.fill;
      _leaf(canvas, Offset(size.width * .12, size.height * .28), 32, -0.5, leafPaint);
      _leaf(canvas, Offset(size.width * .82, size.height * .18), 26, 0.4, leafPaint);
      _leaf(canvas, Offset(size.width * .18, size.height * .82), 24, 0.7, leafPaint);
      _leaf(canvas, Offset(size.width * .82, size.height * .78), 34, -0.8, leafPaint);
      _lotus(canvas, Offset(size.width * .10, size.height * .18), 16, leafPaint);
    }
  }

  void _leaf(Canvas canvas, Offset center, double size, double rotation, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    final path = Path()
      ..moveTo(0, -size)
      ..quadraticBezierTo(size * 0.95, -size * 0.2, 0, size)
      ..quadraticBezierTo(-size * 0.95, -size * 0.2, 0, -size)
      ..close();
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _lotus(Canvas canvas, Offset center, double size, Paint paint) {
    final stroke = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final left = Path()
      ..moveTo(center.dx, center.dy)
      ..quadraticBezierTo(center.dx - size, center.dy - size * .8, center.dx - size * .55, center.dy - size * 1.6)
      ..quadraticBezierTo(center.dx - size * .15, center.dy - size * .9, center.dx, center.dy);
    final right = Path()
      ..moveTo(center.dx, center.dy)
      ..quadraticBezierTo(center.dx + size, center.dy - size * .8, center.dx + size * .55, center.dy - size * 1.6)
      ..quadraticBezierTo(center.dx + size * .15, center.dy - size * .9, center.dx, center.dy);
    final centerPetal = Path()
      ..moveTo(center.dx, center.dy - size * .2)
      ..quadraticBezierTo(center.dx, center.dy - size * 1.9, center.dx + size * .45, center.dy - size)
      ..quadraticBezierTo(center.dx, center.dy - size * .85, center.dx - size * .45, center.dy - size)
      ..quadraticBezierTo(center.dx, center.dy - size * 1.9, center.dx, center.dy - size * .2);
    canvas.drawPath(left, stroke);
    canvas.drawPath(right, stroke);
    canvas.drawPath(centerPetal, stroke);
    canvas.drawLine(Offset(center.dx - size * .8, center.dy + 2), Offset(center.dx + size * .8, center.dy + 2), stroke);
  }

  @override
  bool shouldRepaint(covariant _PaperPainter oldDelegate) =>
      oldDelegate.notebookLines != notebookLines ||
      oldDelegate.dotted != dotted ||
      oldDelegate.leaves != leaves ||
      oldDelegate.backgroundColor != backgroundColor;
}
