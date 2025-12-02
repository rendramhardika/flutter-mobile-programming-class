import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/download_item.dart';

/// Service untuk menjalankan download simulasi di background
/// Konsep: Background Service, Progress Tracking, Queue Management
@pragma('vm:entry-point')
class DownloadService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Inisialisasi download service
  @pragma('vm:entry-point')
  static Future<void> initializeService() async {
    print('[DownloadService] Initializing service configuration...');
    final service = FlutterBackgroundService();

    try {
      // Konfigurasi notification channel untuk download
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'download_service_channel',
        'Download Service',
        description: 'Channel untuk download service notification',
        importance: Importance.high,
      );

      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      
      print('[DownloadService] Notification channel created');

      // Konfigurasi service
      await service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: false,
          isForegroundMode: true,
          notificationChannelId: 'download_service_channel',
          initialNotificationTitle: 'Download Manager',
          initialNotificationContent: 'Siap mendownload file',
          foregroundServiceNotificationId: 777,
        ),
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: onStart,
          onBackground: onIosBackground,
        ),
      );
      
      print('[DownloadService] Service configuration completed');
    } catch (e) {
      print('[DownloadService] Error in service configuration: $e');
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
    print('[DownloadService] === BACKGROUND SERVICE STARTED ===');
    DartPluginRegistrant.ensureInitialized();
    print('[DownloadService] DartPluginRegistrant initialized');

    // Buat instance notification plugin untuk isolate ini
    final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();
    print('[DownloadService] NotificationsPlugin created');

    // CRITICAL: Tampilkan notifikasi segera untuk foreground service
    // Ini mencegah ForegroundServiceDidNotStartInTimeException
    try {
      await _showInitialNotification(notificationsPlugin);
      print('[DownloadService] Initial notification shown');
    } catch (e) {
      print('[DownloadService] Error showing initial notification: $e');
    }

    // Queue dan state management
    final List<DownloadItem> downloadQueue = [];
    final Map<String, Timer> activeTimers = {};
    final Random random = Random();
    int maxConcurrentDownloads = 3;
    int activeDownloads = 0;

    /// Helper untuk mengirim update ke UI
    void sendUpdate() {
      final updateData = {
        'downloads': downloadQueue.map((item) => item.toMap()).toList(),
        'activeCount': activeDownloads,
      };
      print('[DownloadService] Sending update to UI: ${downloadQueue.length} downloads, $activeDownloads active');
      service.invoke('downloadUpdate', updateData);
    }

    // Deklarasi function variables untuk menghindari forward reference
    late void Function() processNextInQueue;
    late void Function(DownloadItem) startDownloadSimulation;

    /// Proses download berikutnya dalam antrian
    processNextInQueue = () {
      print('[DownloadService] Processing next in queue - active: $activeDownloads, max: $maxConcurrentDownloads');
      
      if (activeDownloads >= maxConcurrentDownloads) {
        print('[DownloadService] Max concurrent downloads reached');
        return;
      }
      
      final nextItem = downloadQueue.firstWhere(
        (item) => item.status == DownloadStatus.pending,
        orElse: () => DownloadItem(id: '', fileName: '', url: '', totalBytes: 0),
      );
      
      if (nextItem.id.isNotEmpty) {
        print('[DownloadService] Starting download for: ${nextItem.fileName}');
        startDownloadSimulation(nextItem);
      } else {
        print('[DownloadService] No pending downloads in queue');
      }
    };

    /// Simulasi download dengan progress yang realistis
    startDownloadSimulation = (DownloadItem item) {
      if (activeDownloads >= maxConcurrentDownloads) return;
      
      activeDownloads++;
      final itemIndex = downloadQueue.indexWhere((d) => d.id == item.id);
      if (itemIndex == -1) return;

      // Update status ke downloading
      downloadQueue[itemIndex] = item.copyWith(
        status: DownloadStatus.downloading,
        startTime: DateTime.now(),
      );
      sendUpdate();

      // Simulasi kecepatan download (50KB - 500KB per detik)
      final bytesPerSecond = 50000 + random.nextInt(450000);
      final updateIntervalMs = 200; // Update setiap 200ms
      final bytesPerUpdate = (bytesPerSecond * updateIntervalMs / 1000).round();

      print('[DownloadService] Starting download simulation for ${item.fileName}');
      print('[DownloadService] Simulated speed: ${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s');

      activeTimers[item.id] = Timer.periodic(
        Duration(milliseconds: updateIntervalMs),
        (timer) async {
          final currentIndex = downloadQueue.indexWhere((d) => d.id == item.id);
          if (currentIndex == -1) {
            timer.cancel();
            activeTimers.remove(item.id);
            activeDownloads--;
            return;
          }

          final currentItem = downloadQueue[currentIndex];
          
          // Cek apakah masih downloading
          if (currentItem.status != DownloadStatus.downloading) {
            timer.cancel();
            activeTimers.remove(item.id);
            activeDownloads--;
            processNextInQueue();
            return;
          }

          // Update progress
          int newDownloaded = currentItem.downloadedBytes + bytesPerUpdate;
          
          // Simulasi variasi kecepatan (kadang lambat, kadang cepat)
          if (random.nextInt(10) < 2) { // 20% chance
            newDownloaded = currentItem.downloadedBytes + (bytesPerUpdate * 0.3).round();
          }

          if (newDownloaded >= currentItem.totalBytes) {
            // Download selesai
            newDownloaded = currentItem.totalBytes;
            downloadQueue[currentIndex] = currentItem.copyWith(
              downloadedBytes: newDownloaded,
              status: DownloadStatus.completed,
              endTime: DateTime.now(),
            );
            
            timer.cancel();
            activeTimers.remove(item.id);
            activeDownloads--;
            
            print('[DownloadService] Download completed: ${currentItem.fileName}');
            await _showCompletionNotification(notificationsPlugin, currentItem.fileName);
            
            sendUpdate();
            processNextInQueue();
          } else {
            // Update progress
            downloadQueue[currentIndex] = currentItem.copyWith(
              downloadedBytes: newDownloaded,
            );
            
            sendUpdate();
            await _updateProgressNotification(
              notificationsPlugin, 
              currentItem.fileName, 
              newDownloaded, 
              currentItem.totalBytes
            );
          }
        },
      );
    };

    // Event handlers
    service.on('addDownload').listen((event) {
      print('[DownloadService] Received addDownload event: $event');
      try {
        final data = event as Map<String, dynamic>;
        final item = DownloadItem.fromMap(data);
        
        downloadQueue.add(item);
        print('[DownloadService] Added to queue: ${item.fileName} (${item.id})');
        print('[DownloadService] Queue size: ${downloadQueue.length}');
        
        sendUpdate();
        print('[DownloadService] Sent update to UI');
        
        processNextInQueue();
        print('[DownloadService] Processed next in queue');
      } catch (e) {
        print('[DownloadService] Error in addDownload: $e');
      }
    });

    service.on('pauseDownload').listen((event) {
      final downloadId = event?['id'] as String?;
      if (downloadId == null) return;
      
      final index = downloadQueue.indexWhere((item) => item.id == downloadId);
      if (index != -1) {
        final item = downloadQueue[index];
        if (item.status == DownloadStatus.downloading) {
          downloadQueue[index] = item.copyWith(status: DownloadStatus.paused);
          activeTimers[downloadId]?.cancel();
          activeTimers.remove(downloadId);
          activeDownloads--;
          sendUpdate();
          processNextInQueue();
        }
      }
    });

    service.on('resumeDownload').listen((event) {
      final downloadId = event?['id'] as String?;
      if (downloadId == null) return;
      
      final index = downloadQueue.indexWhere((item) => item.id == downloadId);
      if (index != -1) {
        final item = downloadQueue[index];
        if (item.status == DownloadStatus.paused) {
          downloadQueue[index] = item.copyWith(status: DownloadStatus.pending);
          sendUpdate();
          processNextInQueue();
        }
      }
    });

    service.on('cancelDownload').listen((event) {
      final downloadId = event?['id'] as String?;
      if (downloadId == null) return;
      
      final index = downloadQueue.indexWhere((item) => item.id == downloadId);
      if (index != -1) {
        final item = downloadQueue[index];
        downloadQueue[index] = item.copyWith(status: DownloadStatus.cancelled);
        
        if (activeTimers.containsKey(downloadId)) {
          activeTimers[downloadId]?.cancel();
          activeTimers.remove(downloadId);
          activeDownloads--;
        }
        
        sendUpdate();
        processNextInQueue();
      }
    });

    service.on('clearCompleted').listen((event) {
      downloadQueue.removeWhere((item) => 
        item.status == DownloadStatus.completed || 
        item.status == DownloadStatus.cancelled
      );
      sendUpdate();
    });

    service.on('stopService').listen((event) {
      // Cancel semua timer
      for (final timer in activeTimers.values) {
        timer.cancel();
      }
      activeTimers.clear();
      service.stopSelf();
    });
    
    print('[DownloadService] === ALL EVENT HANDLERS SETUP COMPLETE ===');
    print('[DownloadService] Background service is ready to receive events');
    
    // Send heartbeat to confirm service is working
    Timer.periodic(const Duration(seconds: 5), (timer) {
      print('[DownloadService] Heartbeat - service is alive');
      service.invoke('heartbeat', {'timestamp': DateTime.now().millisecondsSinceEpoch});
    });
  }

  /// Tampilkan notifikasi awal
  @pragma('vm:entry-point')
  static Future<void> _showInitialNotification(
      FlutterLocalNotificationsPlugin plugin) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'download_service_channel',
      'Download Manager',
      channelDescription: 'Channel untuk download service notification',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await plugin.show(
      777,
      'Download Manager',
      'Siap mendownload file',
      notificationDetails,
    );
  }

  /// Update notification dengan progress bar
  @pragma('vm:entry-point')
  static Future<void> _updateProgressNotification(
    FlutterLocalNotificationsPlugin plugin,
    String fileName,
    int downloaded,
    int total,
  ) async {
    final progress = ((downloaded / total) * 100).round();
    
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'download_service_channel',
      'Download Manager',
      channelDescription: 'Channel untuk download service notification',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await plugin.show(
      777,
      'Downloading: $fileName',
      '$progress% • ${_formatBytes(downloaded)} / ${_formatBytes(total)}',
      notificationDetails,
    );
  }

  /// Tampilkan notification saat download selesai
  @pragma('vm:entry-point')
  static Future<void> _showCompletionNotification(
    FlutterLocalNotificationsPlugin plugin,
    String fileName,
  ) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'download_completion_channel',
      'Download Complete',
      channelDescription: 'Notifikasi saat download selesai',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await plugin.show(
      888 + DateTime.now().millisecond, // Unique ID
      'Download Selesai! 📁',
      fileName,
      notificationDetails,
    );
  }

  /// Helper format bytes
  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Inisialisasi notification plugin
  @pragma('vm:entry-point')
  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);

    // Buat channel untuk completion notification
    const AndroidNotificationChannel completionChannel = AndroidNotificationChannel(
      'download_completion_channel',
      'Download Complete',
      description: 'Notifikasi saat download selesai',
      importance: Importance.max,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(completionChannel);
  }

  // Public API methods
  @pragma('vm:entry-point')
  static Future<void> startService() async {
    print('[DownloadService] Starting background service...');
    final service = FlutterBackgroundService();
    try {
      await service.startService();
      print('[DownloadService] Service start command completed');
    } catch (e) {
      print('[DownloadService] Error starting service: $e');
      rethrow;
    }
  }

  @pragma('vm:entry-point')
  static Future<void> stopService() async {
    print('[DownloadService] Stopping background service...');
    final service = FlutterBackgroundService();
    try {
      service.invoke('stopService');
      print('[DownloadService] Service stop command sent');
    } catch (e) {
      print('[DownloadService] Error stopping service: $e');
    }
  }

  @pragma('vm:entry-point')
  static void addDownload(DownloadItem item) {
    print('[DownloadService] Static addDownload called for: ${item.fileName}');
    final service = FlutterBackgroundService();
    final itemMap = item.toMap();
    print('[DownloadService] Invoking addDownload with data: $itemMap');
    service.invoke('addDownload', itemMap);
  }

  @pragma('vm:entry-point')
  static void pauseDownload(String downloadId) {
    final service = FlutterBackgroundService();
    service.invoke('pauseDownload', {'id': downloadId});
  }

  @pragma('vm:entry-point')
  static void resumeDownload(String downloadId) {
    final service = FlutterBackgroundService();
    service.invoke('resumeDownload', {'id': downloadId});
  }

  @pragma('vm:entry-point')
  static void cancelDownload(String downloadId) {
    final service = FlutterBackgroundService();
    service.invoke('cancelDownload', {'id': downloadId});
  }

  @pragma('vm:entry-point')
  static void clearCompleted() {
    final service = FlutterBackgroundService();
    service.invoke('clearCompleted');
  }
}
