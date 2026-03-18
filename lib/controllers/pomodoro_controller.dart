import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/pomodoro_config.dart';
import '../models/session_phase.dart';
import '../models/session_summary.dart';
import '../services/sketch_generator.dart';

class PomodoroController extends ChangeNotifier {
  PomodoroController(this.config) {
    _remaining = config.workDuration;
    _phaseTotal = config.workDuration;
    _pattern = SketchGenerator.randomPattern();
  }

  final PomodoroConfig config;
  final Random _random = Random();

  SessionPhase _phase = SessionPhase.focus;
  SessionPhase get phase => _phase;

  late Duration _remaining;
  Duration get remaining => _remaining;

  late Duration _phaseTotal;
  Duration get phaseTotal => _phaseTotal;

  int _currentCycle = 1;
  int get currentCycle => _currentCycle;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  Timer? _ticker;

  Duration _accFocus = Duration.zero;
  Duration _accBreak = Duration.zero;

  late SketchPattern _pattern;
  SketchPattern get pattern => _pattern;

  double get phaseProgress {
    if (_phaseTotal.inMilliseconds == 0) return 0;
    return 1 - (_remaining.inMilliseconds / _phaseTotal.inMilliseconds);
  }

  double get sketchRevealProgress {
    // first 30% = chaos, remaining 70% = reveal drawing
    final p = phaseProgress;
    if (p <= 0.3) return 0;
    return ((p - 0.3) / 0.7).clamp(0, 1);
  }

  double get chaosVisibility {
    final p = phaseProgress;
    if (p <= 0.2) return 1;
    if (p >= 0.65) return 0;
    return 1 - ((p - 0.2) / 0.45).clamp(0, 1);
  }

  String get statusLabel =>
      _phase == SessionPhase.focus ? '¡Enfócate!' : '¡Descansa!';

  String get formattedRemaining {
    final minutes = _remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = _remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void start() {
    if (_isRunning || _phase == SessionPhase.summary) return;
    _ticker?.cancel();
    _isRunning = true;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    notifyListeners();
  }

  void pause() {
    _ticker?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void toggle() => _isRunning ? pause() : start();

  void skipPhase() {
    _advancePhase();
  }

  void resetSession() {
    _ticker?.cancel();
    _phase = SessionPhase.focus;
    _remaining = config.workDuration;
    _phaseTotal = config.workDuration;
    _currentCycle = 1;
    _isRunning = false;
    _accFocus = Duration.zero;
    _accBreak = Duration.zero;
    _pattern = SketchGenerator.randomPattern();
    notifyListeners();
  }

  SessionSummary buildSummary() {
    return SessionSummary(
      completedCycles: config.totalCycles,
      totalFocusTime: _accFocus,
      totalBreakTime: _accBreak,
    );
  }

  String randomBreakMessage() {
    const messages = [
      'Buen trabajo. Respira y relaja la vista.',
      'Pausa corta. Suelta un poco los hombros.',
      'Excelente avance. Toma agua y vuelve con calma.',
      'Bien hecho. Un minuto de pausa también cuenta.',
    ];
    return messages[_random.nextInt(messages.length)];
  }

  void _tick() {
    if (_remaining.inSeconds <= 1) {
      _registerCompletedSecond();
      _advancePhase();
      return;
    }
    _registerCompletedSecond();
    _remaining -= const Duration(seconds: 1);
    notifyListeners();
  }

  void _registerCompletedSecond() {
    if (_phase == SessionPhase.focus) {
      _accFocus += const Duration(seconds: 1);
    } else if (_phase == SessionPhase.shortBreak) {
      _accBreak += const Duration(seconds: 1);
    }
  }

  void _advancePhase() {
    _ticker?.cancel();
    _ticker = null;
    _isRunning = false;

    if (_phase == SessionPhase.focus) {
      if (_currentCycle >= config.totalCycles) {
        _phase = SessionPhase.summary;
        _remaining = Duration.zero;
        _phaseTotal = Duration.zero;
      } else {
        _phase = SessionPhase.shortBreak;
        _remaining = config.breakDuration;
        _phaseTotal = config.breakDuration;
      }
    } else if (_currentCycle < config.totalCycles) {
      _currentCycle += 1;
      _phase = SessionPhase.focus;
      _remaining = config.workDuration;
      _phaseTotal = config.workDuration;
      _pattern = SketchGenerator.randomPattern();
    } else {
      _phase = SessionPhase.summary;
      _remaining = Duration.zero;
      _phaseTotal = Duration.zero;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
