import 'package:flutter/material.dart';

class SketchCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final double rotation;
  final Color borderColor;
  final double shadowOffset;

  const SketchCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.rotation = 0,
    this.borderColor = const Color(0xFF4A3739),
    this.shadowOffset = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: CustomPaint(
        painter: _SketchBorderPainter(borderColor: borderColor, shadowOffset: shadowOffset),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color ?? Colors.white.withOpacity(.90),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SketchBorderPainter extends CustomPainter {
  final Color borderColor;
  final double shadowOffset;

  const _SketchBorderPainter({required this.borderColor, required this.shadowOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(3, 3, size.width - 6, size.height - 6);
    final path = Path()
      ..moveTo(rect.left + 12, rect.top + 4)
      ..quadraticBezierTo(rect.center.dx, rect.top - 2, rect.right - 12, rect.top + 6)
      ..quadraticBezierTo(rect.right + 1, rect.top + 18, rect.right - 2, rect.bottom - 12)
      ..quadraticBezierTo(rect.center.dx, rect.bottom + 1, rect.left + 10, rect.bottom - 5)
      ..quadraticBezierTo(rect.left - 2, rect.center.dy, rect.left + 4, rect.top + 12)
      ..close();

    final shadow = Paint()..color = borderColor.withOpacity(0.12);
    canvas.save();
    canvas.translate(shadowOffset, shadowOffset);
    canvas.drawPath(path, shadow);
    canvas.restore();

    final fill = Paint()..color = Colors.white.withOpacity(0.92);
    canvas.drawPath(path, fill);

    final border = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(covariant _SketchBorderPainter oldDelegate) =>
      oldDelegate.borderColor != borderColor || oldDelegate.shadowOffset != shadowOffset;
}
