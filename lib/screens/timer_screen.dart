import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/pomodoro_controller.dart';
import '../models/session_phase.dart';
import '../services/notification_service.dart';
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

class _TimerScreenState extends State<TimerScreen> with WidgetsBindingObserver {
  String breakMessage = 'Buen trabajo. Tómate un respiro.';
  PomodoroController? _controller;

  bool _manualPause = false;
  bool _appInBackground = false;
  bool _navigatingToSummary = false;

  SessionPhase? _lastPhase;

  Timer? _pauseReminderTimer;
  int _pauseReminderCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final controller = context.read<PomodoroController>();

    if (_controller != controller) {
      _controller?.removeListener(_onControllerUpdate);
      _controller = controller;
      _controller!.addListener(_onControllerUpdate);

      _lastPhase = _controller!.phase;
      _navigatingToSummary = false;

      if (!_controller!.isRunning &&
          _controller!.phase != SessionPhase.summary) {
        _controller!.start();
      }

      _syncStatusNotification();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appInBackground =
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive;

    _syncStatusNotification();
  }

  void _onControllerUpdate() {
    if (!mounted || _controller == null) return;

    final controller = _controller!;
    final currentPhase = controller.phase;
    final phaseChanged = _lastPhase != currentPhase;

    if (controller.isRunning) {
      _manualPause = false;
      _cancelPauseReminderLoop();
    } else if (_manualPause && currentPhase != SessionPhase.summary) {
      _ensurePauseReminderLoop();
    }

    if (phaseChanged) {
      _handlePhaseTransition(_lastPhase, currentPhase);

      if (currentPhase == SessionPhase.shortBreak) {
        breakMessage = controller.randomBreakMessage();
      }
    }

    if (currentPhase == SessionPhase.summary) {
      if (_navigatingToSummary) return;
      _navigatingToSummary = true;

      _cancelPauseReminderLoop();
      NotificationService.instance.cancelStatus();
      NotificationService.instance.cancelPauseReminder();
      NotificationService.instance.showSessionComplete(
        body:
            'Completaste ${controller.config.totalCycles} ciclos. Toca para ver tu resumen.',
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _controller == null) return;

        Navigator.of(context).pushReplacementNamed(
          SummaryScreen.routeName,
          arguments: controller.buildSummary(),
        );
      });
      return;
    }

    _lastPhase = currentPhase;

    if (mounted) {
      setState(() {});
    }

    _syncStatusNotification();

    if (phaseChanged && !controller.isRunning && !_manualPause) {
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted || _controller == null) return;

        final c = _controller!;
        if (c.phase != SessionPhase.summary && !c.isRunning && !_manualPause) {
          c.start();
        }
      });
    }
  }

  void _handlePhaseTransition(
    SessionPhase? previousPhase,
    SessionPhase currentPhase,
  ) {
    if (_controller == null) return;

    if (currentPhase == SessionPhase.shortBreak) {
      NotificationService.instance.showTransition(
        title: 'Tiempo de descansar',
        body: 'Terminaste el bloque de enfoque. Ahora toca una pausa corta.',
      );
      return;
    }

    if (previousPhase == SessionPhase.shortBreak &&
        currentPhase == SessionPhase.focus) {
      NotificationService.instance.showTransition(
        title: 'De vuelta al enfoque',
        body: 'Se terminó el descanso. Arranca el siguiente ciclo.',
      );
    }
  }

  void _ensurePauseReminderLoop() {
    if (_pauseReminderTimer != null) return;

    _pauseReminderCount = 0;
    _schedulePauseReminder(const Duration(minutes: 3));
  }

  void _schedulePauseReminder(Duration delay) {
    _pauseReminderTimer?.cancel();

    _pauseReminderTimer = Timer(delay, () {
      if (!mounted ||
          _controller == null ||
          !_manualPause ||
          _controller!.isRunning ||
          _controller!.phase == SessionPhase.summary) {
        _pauseReminderTimer?.cancel();
        _pauseReminderTimer = null;
        return;
      }

      _pauseReminderCount += 1;

      final minutesPaused = _pauseReminderCount == 1
          ? 3
          : 3 + ((_pauseReminderCount - 1) * 6);

      final body = _pauseReminderCount == 1
          ? '¿No piensas volver? La sesión sigue pausada desde hace 3 minutos.'
          : 'Sigues en pausa desde hace $minutesPaused minutos. PomoRugi empieza a sospechar abandono.';

      NotificationService.instance.showPauseReminder(body: body);
      _syncStatusNotification();

      _schedulePauseReminder(const Duration(minutes: 6));
    });
  }

  void _cancelPauseReminderLoop() {
    _pauseReminderTimer?.cancel();
    _pauseReminderTimer = null;
    _pauseReminderCount = 0;
    NotificationService.instance.cancelPauseReminder();
  }

  Future<void> _syncStatusNotification() async {
    if (_controller == null) return;

    if (!_appInBackground || _controller!.phase == SessionPhase.summary) {
      await NotificationService.instance.cancelStatus();
      return;
    }

    final isBreak = _controller!.phase == SessionPhase.shortBreak;

    final title = _manualPause || !_controller!.isRunning
        ? 'PomoRugi en pausa'
        : (isBreak ? 'Descanso en curso' : 'Enfoque en curso');

    final body = _manualPause || !_controller!.isRunning
        ? 'Quedan ${_controller!.formattedRemaining}. Toca para volver y continuar.'
        : 'Quedan ${_controller!.formattedRemaining}. Ciclo ${_controller!.currentCycle} de ${_controller!.config.totalCycles}.';

    await NotificationService.instance.showStatus(
      title: title,
      body: body,
      paused: _manualPause || !_controller!.isRunning,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.removeListener(_onControllerUpdate);
    _pauseReminderTimer?.cancel();
    NotificationService.instance.cancelStatus();
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
                            if (c.isRunning) {
                              _manualPause = true;
                              c.pause();
                              _ensurePauseReminderLoop();
                            } else {
                              _manualPause = false;
                              _cancelPauseReminderLoop();
                              c.start();
                            }

                            _syncStatusNotification();

                            if (mounted) {
                              setState(() {});
                            }
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
                                  .withOpacity(0.25),
                          ink: ink,
                          onTap: () {
                            _manualPause = false;
                            _cancelPauseReminderLoop();
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
    _ensurePauseReminderLoop();
    await _syncStatusNotification();

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
      _cancelPauseReminderLoop();
      await NotificationService.instance.cancelAllSessionNotifications();
      Navigator.of(context).pop();
    } else {
      _manualPause = false;
      _cancelPauseReminderLoop();
      controller.start();
      await _syncStatusNotification();
      if (mounted) {
        setState(() {});
      }
    }
  }
}
