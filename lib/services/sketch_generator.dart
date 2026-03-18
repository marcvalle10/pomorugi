import 'dart:math';
import 'package:flutter/material.dart';

enum SketchPatternType { foxFace, catFace, mandala, fish, owl, leaf }

class SketchStroke {
  final List<Offset> points;
  final double width;
  const SketchStroke({required this.points, required this.width});
}

class SketchPattern {
  final SketchPatternType type;
  final List<SketchStroke> guideStrokes;
  final List<SketchStroke> chaosStrokes;

  const SketchPattern({
    required this.type,
    required this.guideStrokes,
    required this.chaosStrokes,
  });
}

class SketchGenerator {
  static final Random _random = Random();

  static SketchPattern randomPattern() {
    final values = SketchPatternType.values;
    final type = values[_random.nextInt(values.length)];
    return patternFor(type);
  }

  static SketchPattern patternFor(SketchPatternType type) {
    switch (type) {
      case SketchPatternType.foxFace:
        return SketchPattern(
          type: type,
          guideStrokes: [
            _stroke(const [Offset(0.22, 0.35), Offset(0.35, 0.15), Offset(0.45, 0.35)], 3),
            _stroke(const [Offset(0.78, 0.35), Offset(0.65, 0.15), Offset(0.55, 0.35)], 3),
            _stroke(const [Offset(0.26, 0.45), Offset(0.35, 0.70), Offset(0.50, 0.82), Offset(0.65, 0.70), Offset(0.74, 0.45)], 3.2),
            _stroke(const [Offset(0.42, 0.52), Offset(0.40, 0.52), Offset(0.38, 0.55)], 2),
            _stroke(const [Offset(0.58, 0.52), Offset(0.60, 0.52), Offset(0.62, 0.55)], 2),
            _stroke(const [Offset(0.47, 0.63), Offset(0.50, 0.67), Offset(0.53, 0.63)], 2.8),
          ],
          chaosStrokes: _chaos(16),
        );
      case SketchPatternType.catFace:
        return SketchPattern(
          type: type,
          guideStrokes: [
            _stroke(const [Offset(0.28, 0.34), Offset(0.38, 0.16), Offset(0.44, 0.36)], 3),
            _stroke(const [Offset(0.72, 0.34), Offset(0.62, 0.16), Offset(0.56, 0.36)], 3),
            _stroke(const [Offset(0.28, 0.40), Offset(0.24, 0.58), Offset(0.35, 0.77), Offset(0.50, 0.83), Offset(0.65, 0.77), Offset(0.76, 0.58), Offset(0.72, 0.40)], 3),
            _stroke(const [Offset(0.43, 0.53), Offset(0.42, 0.53), Offset(0.41, 0.55)], 2),
            _stroke(const [Offset(0.57, 0.53), Offset(0.58, 0.53), Offset(0.59, 0.55)], 2),
            _stroke(const [Offset(0.50, 0.61), Offset(0.50, 0.66)], 2.6),
            _stroke(const [Offset(0.50, 0.66), Offset(0.45, 0.69)], 2),
            _stroke(const [Offset(0.50, 0.66), Offset(0.55, 0.69)], 2),
          ],
          chaosStrokes: _chaos(18),
        );
      case SketchPatternType.mandala:
        return SketchPattern(
          type: type,
          guideStrokes: [
            _circleish(0.50, 0.50, 0.32, 12, 2.2),
            _circleish(0.50, 0.50, 0.24, 12, 2.0),
            _petals(10, 0.18, 0.30),
            _petals(6, 0.06, 0.18),
          ],
          chaosStrokes: _chaos(22),
        );
      case SketchPatternType.fish:
        return SketchPattern(
          type: type,
          guideStrokes: [
            _stroke(const [Offset(0.22, 0.52), Offset(0.35, 0.32), Offset(0.62, 0.32), Offset(0.78, 0.52), Offset(0.62, 0.72), Offset(0.35, 0.72), Offset(0.22, 0.52)], 3),
            _stroke(const [Offset(0.78, 0.52), Offset(0.90, 0.36), Offset(0.90, 0.68), Offset(0.78, 0.52)], 3),
            _stroke(const [Offset(0.36, 0.49), Offset(0.36, 0.49)], 3.5),
            _stroke(const [Offset(0.48, 0.42), Offset(0.63, 0.52), Offset(0.48, 0.62)], 2),
          ],
          chaosStrokes: _chaos(14),
        );
      case SketchPatternType.owl:
        return SketchPattern(
          type: type,
          guideStrokes: [
            _stroke(const [Offset(0.34, 0.25), Offset(0.26, 0.45), Offset(0.32, 0.78), Offset(0.50, 0.88), Offset(0.68, 0.78), Offset(0.74, 0.45), Offset(0.66, 0.25)], 3),
            _circleish(0.42, 0.48, 0.10, 10, 2.2),
            _circleish(0.58, 0.48, 0.10, 10, 2.2),
            _stroke(const [Offset(0.49, 0.57), Offset(0.50, 0.63), Offset(0.51, 0.57)], 2.4),
          ],
          chaosStrokes: _chaos(15),
        );
      case SketchPatternType.leaf:
        return SketchPattern(
          type: type,
          guideStrokes: [
            _stroke(const [Offset(0.50, 0.18), Offset(0.32, 0.40), Offset(0.28, 0.62), Offset(0.50, 0.84), Offset(0.72, 0.62), Offset(0.68, 0.40), Offset(0.50, 0.18)], 3),
            _stroke(const [Offset(0.50, 0.22), Offset(0.50, 0.82)], 2.2),
            _stroke(const [Offset(0.50, 0.36), Offset(0.40, 0.44)], 1.8),
            _stroke(const [Offset(0.50, 0.50), Offset(0.40, 0.58)], 1.8),
            _stroke(const [Offset(0.50, 0.42), Offset(0.60, 0.50)], 1.8),
            _stroke(const [Offset(0.50, 0.58), Offset(0.62, 0.66)], 1.8),
          ],
          chaosStrokes: _chaos(12),
        );
    }
  }

  static List<SketchStroke> _chaos(int count) {
    return List.generate(count, (index) {
      final start = Offset(_random.nextDouble(), _random.nextDouble());
      final mid = Offset(_random.nextDouble(), _random.nextDouble());
      final end = Offset(_random.nextDouble(), _random.nextDouble());
      return _stroke([start, mid, end], 1.2 + _random.nextDouble() * 1.8);
    });
  }

  static SketchStroke _stroke(List<Offset> points, double width) => SketchStroke(points: points, width: width);

  static SketchStroke _circleish(double cx, double cy, double r, int steps, double width) {
    final pts = <Offset>[];
    for (int i = 0; i <= steps; i++) {
      final t = (i / steps) * pi * 2;
      final wobble = 1 + (i.isEven ? 0.03 : -0.03);
      pts.add(Offset(cx + cos(t) * r * wobble, cy + sin(t) * r * wobble));
    }
    return SketchStroke(points: pts, width: width);
  }

  static SketchStroke _petals(int petals, double inner, double outer) {
    final pts = <Offset>[];
    for (int i = 0; i <= petals * 2; i++) {
      final angle = (i / (petals * 2)) * pi * 2;
      final radius = i.isEven ? outer : inner;
      pts.add(Offset(0.50 + cos(angle) * radius, 0.50 + sin(angle) * radius));
    }
    return SketchStroke(points: pts, width: 2.0);
  }
}
