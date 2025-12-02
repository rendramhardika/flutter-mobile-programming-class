import 'dart:async';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service untuk menjalankan timer di background
/// Konsep: Background Service, Isolate, Notification
@pragma('vm:entry-point')
class TimerService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Inisialisasi background service
  @pragma('vm:entry-point')
  static Future<void> initializeService() async {
    print('[TimerService] Initializing timer service configuration...');
    final service = FlutterBackgroundService();

    try {
      // Konfigurasi notification channel untuk Android
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'timer_service_channel', // id
        'Timer Service', // title
        description: 'Channel untuk timer service notification',
        importance: Importance.high,
      );

      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      
      print('[TimerService] Notification channel created');

      // Konfigurasi service
      await service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: false,
          isForegroundMode: true,
          notificationChannelId: 'timer_service_channel',
          initialNotificationTitle: 'Timer Service',
          initialNotificationContent: 'Timer siap digunakan',
          foregroundServiceNotificationId: 888,
        ),
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: onStart,
          onBackground: onIosBackground,
        ),
      );
      
      print('[TimerService] Service configuration completed');
    } catch (e) {
      print('[TimerService] Error in service configuration: $e');
      rethrow;
    }
  }

  /// Entry point untuk iOS background
  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }

  /// Entry point untuk background service
  /// Ini adalah fungsi yang berjalan di isolate terpisah
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    print('[TimerService] === BACKGROUND SERVICE STARTED ===');
    DartPluginRegistrant.ensureInitialized();
    print('[TimerService] DartPluginRegistrant initialized');

    // Buat instance notification plugin untuk isolate ini
    final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();
    print('[TimerService] NotificationsPlugin created');

    // CRITICAL: Tampilkan notifikasi segera untuk foreground service
    // Ini mencegah ForegroundServiceDidNotStartInTimeException
    try {
      await _showInitialNotification(notificationsPlugin);
      print('[TimerService] Initial notification shown');
    } catch (e) {
      print('[TimerService] Error showing initial notification: $e');
    }

    // Variabel untuk tracking timer
    int remainingSeconds = 0;
    bool isRunning = false;
    Timer? timer;

    // Listen untuk perintah dari UI
    service.on('timerStart').listen((event) async {
      final duration = event?['duration'] as int? ?? 1500; // Default 25 menit
      print('[TimerService] Received timerStart command with duration: $duration');
      remainingSeconds = duration;
      isRunning = true;

      // Kirim initial update ke UI
      service.invoke('update', {
        'remaining': remainingSeconds,
        'isRunning': isRunning,
      });
      print('[Service] Sent initial update to UI');

      // Mulai timer
      timer?.cancel();
      print('[Service] Starting periodic timer...');
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
        print('[Service] Timer tick - isRunning: $isRunning, remaining: $remainingSeconds');
        
        if (!isRunning) {
          print('[Service] Timer stopped, canceling periodic timer');
          t.cancel();
          return;
        }

        if (remainingSeconds > 0) {
          remainingSeconds--;
          print('[Service] Countdown: $remainingSeconds seconds remaining');

          // Update UI melalui invoke
          service.invoke('update', {
            'remaining': remainingSeconds,
            'isRunning': isRunning,
          });

          // Update notification
          print('[Service] Updating notification with remaining: $remainingSeconds');
          _updateNotification(notificationsPlugin, remainingSeconds);
          
          print('[Service] Sent update to UI - remaining: $remainingSeconds');
        } else {
          // Timer selesai
          print('[Service] Timer completed! Stopping timer...');
          t.cancel();
          isRunning = false;
          service.invoke('update', {
            'remaining': 0,
            'isRunning': false,
          });
          print('[Service] Sent completion update to UI');
          _showCompletionNotification(notificationsPlugin);
        }
      });
    });

    service.on('timerStop').listen((event) {
      print('[TimerService] Received timerStop command');
      isRunning = false;
      timer?.cancel();
      service.invoke('update', {
        'remaining': remainingSeconds,
        'isRunning': false,
      });
    });

    service.on('timerReset').listen((event) {
      print('[TimerService] Received timerReset command');
      isRunning = false;
      timer?.cancel();
      remainingSeconds = 0;
      service.invoke('update', {
        'remaining': 0,
        'isRunning': false,
      });
    });

    service.on('stopService').listen((event) {
      timer?.cancel();
      service.stopSelf();
    });
    
    print('[TimerService] === ALL EVENT HANDLERS SETUP COMPLETE ===');
    print('[TimerService] Background service is ready to receive timer commands');
  }

  /// Tampilkan notifikasi awal saat service start
  @pragma('vm:entry-point')
  static Future<void> _showInitialNotification(
      FlutterLocalNotificationsPlugin plugin) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'timer_service_channel',
      'Timer Service',
      channelDescription: 'Channel untuk timer service notification',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await plugin.show(
      888,
      'Timer Service',
      'Timer siap digunakan',
      notificationDetails,
    );
  }

  /// Update notification dengan waktu tersisa
  @pragma('vm:entry-point')
  static Future<void> _updateNotification(
      FlutterLocalNotificationsPlugin plugin, int remainingSeconds) async {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'timer_service_channel',
      'Timer Service',
      channelDescription: 'Channel untuk timer service notification',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await plugin.show(
      888,
      'Timer Berjalan',
      'Waktu tersisa: $timeString',
      notificationDetails,
    );
  }

  /// Tampilkan notification saat timer selesai
  @pragma('vm:entry-point')
  static Future<void> _showCompletionNotification(
      FlutterLocalNotificationsPlugin plugin) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'timer_completion_channel',
      'Timer Completion',
      channelDescription: 'Notifikasi saat timer selesai',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await plugin.show(
      999,
      'Timer Selesai! 🎉',
      'Waktu Pomodoro Anda telah selesai',
      notificationDetails,
    );
  }

  /// Inisialisasi notification plugin
  @pragma('vm:entry-point')
  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
    );

    // Buat channel untuk completion notification
    const AndroidNotificationChannel completionChannel = AndroidNotificationChannel(
      'timer_completion_channel',
      'Timer Completion',
      description: 'Notifikasi saat timer selesai',
      importance: Importance.max,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(completionChannel);
  }

  /// Start background service
  @pragma('vm:entry-point')
  static Future<void> startService() async {
    print('[TimerService] Starting background service...');
    final service = FlutterBackgroundService();
    try {
      await service.startService();
      print('[TimerService] Service start command completed');
    } catch (e) {
      print('[TimerService] Error starting service: $e');
      rethrow;
    }
  }

  /// Stop background service
  @pragma('vm:entry-point')
  static Future<void> stopService() async {
    print('[TimerService] Stopping background service...');
    final service = FlutterBackgroundService();
    try {
      service.invoke('stopService');
      print('[TimerService] Service stop command sent');
    } catch (e) {
      print('[TimerService] Error stopping service: $e');
    }
  }

  /// Start timer
  @pragma('vm:entry-point')
  static void startTimer(int durationInSeconds) {
    print('[TimerService] Static startTimer called with duration: $durationInSeconds');
    final service = FlutterBackgroundService();
    try {
      service.invoke('timerStart', {'duration': durationInSeconds});
      print('[TimerService] Timer start command sent to service');
    } catch (e) {
      print('[TimerService] Error sending start command: $e');
    }
  }

  /// Stop timer
  @pragma('vm:entry-point')
  static void stopTimer() {
    print('[TimerService] Static stopTimer called');
    final service = FlutterBackgroundService();
    service.invoke('timerStop');
  }

  /// Reset timer
  @pragma('vm:entry-point')
  static void resetTimer() {
    print('[TimerService] Static resetTimer called');
    final service = FlutterBackgroundService();
    service.invoke('timerReset');
  }
}
