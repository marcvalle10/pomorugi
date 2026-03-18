import 'package:flutter/material.dart';

import '../models/session_summary.dart';
import '../widgets/paper_background.dart';
import '../widgets/sketch_card.dart';
import 'setup_screen.dart';

class SummaryScreen extends StatelessWidget {
  static const routeName = '/summary';

  final SessionSummary summary;

  const SummaryScreen({super.key, required this.summary});

  String get message {
    if (summary.completedCycles <= 2) return '¡Buen arranque!';
    if (summary.completedCycles <= 5) return '¡Excelente ritmo!';
    return '¡Nivel bestial!';
  }

  String get subtitle =>
      'Completaste ${summary.completedCycles} ciclo${summary.completedCycles == 1 ? '' : 's'} con muy buen ritmo.';

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF1C140D);
    const warmRed = Color(0xFFFF5F5F);
    const coolTeal = Color(0xFF2D9DA6);
    const sunnyYellow = Color(0xFFFFD93D);
    const softPurple = Color(0xFFA888FF);

    return Scaffold(
      body: PaperBackground(
        backgroundColor: const Color(0xFFFFF8E7),
        notebookLines: false,
        dotted: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 40),
                    const Spacer(),
                    const Text(
                      'Session Summary',
                      style: TextStyle(
                        fontFamily: 'Caveat',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: ink,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          SetupScreen.routeName,
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.close, size: 34, color: ink),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Positioned(
                      left: 18,
                      top: 8,
                      child: Icon(Icons.star, color: sunnyYellow, size: 34),
                    ),
                    const Positioned(
                      right: 36,
                      bottom: 28,
                      child: Icon(
                        Icons.auto_awesome,
                        color: coolTeal,
                        size: 28,
                      ),
                    ),
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3B6),
                        shape: BoxShape.circle,
                        border: Border.all(color: ink, width: 3),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.task_alt_rounded,
                          color: ink,
                          size: 92,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 34,
                      child: _sticker('AWESOME!', warmRed),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Caveat',
                    fontWeight: FontWeight.w700,
                    fontSize: 52,
                    color: ink,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: ink.withOpacity(0.55),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _miniBar(coolTeal, 50),
                    const SizedBox(width: 10),
                    _miniBar(warmRed, 62),
                    const SizedBox(width: 10),
                    _miniBar(sunnyYellow, 78),
                  ],
                ),
                const SizedBox(height: 26),
                SketchCard(
                  rotation: -0.008,
                  color: Colors.white.withOpacity(0.92),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      _summaryRow(
                        icon: Icons.loop_rounded,
                        iconColor: coolTeal,
                        label: 'Total Cycles',
                        value: '${summary.completedCycles}',
                      ),
                      _divider(),
                      _summaryRow(
                        icon: Icons.timer_outlined,
                        iconColor: warmRed,
                        label: 'Total Work',
                        value: summary.format(summary.totalFocusTime),
                      ),
                      _divider(),
                      _summaryRow(
                        icon: Icons.free_breakfast_outlined,
                        iconColor: softPurple,
                        label: 'Total Break',
                        value: summary.format(summary.totalBreakTime),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        SetupScreen.routeName,
                        (route) => false,
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFA9324),
                      foregroundColor: ink,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      side: const BorderSide(color: ink, width: 2.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Nueva Sesión',
                      style: TextStyle(
                        fontFamily: 'Caveat',
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.edit_note, color: warmRed, size: 36),
                    Icon(Icons.brush_outlined, color: coolTeal, size: 34),
                    Icon(Icons.gesture_outlined, color: softPurple, size: 34),
                    Icon(Icons.palette_outlined, color: sunnyYellow, size: 34),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() => Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    height: 1,
    color: const Color(0x22000000),
  );

  Widget _summaryRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 34),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: const Color(0xFF1C140D).withOpacity(0.55),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Caveat',
              fontWeight: FontWeight.w700,
              fontSize: 34,
              color: Color(0xFF1C140D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniBar(Color color, double width) => Container(
    width: width,
    height: 6,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
  );

  Widget _sticker(String text, Color color) {
    return Transform.rotate(
      angle: 0.18,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: const Color(0xFF1C140D), width: 2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w900,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
