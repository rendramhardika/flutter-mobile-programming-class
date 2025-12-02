# 📝 Background Service Cheat Sheet

Quick reference guide untuk konsep-konsep penting dalam Flutter Background Service. Simpan ini sebagai referensi cepat saat development!

## 📚 Table of Contents

1. [Core Concepts](#core-concepts)
2. [Notification System](#notification-system)
3. [Service Lifecycle](#service-lifecycle)
4. [Android Configuration](#android-configuration)
5. [Common Patterns](#common-patterns)
6. [Common Pitfalls](#common-pitfalls)
7. [Performance Tips](#performance-tips)
8. [Debugging Commands](#debugging-commands)
9. [Quick Reference](#quick-reference)
10. [Interview Questions](#interview-questions)

---

## 🎯 Core Concepts

### 1. Background Service
```dart
// Service yang berjalan di isolate terpisah
@pragma('vm:entry-point')
static void onStart(ServiceInstance service) async {
  // Kode ini berjalan di background
  // Tidak terpengaruh UI lifecycle
}
```

**Kapan digunakan?**
- ✅ Long-running tasks (timer, music player, download)
- ✅ Periodic background work (sync, location tracking)
- ✅ Tasks yang harus tetap jalan saat app minimized
- ✅ Real-time updates (chat, notifications)
- ❌ Jangan untuk task yang bisa pakai WorkManager
- ❌ Jangan untuk one-time short tasks

**Contoh Use Cases:**
- 🎵 Music/Audio player
- 📥 File download manager
- 📍 Location tracking
- ⏱️ Timer/Stopwatch
- 💬 Real-time chat sync
- 🏋️ Fitness tracking

---

### 2. Foreground Service

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

<service
    android:name="id.flutter.flutter_background_service.BackgroundService"
    android:foregroundServiceType="dataSync" />
```

**Karakteristik**:
- 🔔 Menampilkan persistent notification
- 🛡️ Tidak mudah di-kill sistem
- 👁️ User aware ada proses berjalan
- ⚡ Higher priority dari background service

**Foreground Service Types** (Android 10+):
- `dataSync` - Data synchronization, file uploads/downloads
- `mediaPlayback` - Audio/video playback
- `location` - Location tracking, navigation
- `phoneCall` - VoIP calls
- `connectedDevice` - Bluetooth, NFC
- `mediaProjection` - Screen recording
- `camera` - Camera usage
- `microphone` - Audio recording

**Memilih Type yang Tepat:**
```xml
<!-- Timer/Download -->
android:foregroundServiceType="dataSync"

<!-- Music Player -->
android:foregroundServiceType="mediaPlayback"

<!-- GPS Tracker -->
android:foregroundServiceType="location"
```

---

### 3. Inter-Process Communication (IPC)

```dart
// UI → Service (send command)
service.invoke('start', {'duration': 1500});

// Service → UI (send update)
service.invoke('update', {'remaining': seconds});

// UI listen updates
service.on('update').listen((event) {
  final remaining = event?['remaining'];
  setState(() { ... });
});
```

**Pattern**:
```
┌────────┐  invoke('command')  ┌─────────┐
│   UI   │ ──────────────────> │ Service │
│ Thread │                     │ Isolate │
│        │ <────────────────── │         │
└────────┘  invoke('update')   └─────────┘
```

---

### 4. Isolate

```dart
// Main Isolate (UI Thread)
void main() {
  runApp(MyApp());  // UI code
}

// Background Isolate (Service)
@pragma('vm:entry-point')
static void onStart(ServiceInstance service) {
  // Background code - tidak bisa akses UI
}
```

**Key Points**:
- 🔀 Isolate = separate memory space
- 🚫 Tidak bisa akses variable dari isolate lain
- 📨 Komunikasi via message passing
- 🎯 Untuk CPU-intensive atau long-running tasks

---

### 5. State Persistence

```dart
import 'package:shared_preferences/shared_preferences.dart';

// Save state
final prefs = await SharedPreferences.getInstance();
await prefs.setInt('remaining_seconds', seconds);
await prefs.setBool('is_running', true);

// Load state
final remainingSeconds = prefs.getInt('remaining_seconds') ?? 0;
final isRunning = prefs.getBool('is_running') ?? false;

// Clear state
await prefs.remove('remaining_seconds');
```

**Use Cases:**
- 💾 Save timer state saat app killed
- 💾 Resume download progress
- 💾 Persist user preferences
- 💾 Track service status

---

## 📱 Notification System

### Setup Notification Channel
```dart
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'channel_id',           // Unique ID
  'Channel Name',         // User-visible name
  description: 'Desc',    // User-visible description
  importance: Importance.high,
);

await notificationsPlugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(channel);
```

### Show Notification
```dart
await notificationsPlugin.show(
  888,                    // Notification ID (same ID = update)
  'Title',                // Title
  'Content',              // Body
  NotificationDetails(
    android: AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,      // Persistent (tidak bisa di-dismiss)
    ),
  ),
);
```

### Notification Importance Levels

| Level | Behavior | Use Case |
|-------|----------|----------|
| `Importance.max` | Heads-up, sound, vibration | Urgent alerts, alarms |
| `Importance.high` | Sound, vibration | Timer complete, download done |
| `Importance.default` | Sound only | Regular notifications |
| `Importance.low` | No sound | Progress updates |
| `Importance.min` | No sound, minimal UI | Background sync |

### Notification Actions

```dart
final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  'channel_id',
  'Channel Name',
  actions: <AndroidNotificationAction>[
    AndroidNotificationAction(
      'pause',
      'Pause',
      icon: DrawableResourceAndroidBitmap('ic_pause'),
    ),
    AndroidNotificationAction(
      'stop',
      'Stop',
      icon: DrawableResourceAndroidBitmap('ic_stop'),
    ),
  ],
);
```

### Progress Notification

```dart
// Show progress bar
await notificationsPlugin.show(
  888,
  'Downloading...',
  '${progress}% complete',
  NotificationDetails(
    android: AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      channelShowBadge: false,
      importance: Importance.low,
      priority: Priority.low,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
    ),
  ),
);
```

---

## 🔧 Service Lifecycle

### Initialize
```dart
await FlutterBackgroundService().configure(
  androidConfiguration: AndroidConfiguration(
    onStart: onStart,           // Entry point
    autoStart: false,           // Manual start
    isForegroundMode: true,     // Foreground service
  ),
);
```

### Start Service
```dart
await FlutterBackgroundService().startService();
```

### Stop Service
```dart
FlutterBackgroundService().invoke('stopService');
// Or in service:
service.stopSelf();
```

### Check Status
```dart
final isRunning = await FlutterBackgroundService().isRunning();
```

---

## ⚙️ Android Configuration

### Minimum Requirements
```kotlin
// build.gradle.kts
defaultConfig {
    minSdk = 24  // Android 7.0+
}
```

### Required Permissions
```xml
<!-- AndroidManifest.xml -->

<!-- Wajib -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

<!-- Android 13+ -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<!-- Optional -->
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

---

## Common Patterns

### Pattern 1: Timer/Countdown

```dart
Timer? _timer;
int _remainingSeconds = 0;

void _startTimer(int duration) {
  _remainingSeconds = duration;
  
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    _remainingSeconds--;
    
    // Update UI
    service.invoke('update', {
      'remaining': _remainingSeconds,
      'progress': 1 - (_remainingSeconds / duration),
    });
    
    // Update notification
    _updateNotification(_remainingSeconds);
    
    // Check completion
    if (_remainingSeconds <= 0) {
      timer.cancel();
      _onTimerComplete();
    }
  });
}

void _pauseTimer() {
  _timer?.cancel();
  service.invoke('paused', {'remaining': _remainingSeconds});
}

void _resumeTimer() {
  _startTimer(_remainingSeconds);
}

void _stopTimer() {
  _timer?.cancel();
  _remainingSeconds = 0;
  service.invoke('stopped', {});
}
```

### Pattern 2: Download with Progress

```dart
import 'package:http/http.dart' as http;
import 'dart:io';

Future<void> _downloadFile(String url, String savePath) async {
  try {
    final request = http.Request('GET', Uri.parse(url));
    final response = await request.send();
    
    final contentLength = response.contentLength ?? 0;
    int downloadedBytes = 0;
    
    final file = File(savePath);
    final sink = file.openWrite();
    
    await response.stream.listen(
      (chunk) {
        sink.add(chunk);
        downloadedBytes += chunk.length;
        
        final progress = (downloadedBytes / contentLength * 100).toInt();
        
        // Update UI
        service.invoke('progress', {
          'downloaded': downloadedBytes,
          'total': contentLength,
          'progress': progress,
        });
        
        // Update notification
        _updateProgressNotification(progress);
      },
      onDone: () async {
        await sink.close();
        service.invoke('complete', {'path': savePath});
        _showCompletionNotification();
      },
      onError: (error) {
        service.invoke('error', {'message': error.toString()});
      },
    ).asFuture();
  } catch (e) {
    service.invoke('error', {'message': e.toString()});
  }
}
```

### Pattern 3: Periodic Sync

```dart
Timer? _syncTimer;

void _startPeriodicSync() {
  // Initial sync
  _performSync();
  
  // Periodic sync every 15 minutes
  _syncTimer = Timer.periodic(Duration(minutes: 15), (timer) async {
    await _performSync();
  });
}

Future<void> _performSync() async {
  try {
    service.invoke('syncStarted', {'timestamp': DateTime.now().toIso8601String()});
    
    // Perform sync operation
    final result = await _syncData();
    
    service.invoke('syncComplete', {
      'success': true,
      'itemsSynced': result.count,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    _updateNotification('Synced ${result.count} items');
  } catch (e) {
    service.invoke('syncError', {
      'error': e.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}

void _stopPeriodicSync() {
  _syncTimer?.cancel();
  _syncTimer = null;
}
```

### Pattern 4: Queue Management

```dart
import 'dart:collection';

class TaskQueue {
  final Queue<Task> _queue = Queue();
  bool _isProcessing = false;
  
  void addTask(Task task) {
    _queue.add(task);
    service.invoke('queueUpdated', {
      'count': _queue.length,
      'tasks': _queue.map((t) => t.toJson()).toList(),
    });
    
    if (!_isProcessing) {
      _processQueue();
    }
  }
  
  Future<void> _processQueue() async {
    if (_queue.isEmpty) {
      _isProcessing = false;
      return;
    }
    
    _isProcessing = true;
    final task = _queue.removeFirst();
    
    try {
      service.invoke('taskStarted', {'taskId': task.id});
      await task.execute();
      service.invoke('taskCompleted', {'taskId': task.id});
    } catch (e) {
      service.invoke('taskFailed', {
        'taskId': task.id,
        'error': e.toString(),
      });
    }
    
    // Process next task
    await _processQueue();
  }
  
  void cancelTask(String taskId) {
    _queue.removeWhere((task) => task.id == taskId);
    service.invoke('taskCancelled', {'taskId': taskId});
  }
}
```

### Pattern 5: State Machine

```dart
enum ServiceState {
  idle,
  starting,
  running,
  paused,
  stopping,
  stopped,
  error,
}

class StateMachine {
  ServiceState _currentState = ServiceState.idle;
  
  void transition(ServiceState newState) {
    final oldState = _currentState;
    
    // Validate transition
    if (!_isValidTransition(oldState, newState)) {
      throw StateError('Invalid transition: $oldState -> $newState');
    }
    
    _currentState = newState;
    
    // Notify state change
    service.invoke('stateChanged', {
      'oldState': oldState.name,
      'newState': newState.name,
    });
    
    // Handle state entry
    _onStateEnter(newState);
  }
  
  bool _isValidTransition(ServiceState from, ServiceState to) {
    // Define valid transitions
    final validTransitions = {
      ServiceState.idle: [ServiceState.starting],
      ServiceState.starting: [ServiceState.running, ServiceState.error],
      ServiceState.running: [ServiceState.paused, ServiceState.stopping],
      ServiceState.paused: [ServiceState.running, ServiceState.stopping],
      ServiceState.stopping: [ServiceState.stopped],
      ServiceState.stopped: [ServiceState.idle],
      ServiceState.error: [ServiceState.idle],
    };
    
    return validTransitions[from]?.contains(to) ?? false;
  }
  
  void _onStateEnter(ServiceState state) {
    switch (state) {
      case ServiceState.running:
        _startTimer();
        break;
      case ServiceState.paused:
        _pauseTimer();
        break;
      case ServiceState.stopped:
        _cleanup();
        break;
      default:
        break;
    }
  }
}
```

---

## 🛠️ Advanced Patterns

### Pattern 1: Retry Logic

```dart
Future<T> retryOperation<T>(
  Future<T> Function() operation, {
  int maxAttempts = 3,
  Duration delay = const Duration(seconds: 2),
}) async {
  int attempt = 0;
  
  while (attempt < maxAttempts) {
    try {
      return await operation();
    } catch (e) {
      attempt++;
      
      if (attempt >= maxAttempts) {
        rethrow;
      }
      
      service.invoke('retrying', {
        'attempt': attempt,
        'maxAttempts': maxAttempts,
        'error': e.toString(),
      });
      
      await Future.delayed(delay * attempt); // Exponential backoff
    }
  }
  
  throw Exception('Max retry attempts reached');
}

// Usage
await retryOperation(
  () => downloadFile(url),
  maxAttempts: 5,
  delay: Duration(seconds: 3),
);
```

### Pattern 2: Cancellation Token

```dart
class CancellationToken {
  bool _isCancelled = false;
  
  bool get isCancelled => _isCancelled;
  
  void cancel() {
    _isCancelled = true;
  }
  
  void throwIfCancelled() {
    if (_isCancelled) {
      throw CancelledException();
    }
  }
}

class CancelledException implements Exception {}

// Usage
final token = CancellationToken();

Future<void> longRunningTask(CancellationToken token) async {
  for (int i = 0; i < 1000; i++) {
    token.throwIfCancelled(); // Check cancellation
    
    await Future.delayed(Duration(milliseconds: 100));
    // Do work...
  }
}

// Cancel from UI
service.invoke('cancel', {});

// Handle in service
service.on('cancel').listen((_) {
  token.cancel();
});
```

### Pattern 3: Resource Management

```dart
class ResourceManager {
  final List<Closeable> _resources = [];
  
  T register<T extends Closeable>(T resource) {
    _resources.add(resource);
    return resource;
  }
  
  Future<void> dispose() async {
    for (final resource in _resources.reversed) {
      try {
        await resource.close();
      } catch (e) {
        print('Error closing resource: $e');
      }
    }
    _resources.clear();
  }
}

abstract class Closeable {
  Future<void> close();
}

// Usage
final resourceManager = ResourceManager();

final timer = resourceManager.register(MyTimer());
final file = resourceManager.register(MyFile());

// Cleanup all resources
await resourceManager.dispose();
```

---

## 🐛 Common Pitfalls

### ❌ Pitfall 1: Accessing UI from Service
```dart
// WRONG - akan error!
@pragma('vm:entry-point')
static void onStart(ServiceInstance service) {
  setState(() { ... });  // ❌ Tidak bisa akses UI
}

// CORRECT
@pragma('vm:entry-point')
static void onStart(ServiceInstance service) {
  service.invoke('update', {'data': value});  // ✅ Send message
}
```

### ❌ Pitfall 2: Lupa Permission
```dart
// App crash saat start service
// Solution: Tambahkan permission di AndroidManifest.xml
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

### ❌ Pitfall 3: Notification Channel Tidak Dibuat
```dart
// Notification tidak muncul
// Solution: Buat channel sebelum show notification
await _notificationsPlugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(channel);
```

### ❌ Pitfall 4: Service Tidak Stop
```dart
// Service tetap jalan setelah app closed
// Solution: Stop service di dispose atau saat tidak diperlukan
service.invoke('stopService');
```

### ❌ Pitfall 5: Memory Leaks
```dart
// WRONG - listener tidak di-dispose
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    super.initState();
    service.on('update').listen((event) { ... });  // ❌ Memory leak!
  }
}

// CORRECT - dispose listener
class _MyScreenState extends State<MyScreen> {
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = service.on('update').listen((event) { ... });
  }
  
  @override
  void dispose() {
    _subscription?.cancel();  // ✅ Clean up
    super.dispose();
  }
}
```

### ❌ Pitfall 6: Race Conditions
```dart
// WRONG - race condition
bool _isProcessing = false;

void processTask() async {
  if (_isProcessing) return;
  _isProcessing = true;
  
  await heavyOperation();  // ❌ Another call bisa masuk sebelum ini selesai
  
  _isProcessing = false;
}

// CORRECT - use lock
import 'package:synchronized/synchronized.dart';

final _lock = Lock();

void processTask() async {
  await _lock.synchronized(() async {
    await heavyOperation();  // ✅ Only one at a time
  });
}
```

---

## 📊 Performance Tips

### 1. Battery Optimization

```dart
// ✅ GOOD - Reasonable intervals
Timer.periodic(Duration(seconds: 1), ...);     // OK untuk timer
Timer.periodic(Duration(minutes: 15), ...);    // OK untuk sync

// ❌ BAD - Too frequent
Timer.periodic(Duration(milliseconds: 100), ...);  // Battery drain!
Timer.periodic(Duration(milliseconds: 16), ...);   // 60 FPS - overkill!

// ✅ GOOD - Adaptive intervals
Timer.periodic(
  _isInForeground ? Duration(seconds: 1) : Duration(seconds: 5),
  ...
);
```

### 2. Wake Lock Management

```dart
// ❌ BAD - Always keep awake
<uses-permission android:name="android.permission.WAKE_LOCK" />
// Device tidak sleep, battery drain!

// ✅ GOOD - Conditional wake lock
import 'package:wakelock/wakelock.dart';

// Enable only when needed
await Wakelock.enable();
await performCriticalTask();
await Wakelock.disable();

// Or use timeout
await Wakelock.enable();
Timer(Duration(minutes: 5), () {
  Wakelock.disable();
});
```

### 3. Notification Updates

```dart
// ✅ GOOD - Update existing notification
const notificationId = 888;
await notificationsPlugin.show(notificationId, ...);  // Same ID = update

// ❌ BAD - Create new notification every time
await notificationsPlugin.show(
  Random().nextInt(1000),  // Different ID each time
  ...
);  // Creates spam!

// ✅ GOOD - Batch updates
int _updateCount = 0;
Timer.periodic(Duration(seconds: 1), (timer) {
  _updateCount++;
  
  // Only update notification every 5 seconds
  if (_updateCount % 5 == 0) {
    _updateNotification();
  }
});
```

### 4. Memory Management

```dart
// ✅ GOOD - Limit cache size
class DownloadCache {
  final _cache = <String, Uint8List>{};
  final maxSize = 50 * 1024 * 1024; // 50 MB
  int _currentSize = 0;
  
  void add(String key, Uint8List data) {
    if (_currentSize + data.length > maxSize) {
      _evictOldest();
    }
    _cache[key] = data;
    _currentSize += data.length;
  }
  
  void _evictOldest() {
    if (_cache.isEmpty) return;
    final oldestKey = _cache.keys.first;
    final data = _cache.remove(oldestKey)!;
    _currentSize -= data.length;
  }
}

// ❌ BAD - Unbounded cache
final _cache = <String, Uint8List>{};  // Can grow indefinitely!
```

### 5. Network Optimization

```dart
// ✅ GOOD - Use connection pooling
final client = http.Client();  // Reuse client

try {
  final response1 = await client.get(Uri.parse(url1));
  final response2 = await client.get(Uri.parse(url2));
} finally {
  client.close();  // Close when done
}

// ❌ BAD - Create new client each time
final response1 = await http.get(Uri.parse(url1));  // New connection
final response2 = await http.get(Uri.parse(url2));  // New connection

// ✅ GOOD - Compress data
import 'dart:io';

final compressed = gzip.encode(data);
await file.writeAsBytes(compressed);

// ✅ GOOD - Use appropriate timeout
final response = await http.get(url).timeout(
  Duration(seconds: 30),
  onTimeout: () => throw TimeoutException('Request timeout'),
);
```

---

## 🧑‍💻 Best Practices Summary

### DO ✅

1. **Use Foreground Service** untuk long-running tasks
2. **Show Persistent Notification** untuk foreground service
3. **Save State Periodically** dengan SharedPreferences
4. **Handle Service Restart** dengan graceful recovery
5. **Dispose Listeners** di dispose() method
6. **Use Reasonable Intervals** untuk battery optimization
7. **Validate Transitions** dalam state machine
8. **Implement Retry Logic** untuk network operations
9. **Test on Real Device** untuk accurate behavior
10. **Monitor Memory Usage** dan implement limits

### DON'T ❌

1. **Don't Access UI** dari service isolate
2. **Don't Use Background Service** untuk short tasks
3. **Don't Create Notification Spam** dengan different IDs
4. **Don't Keep Wake Lock** unnecessarily
5. **Don't Ignore Battery Optimization** settings
6. **Don't Forget to Stop Service** saat tidak diperlukan
7. **Don't Use Too Frequent Updates** (< 1 second)
8. **Don't Store Large Data** in memory
9. **Don't Ignore Error Handling** dalam async operations
10. **Don't Test Only on Emulator** - use real devices

---

## 🔍 Debugging Commands

### Flutter Logs
```bash
# Monitor all logs
flutter logs

# Filter logs
flutter logs | grep "Timer"
flutter logs | grep "Service"

# Clear logs
flutter logs --clear
```

### Android Logs
```bash
# All logs
adb logcat

# Filter by tag
adb logcat -s "flutter"

# Filter by package
adb logcat | grep "com.example.service"
```

### Check Running Services
```bash
# List all services
adb shell dumpsys activity services

# Check specific service
adb shell dumpsys activity services | grep "BackgroundService"

# Check service memory usage
adb shell dumpsys meminfo <package_name>

# Check battery stats
adb shell dumpsys batterystats <package_name>
```

### Monitor Notifications
```bash
# List notification channels
adb shell cmd notification list_channels <package_name>

# Check notification settings
adb shell dumpsys notification
```

### Performance Profiling
```bash
# CPU profiling
adb shell am profile start <package_name> /sdcard/profile.trace
adb shell am profile stop <package_name>
adb pull /sdcard/profile.trace

# Memory snapshot
adb shell am dumpheap <package_name> /sdcard/heap.hprof
adb pull /sdcard/heap.hprof
```

---

## 📚 Quick Reference

### Service States
- **Not Started** - Service belum diinisialisasi
- **Starting** - Service sedang start
- **Running** - Service aktif di background
- **Stopping** - Service sedang stop
- **Stopped** - Service sudah stop

### Notification Priority
- **Max** - Heads-up notification
- **High** - Sound + vibration
- **Default** - Sound only
- **Low** - Silent
- **Min** - Minimal UI

### Permission Types
- **Normal** - Auto-granted
- **Dangerous** - Requires user approval
- **Special** - System settings

---

## 🎓 Interview Questions

### Basic Level

**Q1: Apa perbedaan background service dan foreground service?**

**A:** 
- **Foreground Service**: Menampilkan persistent notification, tidak mudah di-kill sistem, higher priority, user aware
- **Background Service**: Bisa di-kill kapan saja, no notification required, lower priority, user tidak aware

**Q2: Mengapa perlu isolate untuk background service?**

**A:** 
- Agar tidak memblokir UI thread
- Tetap jalan meskipun UI di-destroy
- Isolasi memory untuk stability
- Parallel execution untuk performance

**Q3: Bagaimana cara komunikasi antara UI dan service?**

**A:** Menggunakan message passing:
- UI → Service: `service.invoke('command', data)`
- Service → UI: `service.invoke('event', data)`
- UI listen: `service.on('event').listen((data) { ... })`

### Intermediate Level

**Q4: Kapan sebaiknya menggunakan background service vs WorkManager?**

**A:**
- **Background Service**: Long-running tasks (music player, timer, real-time tracking)
- **WorkManager**: One-time atau periodic short tasks (sync, upload, cleanup)

**Q5: Apa yang terjadi jika user force-close app?**

**A:** 
- Service akan di-stop karena process di-kill
- Foreground service lebih resistant tapi tetap bisa di-kill
- Perlu implement restart mechanism jika critical
- Save state sebelum stop untuk recovery

**Q6: Bagaimana handle battery optimization?**

**A:**
- Gunakan foreground service untuk critical tasks
- Request battery optimization exemption
- Use reasonable update intervals
- Implement adaptive behavior (slower updates saat background)
- Monitor battery level dan adjust accordingly

### Advanced Level

**Q7: Bagaimana implement graceful service restart?**

**A:**
```dart
// Save state periodically
await prefs.setInt('remaining_seconds', _remaining);
await prefs.setBool('was_running', _isRunning);

// Restore on restart
final wasRunning = prefs.getBool('was_running') ?? false;
if (wasRunning) {
  final remaining = prefs.getInt('remaining_seconds') ?? 0;
  if (remaining > 0) {
    _startTimer(remaining);
  }
}
```

**Q8: Bagaimana handle race conditions di service?**

**A:**
- Use locks (`synchronized` package)
- Implement state machine dengan validation
- Use atomic operations
- Queue commands untuk sequential processing

**Q9: Apa strategi untuk optimize memory usage?**

**A:**
- Limit cache size dengan LRU eviction
- Stream large files instead of loading to memory
- Dispose resources properly (timers, streams, files)
- Monitor memory usage dan implement thresholds
- Use weak references untuk non-critical data

**Q10: Bagaimana implement retry logic dengan exponential backoff?**

**A:**
```dart
Future<T> retryWithBackoff<T>(
  Future<T> Function() operation, {
  int maxAttempts = 5,
  Duration initialDelay = const Duration(seconds: 1),
}) async {
  int attempt = 0;
  
  while (attempt < maxAttempts) {
    try {
      return await operation();
    } catch (e) {
      attempt++;
      if (attempt >= maxAttempts) rethrow;
      
      // Exponential backoff: 1s, 2s, 4s, 8s, 16s
      final delay = initialDelay * math.pow(2, attempt - 1);
      await Future.delayed(delay);
    }
  }
  throw Exception('Unreachable');
}
```

---

## 🔗 Useful Links

- [flutter_background_service](https://pub.dev/packages/flutter_background_service)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [Android Background Execution](https://developer.android.com/about/versions/oreo/background)
- [Isolates in Dart](https://dart.dev/guides/language/concurrency)

---

## 📝 Quick Code Snippets

### Complete Service Setup

```dart
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'my_channel',
      initialNotificationTitle: 'Service Running',
      initialNotificationContent: 'Tap to open',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
static void onStart(ServiceInstance service) async {
  // Initialize notifications
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // Setup notification channel
  const channel = AndroidNotificationChannel(
    'my_channel',
    'My Channel',
    importance: Importance.high,
  );
  
  await notificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  
  // Listen to commands
  service.on('start').listen((event) {
    // Handle start
  });
  
  service.on('stop').listen((event) {
    service.stopSelf();
  });
  
  // Periodic updates
  Timer.periodic(Duration(seconds: 1), (timer) {
    service.invoke('update', {'timestamp': DateTime.now().toIso8601String()});
  });
}

@pragma('vm:entry-point')
static Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}
```

### Complete UI Integration

```dart
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final service = FlutterBackgroundService();
  StreamSubscription? _subscription;
  String _status = 'Idle';
  
  @override
  void initState() {
    super.initState();
    _setupListener();
  }
  
  void _setupListener() {
    _subscription = service.on('update').listen((event) {
      if (mounted) {
        setState(() {
          _status = event?['timestamp'] ?? 'Unknown';
        });
      }
    });
  }
  
  Future<void> _startService() async {
    final isRunning = await service.isRunning();
    if (!isRunning) {
      await service.startService();
    }
    service.invoke('start', {});
  }
  
  void _stopService() {
    service.invoke('stop', {});
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Service Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Status: $_status'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startService,
              child: Text('Start Service'),
            ),
            ElevatedButton(
              onPressed: _stopService,
              child: Text('Stop Service'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

**📌 Keep this handy during development!**

**🚀 Happy Coding!**
