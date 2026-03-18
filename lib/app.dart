import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/pomodoro_controller.dart';
import 'core/theme/sketch_theme.dart';
import 'models/pomodoro_config.dart';
import 'models/session_summary.dart';
import 'screens/setup_screen.dart';
import 'screens/summary_screen.dart';
import 'screens/timer_screen.dart';

class SketchFocusApp extends StatelessWidget {
  const SketchFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SketchFocus',
      theme: SketchTheme.light(),
      initialRoute: SetupScreen.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case SetupScreen.routeName:
            return MaterialPageRoute(builder: (_) => const SetupScreen());

          case TimerScreen.routeName:
            final config = settings.arguments as PomodoroConfig?;

            if (config == null) {
              return _errorRoute(
                'No se recibió PomodoroConfig al abrir TimerScreen.',
              );
            }

            return MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider<PomodoroController>(
                create: (_) => PomodoroController(config),
                child: const TimerScreen(),
              ),
            );

          case SummaryScreen.routeName:
            final summary = settings.arguments as SessionSummary?;

            if (summary == null) {
              return _errorRoute(
                'No se recibió SessionSummary al abrir SummaryScreen.',
              );
            }

            return MaterialPageRoute(
              builder: (_) => SummaryScreen(summary: summary),
            );

          default:
            return _errorRoute('Ruta no encontrada: ${settings.name}');
        }
      },
    );
  }

  MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
