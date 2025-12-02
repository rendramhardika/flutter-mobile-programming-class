# 🚀 Flutter Mobile Programming Class

Repositori ini berisi kumpulan proyek Flutter yang dibuat sebagai bagian dari kelas pemrograman mobile. Setiap subfolder mewakili proyek Flutter terpisah yang fokus pada konsep dan aplikasi yang berbeda.

## 📁 Struktur Repositori

- `dart_prog/` - Contoh dan latihan pemrograman Dart
- `uiux/` - Demonstrasi prinsip dan pola UI/UX dalam pengembangan aplikasi mobile
  - Prinsip Desain Visual
  - Panduan Platform (Android/iOS)
  - Pola Navigasi Mobile
  - Microinteractions & Feedback
  - Aksesibilitas & Desain Inklusif
  - Gamifikasi
- `layoutmobile/` - Koleksi contoh tata letak dan pola UI Flutter
  - Tata Letak Dasar
  - Transisi dan Animasi
  - Daftar & Grid
  - Tata Letak Kanonik
  - RecyclerView
  - Timeline Instagram
- `formflutter/` - Aplikasi manajemen tugas dengan form yang lengkap
  - Autentikasi pengguna
  - CRUD tugas
  - Validasi form
  - Notifikasi interaktif
  - Tema gelap/terang
- `permission/` - Demonstrasi lengkap permission handling dengan UX best practices
  - 7 jenis permissions (Camera, Microphone, Location, Photos, Contacts, Notifications, Calendar)
  - Permission Rationale Dialog
  - Real-time status indicators
  - Settings redirect untuk permanently denied
  - Service layer architecture
- `service/` - Background Service demo dengan 2 implementasi lengkap
  - Pomodoro Timer dengan countdown di background
  - Download Manager dengan progress tracking
  - Foreground Service dengan persistent notification
  - Inter-Process Communication (IPC)
  - State persistence dan recovery

## 🛠️ Persyaratan Sistem

- Flutter SDK (versi terbaru direkomendasikan)
- Dart SDK (versi 3.9.0 atau lebih tinggi)
- Android Studio atau VS Code dengan ekstensi Flutter
- Emulator atau perangkat fisik Android/iOS untuk pengujian
- Git (untuk mengelola versi kode)

## 🚀 Memulai

1. Pastikan Flutter sudah terinstall di sistem Anda. Jika belum, ikuti [panduan instalasi resmi](https://docs.flutter.dev/get-started/install).
2. Clone repositori ini:
   ```bash
   git clone https://github.com/rendramhardika/flutter-mobile-programming-class.git
   ```
3. Masuk ke direktori proyek yang diinginkan, contoh:
   ```bash
   cd uiux
   ```
4. Dapatkan dependencies yang dibutuhkan:
   ```bash
   flutter pub get
   ```
5. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## 📚 Proyek yang Tersedia

### 🎨 UI/UX Demo (`uiux/`)
Aplikasi demonstrasi yang menampilkan berbagai prinsip dan pola UI/UX dalam pengembangan aplikasi mobile.

**Fitur Utama:**
- Prinsip Desain Visual
- Panduan Platform (Android/iOS)
- Pola Navigasi Mobile
- Microinteractions & Feedback
- Aksesibilitas & Desain Inklusif
- Gamifikasi

### ➗ Dart Programming (`dart_prog/`)
Kumpulan contoh dan latihan pemrograman dasar Dart.

**Topik yang Dicakup:**
- Dasar-dasar sintaks Dart
- Control flow dan fungsi
- OOP dalam Dart
- Collection dan null safety
- Asynchronous programming

### 🖼️ Flutter Layout Examples (`layoutmobile/`)
Koleksi komprehensif contoh tata letak Flutter dan pola UI.

**Fitur Utama:**
- Implementasi widget tata letak dasar (Row, Column, Stack, dll.)
- Animasi transisi dan perubahan tata letak
- Daftar, grid, dan tampilan yang dapat di-scroll
- Pola tata letak umum (canonical layouts)
- Optimasi performa untuk daftar panjang
- Contoh dunia nyata (Instagram timeline)

### 📋 Form Flutter (`formflutter/`)
Aplikasi manajemen tugas dengan implementasi form yang lengkap.

**Fitur Utama:**
- Sistem autentikasi dengan validasi
- Manajemen tugas (tambah, edit, hapah, tandai selesai)
- Validasi form yang kuat
- Notifikasi interaktif dengan SweetAlert
- Tampilan responsif dengan tema gelap/terang
- Progress tracking untuk setiap tugas

### 🔐 Permission Demo (`permission/`)
Aplikasi demonstrasi implementasi permission handling dengan UX best practices menggunakan `permission_handler` package.

**Fitur Utama:**
- **7 Jenis Permissions**: Camera, Microphone, Location, Photos, Contacts, Notifications, Calendar
- **Permission Rationale Dialog**: Dialog yang menjelaskan mengapa permission diperlukan sebelum request
- **Visual Status Indicators**: Badge dengan color coding untuk setiap permission state
- **Settings Redirect**: Automatic redirect ke app settings untuk permanently denied permissions
- **Service Layer Architecture**: Clean architecture dengan separation of concerns
- **Real-time Updates**: Status permission update otomatis setelah user action
- **Platform Support**: Konfigurasi lengkap untuk Android dan iOS

**Teknologi:**
- `permission_handler: ^11.3.1` - Runtime permission handling
- Custom rationale dialog dengan Material Design
- Reusable permission service dan widgets

### 🔄 Background Service Demo (`service/`)
Aplikasi demonstrasi background service di Flutter dengan 2 demo lengkap: Pomodoro Timer dan Download Manager.

**Demo 1: Pomodoro Timer**
- ⏱️ Timer presets (Pomodoro, Short Break, Long Break, Custom)
- ▶️ Start/Pause/Reset controls
- 🔔 Real-time notification updates
- 🎯 Timer tetap berjalan saat app di-minimize
- ⏰ Alert notification saat timer selesai

**Demo 2: Download Manager**
- 📥 Multiple file downloads dengan queue management
- 📊 Progress tracking real-time di notification
- ⏸️ Pause/Resume/Cancel downloads
- 📦 Sample files (1MB, 10MB, 50MB)
- ✅ Success/Error handling dengan retry logic

**Konsep yang Dipelajari:**
- **Background Service**: Service yang berjalan di isolate terpisah
- **Foreground Service**: Service dengan persistent notification
- **Inter-Process Communication (IPC)**: Komunikasi antara UI dan service
- **Local Notifications**: Notifikasi dengan update real-time
- **State Management**: Sinkronisasi state antara UI dan background
- **Isolate & Concurrency**: Multi-threading di Dart

**Teknologi:**
- `flutter_background_service: ^5.0.10` - Background service core
- `flutter_local_notifications: ^17.2.3` - Local notifications
- `shared_preferences: ^2.3.2` - State persistence

**Resources:**
- [README.md](service/README.md) - Setup dan implementasi lengkap
- [CHEAT_SHEET.md](service/CHEAT_SHEET.md) - Quick reference guide

## 📄 Lisensi

Proyek ini menggunakan lisensi MIT. Lihat file [LICENSE](LICENSE) untuk detail.

---

**Selamat Belajar! 🚀**

Mulai perjalanan Anda dalam pengembangan aplikasi mobile dengan Flutter!