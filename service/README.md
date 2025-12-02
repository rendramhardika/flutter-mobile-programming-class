# � Flutter Background Service Demo

Aplikasi Flutter untuk pembelajaran **Background Service** di mobile development dengan 2 demo lengkap: **Pomodoro Timer** dan **Download Manager** yang berjalan di background.

## 🎯 Tujuan Pembelajaran

Aplikasi ini mendemonstrasikan konsep-konsep penting dalam mobile development:

- ✅ **Background Service** - Service yang berjalan di isolate terpisah
- ✅ **Foreground Service** - Service dengan persistent notification
- ✅ **Inter-Process Communication** - Komunikasi antara UI dan service
- ✅ **Local Notifications** - Notifikasi lokal dengan update real-time
- ✅ **State Management** - Sinkronisasi state antara UI dan background

## 🚀 Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run Aplikasi
```bash
flutter run
```

### 3. Test Background Service
1. Start timer dengan menekan tombol "Start"
2. **Minimize aplikasi** - timer tetap berjalan!
3. Cek notification bar untuk melihat countdown
4. Buka kembali app - timer masih sync

## 📱 Fitur

### 🕐 Demo 1: Pomodoro Timer

**Timer Presets:**
- **Pomodoro**: 25 menit (teknik produktivitas)
- **Short Break**: 5 menit
- **Long Break**: 15 menit  
- **Custom 1 Min**: 1 menit (untuk testing cepat)

**Kontrol:**
- ▶️ Start/Pause timer
- 🔄 Reset timer
- 📊 Real-time countdown display
- 🔔 Notification updates setiap detik
- ⏰ Alert notification saat timer selesai
- 🎯 Timer tetap berjalan saat app di-minimize

**Konsep yang Dipelajari:**
- Timer.periodic untuk countdown
- Foreground service dengan notification
- Inter-process communication (IPC)
- State synchronization UI ↔ Service

### 📥 Demo 2: Download Manager

**Fitur Download:**
- 📦 Multiple file downloads
- 📊 Progress tracking real-time
- 🔔 Notification dengan progress bar
- ⏸️ Pause/Resume downloads
- ❌ Cancel downloads
- 📋 Download queue management
- ✅ Success/Error handling

**Sample Files:**
- Small file (1MB) - Quick test
- Medium file (10MB) - Normal download
- Large file (50MB) - Long running test
- Custom URL - Test dengan URL sendiri

**Konsep yang Dipelajari:**
- Background download dengan http
- Progress notification updates
- Queue management
- File I/O operations
- Error handling & retry logic

## 🏗️ Struktur Project

```
lib/
├── main.dart                      # Entry point aplikasi
├── models/
│   └── download_item.dart         # Model untuk download item
├── screens/
│   ├── home_screen.dart           # Home dengan navigation ke demos
│   ├── timer_screen.dart          # UI untuk Pomodoro Timer
│   └── download_screen.dart       # UI untuk Download Manager
└── services/
    ├── timer_service.dart         # Background service untuk timer
    └── download_service.dart      # Background service untuk download

android/
└── app/src/main/
    └── AndroidManifest.xml        # Permissions & service config
```

## 📚 Dokumentasi Lengkap

- **[CHEAT_SHEET.md](CHEAT_SHEET.md)** - Quick reference untuk konsep background service
  - Core concepts (Background Service, Foreground Service, IPC, Isolate)
  - Notification system
  - Service lifecycle
  - Common patterns & pitfalls
  - Performance tips
  - Debugging commands

## 🔑 Konsep Utama

### 1. Background Service

Service berjalan di **isolate terpisah** dari UI thread:

```dart
@pragma('vm:entry-point')
static void onStart(ServiceInstance service) async {
  // Kode ini berjalan di isolate terpisah
  // Tidak terpengaruh UI lifecycle
  Timer.periodic(Duration(seconds: 1), (timer) {
    // Update timer setiap detik
    service.invoke('update', {'remaining': seconds});
  });
}
```

**Karakteristik:**
- ✅ Berjalan di isolate terpisah
- ✅ Tidak memblokir UI thread
- ✅ Tetap jalan saat app di-minimize
- ❌ Tidak bisa akses UI langsung

### 2. Foreground Service

Service dengan **persistent notification**:

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

<service
    android:name="id.flutter.flutter_background_service.BackgroundService"
    android:foregroundServiceType="dataSync" />
```

**Keuntungan:**
- 🛡️ Tidak mudah di-kill sistem
- 👁️ User aware ada proses berjalan
- ⚡ Higher priority

### 3. Inter-Process Communication (IPC)

Komunikasi antara UI dan Service:

```dart
// UI → Service (send command)
service.invoke('start', {'duration': 1500});

// Service → UI (send update)
service.invoke('update', {'remaining': seconds});

// UI listen updates
service.on('update').listen((event) {
  setState(() {
    _remainingSeconds = event?['remaining'];
  });
});
```

**Pattern:**
```
┌────────┐  invoke('command')  ┌─────────┐
│   UI   │ ──────────────────> │ Service │
│ Thread │                     │ Isolate │
│        │ <────────────────── │         │
└────────┘  invoke('update')   └─────────┘
```

### 4. Local Notifications

Notifikasi dengan update real-time:

```dart
// Create notification channel
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'timer_channel',
  'Timer Notifications',
  importance: Importance.high,
);

// Show/update notification
await notificationsPlugin.show(
  888,  // Same ID = update existing
  'Timer Running',
  '15:30 remaining',
  NotificationDetails(
    android: AndroidNotificationDetails(
      channel.id,
      channel.name,
      ongoing: true,  // Persistent
    ),
  ),
);
```

## 📦 Dependencies

```yaml
dependencies:
  flutter_background_service: ^5.0.10  # Background service core
  flutter_local_notifications: ^17.2.3 # Local notifications
  shared_preferences: ^2.3.2           # State persistence
```

**Package Details:**
- **flutter_background_service** - Menjalankan Dart code di background isolate
- **flutter_local_notifications** - Menampilkan dan update notifications
- **shared_preferences** - Menyimpan state timer/download

## ⚙️ Requirements

### Flutter & Dart
- Flutter SDK: ^3.9.0 atau lebih tinggi
- Dart SDK: ^3.9.0 atau lebih tinggi

### Android
- **minSdk**: 24 (Android 7.0 Nougat)
- **targetSdk**: 34 (Android 14)
- **compileSdk**: 34

### Permissions Required

```xml
<!-- Wajib -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

<!-- Android 13+ -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<!-- Optional -->
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### Testing
- ✅ **Real device** sangat direkomendasikan
- ⚠️ Emulator mungkin memiliki behavior berbeda
- 📱 Test di berbagai Android versions (7.0 - 14)

## 🎓 Untuk Pengajar

Aplikasi ini cocok untuk:

### Materi Pembelajaran
- ✅ **Background Service** - Konsep dan implementasi
- ✅ **Foreground Service** - Perbedaan dengan background service
- ✅ **Isolate & Concurrency** - Multi-threading di Dart
- ✅ **IPC** - Inter-process communication
- ✅ **Notifications** - Local notification system
- ✅ **State Management** - Sync state antara UI dan service

### Skenario Penggunaan
- 📊 Demo live coding dengan 2 contoh real-world
- 🧪 Hands-on lab untuk mahasiswa
- 💬 Diskusi tentang mobile architecture patterns
- 🔄 Perbandingan dengan platform native (Android/iOS)
- 📝 Assignment untuk implementasi custom service

### Learning Outcomes
Setelah mempelajari project ini, mahasiswa dapat:
1. Memahami konsep background service di mobile
2. Mengimplementasikan foreground service dengan notification
3. Melakukan komunikasi antara UI dan background service
4. Mengelola state dan lifecycle service
5. Handle edge cases (app killed, battery optimization, etc.)

## 📝 Important Notes

### Testing
- ⚠️ **Wajib test di real device** untuk hasil akurat
- 📱 Emulator memiliki keterbatasan untuk background service
- 🔋 Test dengan berbagai kondisi battery optimization

### Behavior
- ✅ Service tetap jalan saat app di-minimize
- ✅ Notification update real-time
- ❌ Force-close akan stop service (expected)
- ❌ Battery saver mode mungkin kill service

### Best Practices
- 🎯 Gunakan foreground service untuk long-running tasks
- 🔔 Selalu tampilkan notification untuk foreground service
- 💾 Save state secara periodik
- 🔄 Handle service restart dengan graceful
- ⚡ Optimize battery usage dengan interval yang reasonable

## � Troubleshooting

### Service tidak start?

**Solusi:**
1. Check permissions di `AndroidManifest.xml`
   ```xml
   <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
   ```
2. Pastikan `minSdk >= 24` di `build.gradle`
3. Restart app setelah perubahan native code
4. Clean dan rebuild project:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Notification tidak muncul?

**Solusi:**
1. Request notification permission (Android 13+):
   ```dart
   await Permission.notification.request();
   ```
2. Check notification settings di device
3. Pastikan notification channel sudah dibuat
4. Verify channel importance level

### Service di-kill oleh sistem?

**Solusi:**
1. Gunakan foreground service (bukan background)
2. Set `isForegroundMode: true` di configuration
3. Disable battery optimization untuk app:
   - Settings → Apps → Your App → Battery → Unrestricted
4. Test di device dengan Android version berbeda

### App crash saat start service?

**Solusi:**
1. Check logcat untuk error message:
   ```bash
   flutter logs
   adb logcat | grep "flutter"
   ```
2. Pastikan semua dependencies sudah di-install
3. Verify `@pragma('vm:entry-point')` ada di service entry point
4. Check untuk null safety issues

### Download tidak berjalan?

**Solusi:**
1. Check internet permission:
   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   ```
2. Verify URL valid dan accessible
3. Check storage permission untuk save file
4. Test dengan file size yang lebih kecil dulu

### UI tidak update dari service?

**Solusi:**
1. Verify listener setup dengan benar:
   ```dart
   service.on('update').listen((event) { ... });
   ```
2. Check service invoke dengan key yang sama
3. Pastikan setState() dipanggil di listener
4. Debug dengan print statement di service dan UI

## 🎯 Latihan Tambahan

Untuk memperdalam pemahaman, coba implementasi:

1. **Music Player Service**
   - Play/pause/stop controls
   - Progress bar di notification
   - Playlist management

2. **Location Tracker**
   - Background location updates
   - Geofencing
   - Location history

3. **Chat Sync Service**
   - Background message sync
   - Push notification
   - Unread count badge

4. **Fitness Tracker**
   - Step counter
   - Calorie tracking
   - Daily goals notification

## 🔗 Resources

### Official Documentation
- [flutter_background_service](https://pub.dev/packages/flutter_background_service)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [Android Background Execution](https://developer.android.com/about/versions/oreo/background)
- [Isolates in Dart](https://dart.dev/guides/language/concurrency)

### Related Files
- [CHEAT_SHEET.md](CHEAT_SHEET.md) - Quick reference guide

## 🤝 Contributing

Contributions are welcome! Silakan:
1. Fork repository ini
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

MIT License - Free to use untuk pembelajaran dan development.

## 👨‍💻 Author

Project ini dibuat untuk keperluan pembelajaran Flutter Mobile Programming.

---

**Happy Learning! 🚀**

Mulai dengan demo Timer atau Download Manager untuk memahami konsep background service!
