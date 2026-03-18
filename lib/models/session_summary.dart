class SessionSummary {
  final int completedCycles;
  final Duration totalFocusTime;
  final Duration totalBreakTime;

  const SessionSummary({
    required this.completedCycles,
    required this.totalFocusTime,
    required this.totalBreakTime,
  });

  String format(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${duration.inMinutes} min';
  }
}
