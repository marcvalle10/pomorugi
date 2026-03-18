import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/pomodoro_controller.dart';
import '../models/session_phase.dart';
import '../widgets/paper_background.dart';
import '../widgets/sketch_card.dart';
import '../widgets/sketch_progress_painter.dart';
import 'summary_screen.dart';

class TimerScreen extends StatefulWidget {
  static const routeName = '/timer';

  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  String breakMessage = 'Buen trabajo. Tómate un respiro.';
  PomodoroController? _controller;
  bool _manualPause = false;
  SessionPhase? _lastPhase;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final controller = context.read<PomodoroController>();
    if (_controller != controller) {
      _controller?.removeListener(_onControllerUpdate);
      _controller = controller;
      _controller!.addListener(_onControllerUpdate);
      _lastPhase = _controller!.phase;
      if (!_controller!.isRunning &&
          _controller!.phase != SessionPhase.summary) {
        _controller!.start();
      }
    }
  }

  void _onControllerUpdate() {
    if (!mounted || _controller == null) return;

    final currentPhase = _controller!.phase;
    final phaseChanged = _lastPhase != currentPhase;

    if (phaseChanged && currentPhase == SessionPhase.shortBreak) {
      breakMessage = _controller!.randomBreakMessage();
    }

    if (currentPhase == SessionPhase.summary) {
      Navigator.of(context).pushReplacementNamed(
        SummaryScreen.routeName,
        arguments: _controller!.buildSummary(),
      );
      return;
    }

    setState(() {
      _lastPhase = currentPhase;
    });

    if (phaseChanged && !_controller!.isRunning && !_manualPause) {
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted || _controller == null) return;
        if (_controller!.phase != SessionPhase.summary &&
            !_controller!.isRunning &&
            !_manualPause) {
          _controller!.start();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<PomodoroController>();
    final isBreak = c.phase == SessionPhase.shortBreak;
    final bg = isBreak ? const Color(0xFF458B73) : const Color(0xFFFFD150);
    final ink = isBreak ? const Color(0xFF000B58) : const Color(0xFF4A3739);
    final titleColor = isBreak ? Colors.white : const Color(0xFFF26076);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        color: bg,
        child: PaperBackground(
          backgroundColor: bg,
          notebookLines: !isBreak,
          leaves: isBreak,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
              child: Column(
                children: [
                  Text(
                    'PomoRugi',
                    style: TextStyle(
                      fontFamily: 'Caveat',
                      fontSize: 34,
                      color: ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Ciclo ${c.currentCycle} de ${c.config.totalCycles}',
                    style: TextStyle(
                      fontFamily: 'Caveat',
                      fontSize: 28,
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (!isBreak)
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.wb_sunny_outlined,
                        color: titleColor.withOpacity(0.7),
                        size: 48,
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.spa_outlined,
                        color: Colors.white.withOpacity(0.35),
                        size: 42,
                      ),
                    ),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 325,
                        height: 325,
                        child: CustomPaint(
                          painter: SketchProgressPainter(
                            progress: c.phaseProgress,
                            sketchReveal: c.sketchRevealProgress,
                            chaosVisibility: c.chaosVisibility,
                            isBreak: isBreak,
                            pattern: c.pattern,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  c.formattedRemaining,
                                  style: TextStyle(
                                    fontFamily: 'Caveat',
                                    fontSize: 76,
                                    color: ink,
                                    fontWeight: FontWeight.w700,
                                    height: 0.9,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  isBreak ? 'Break mode...' : 'Enfocado...',
                                  style: TextStyle(
                                    fontFamily: 'Caveat',
                                    fontSize: 24,
                                    color: ink.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    c.statusLabel,
                    style: TextStyle(
                      fontFamily: 'Caveat',
                      fontSize: 56,
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 20),
                    width: 82,
                    height: 8,
                    decoration: BoxDecoration(
                      color: ink.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          icon: c.isRunning ? Icons.pause : Icons.play_arrow,
                          label: c.isRunning ? 'Pausa' : 'Reanudar',
                          fill: Colors.white.withOpacity(isBreak ? 0.9 : 0.92),
                          ink: ink,
                          onTap: () {
                            setState(() {
                              _manualPause = c.isRunning;
                            });
                            c.toggle();
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _actionButton(
                          icon: Icons.skip_next,
                          label: 'Saltar',
                          fill:
                              (isBreak ? Colors.white : const Color(0xFFFF9760))
                                  .withOpacity(isBreak ? 0.25 : 0.25),
                          ink: ink,
                          onTap: () {
                            _manualPause = false;
                            c.pause();
                            c.skipPhase();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: _actionButton(
                      icon: Icons.logout,
                      label: 'Salir de la sesión',
                      fill: const Color(0xFFF26076),
                      ink: Colors.white,
                      onTap: _confirmExit,
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color fill,
    required Color ink,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return SizedBox(
      height: 78,
      child: SketchCard(
        rotation: filled ? -0.01 : 0.0,
        color: fill,
        borderColor: ink == Colors.white ? const Color(0xFF4A3739) : ink,
        shadowOffset: 2,
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: ink, size: 28),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Caveat',
                    fontSize: 28,
                    color: ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmExit() async {
    final controller = context.read<PomodoroController>();
    _manualPause = true;
    controller.pause();

    final exit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF8E7),
        title: const Text(
          'Abandonar sesión',
          style: TextStyle(fontFamily: 'Caveat', fontSize: 34),
        ),
        content: const Text(
          'Se perderá el progreso actual.',
          style: TextStyle(fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (exit == true) {
      Navigator.of(context).pop();
    } else {
      _manualPause = false;
      controller.start();
    }
  }
}
