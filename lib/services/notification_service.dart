import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const String _alertsChannelId = 'pomorugi_alerts';
  static const String _alertsChannelName = 'PomoRugi alertas';
  static const String _alertsChannelDescription = 'Alertas de cambio de sesión, descanso y recordatorios';

  static const String _statusChannelId = 'pomorugi_status';
  static const String _statusChannelName = 'PomoRugi estado';
  static const String _statusChannelDescription = 'Estado persistente de la sesión Pomodoro';

  static const int transitionNotificationId = 1101;
  static const int sessionDoneNotificationId = 1102;
  static const int pauseReminderNotificationId = 1103;
  static const int statusNotificationId = 1104;

  Future<void> init() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _alertsChannelId,
        _alertsChannelName,
        description: _alertsChannelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _statusChannelId,
        _statusChannelName,
        description: _statusChannelDescription,
        importance: Importance.high,
        playSound: false,
      ),
    );

    _initialized = true;
  }

  Future<void> showTransition({required String title, required String body}) async {
    await init();
    await _plugin.show(
      transitionNotificationId,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _alertsChannelId,
          _alertsChannelName,
          channelDescription: _alertsChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          category: AndroidNotificationCategory.alarm,
          ticker: 'PomoRugi alerta',
          styleInformation: const BigTextStyleInformation(''),
        ),
      ),
    );
  }

  Future<void> showSessionComplete({required String body}) async {
    await init();
    await _plugin.show(
      sessionDoneNotificationId,
      'Sesión completada',
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _alertsChannelId,
          _alertsChannelName,
          channelDescription: _alertsChannelDescription,
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          category: AndroidNotificationCategory.reminder,
          ticker: 'PomoRugi finalizado',
        ),
      ),
    );
  }

  Future<void> showPauseReminder({required String body}) async {
    await init();
    await _plugin.show(
      pauseReminderNotificationId,
      'PomoRugi sigue en pausa',
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _alertsChannelId,
          _alertsChannelName,
          channelDescription: _alertsChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          category: AndroidNotificationCategory.reminder,
          ticker: 'PomoRugi en pausa',
        ),
      ),
    );
  }

  Future<void> showStatus({required String title, required String body, bool paused = false}) async {
    await init();
    await _plugin.show(
      statusNotificationId,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _statusChannelId,
          _statusChannelName,
          channelDescription: _statusChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
          playSound: false,
          ongoing: true,
          autoCancel: false,
          onlyAlertOnce: true,
          showWhen: false,
          category: paused ? AndroidNotificationCategory.reminder : AndroidNotificationCategory.progress,
        ),
      ),
    );
  }

  Future<void> cancelStatus() async {
    await _plugin.cancel(statusNotificationId);
  }

  Future<void> cancelPauseReminder() async {
    await _plugin.cancel(pauseReminderNotificationId);
  }

  Future<void> cancelAllSessionNotifications() async {
    await _plugin.cancel(transitionNotificationId);
    await _plugin.cancel(sessionDoneNotificationId);
    await _plugin.cancel(pauseReminderNotificationId);
    await _plugin.cancel(statusNotificationId);
  }
}
