class PomodoroConfig {
  final int workMinutes;
  final int breakMinutes;
  final int totalCycles;

  const PomodoroConfig({
    required this.workMinutes,
    required this.breakMinutes,
    required this.totalCycles,
  });

  Duration get workDuration => Duration(minutes: workMinutes);
  Duration get breakDuration => Duration(minutes: breakMinutes);
}
