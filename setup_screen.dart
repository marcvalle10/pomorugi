import 'package:flutter/material.dart';

import '../models/pomodoro_config.dart';
import '../widgets/paper_background.dart';
import '../widgets/sketch_card.dart';
import 'timer_screen.dart';

class SetupScreen extends StatefulWidget {
  static const routeName = '/';

  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  double work = 25;
  double shortBreak = 5;
  double cycles = 4;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF2D2A2E);
    const primary = Color(0xFFF25F75);

    return Scaffold(
      body: PaperBackground(
        backgroundColor: const Color(0xFFFDFAE6),
        notebookLines: true,
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: 70,
                right: 24,
                child: Icon(Icons.wb_sunny_outlined, color: primary, size: 56),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: ink, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.school_outlined, color: ink),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PomoRugi',
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(color: primary, height: 0.9),
                            ),
                            const Text(
                              'Universidad de Sonora',
                              style: TextStyle(
                                fontFamily: 'Caveat',
                                fontSize: 18,
                                color: ink,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    SketchCard(
                      rotation: -0.012,
                      color: Colors.white.withOpacity(0.55),
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.group_outlined, color: primary),
                              SizedBox(width: 8),
                              Text(
                                'Miembros del equipo',
                                style: TextStyle(
                                  fontFamily: 'Caveat',
                                  fontSize: 28,
                                  color: ink,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Vallejo Leyva Marcos \n Casas Gastelum Ana Cecilia \n Murillo Monga Joshua David',
                            style: TextStyle(
                              fontFamily: 'Caveat',
                              fontSize: 22,
                              color: ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        children: [
                          _stepSlider(
                            'Duración del trabajo',
                            work,
                            1,
                            60,
                            primary,
                            (v) => setState(() => work = v),
                            suffix: 'min',
                          ),
                          _stepSlider(
                            'Descanso corto',
                            shortBreak,
                            1,
                            30,
                            const Color(0xFF56C5C8),
                            (v) => setState(() => shortBreak = v),
                            suffix: 'min',
                          ),
                          _stepSlider(
                            'Ciclos totales',
                            cycles,
                            1,
                            8,
                            const Color(0xFFE7B63A),
                            (v) => setState(() => cycles = v),
                            suffix: '',
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: SizedBox(
                              width: double.infinity,
                              child: Transform.rotate(
                                angle: -0.01,
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    side: const BorderSide(
                                      color: ink,
                                      width: 2.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  onPressed: () {
                                    final config = PomodoroConfig(
                                      workMinutes: work.round(),
                                      breakMinutes: shortBreak.round(),
                                      totalCycles: cycles.round(),
                                    );
                                    Navigator.of(context).pushNamed(
                                      TimerScreen.routeName,
                                      arguments: config,
                                    );
                                  },
                                  child: const Text(
                                    'COMENZAR',
                                    style: TextStyle(
                                      fontFamily: 'Caveat',
                                      fontSize: 34,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepSlider(
    String label,
    double value,
    double min,
    double max,
    Color color,
    ValueChanged<double> onChanged, {
    required String suffix,
  }) {
    const ink = Color(0xFF2D2A2E);
    final divisions = (max - min).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Caveat',
                    fontSize: 30,
                    color: ink,
                  ),
                ),
              ),
              Text(
                '${value.round()} ${suffix}'.trim(),
                style: TextStyle(
                  fontFamily: 'Caveat',
                  fontSize: 34,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _roundButton(
                Icons.remove,
                () => onChanged((value - 1).clamp(min, max)),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: color,
                    inactiveTrackColor: ink.withOpacity(0.15),
                    thumbColor: Colors.white,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: divisions,
                    onChanged: onChanged,
                  ),
                ),
              ),
              _roundButton(
                Icons.add,
                () => onChanged((value + 1).clamp(min, max)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF2D2A2E), width: 2),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF2D2A2E)),
        ),
      ),
    );
  }
}
