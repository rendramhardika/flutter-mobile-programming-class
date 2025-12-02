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
- `crud_app/` - CRUD operations dengan 4 implementasi berbeda
  - Database CRUD (Multi Page & Single Page)
  - API CRUD (Multi Page & Single Page)
  - SQLite local storage
  - REST API integration
  - Form handling dan validation
- `notification/` - Push Notification dengan Firebase Cloud Messaging
  - Firebase Cloud Messaging (FCM)
  - Local notifications
  - FCM token management
  - Background & foreground handling
  - Todo list dengan notifikasi otomatis
- `flutter_integration_demo/` - Integrasi API dan Maps dengan Flutter
  - OpenStreetMap integration (6 interactive demos)
  - Smart City Dashboard (Weather, AQI, News)
  - Interactive map features (Markers, Polylines, Polygons, Circles)
  - Multi-API integration
  - Real-time environmental data

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

### 📊 CRUD App (`crud_app/`)
Aplikasi Flutter yang mendemonstrasikan implementasi CRUD dengan 2 metode penyimpanan dan 2 pendekatan UI.

**4 Implementasi CRUD:**

1. **🗄️ Database CRUD - Multi Page**
   - SQLite local storage
   - Full screen form dengan 6+ fields
   - Date picker, dropdown, radio buttons
   - Form validation lengkap
   - Offline functionality

2. **📋 Database CRUD - Single Page**
   - SQLite local storage
   - Dialog form dengan 2-3 fields
   - Quick input tanpa navigation
   - Basic validation

3. **☁️ API CRUD - Multi Page**
   - REST API (JSONPlaceholder)
   - Full screen form
   - HTTP requests (GET, POST, PUT, DELETE)
   - Loading & error handling
   - Server sync

4. **🌐 API CRUD - Single Page**
   - REST API (JSONPlaceholder)
   - Dialog form
   - Quick updates
   - Minimal UI complexity

**Konsep yang Dipelajari:**
- **CRUD Operations**: Create, Read, Update, Delete
- **SQLite Database**: Local storage dengan sqflite
- **REST API**: HTTP requests dengan http package
- **State Management**: StatefulWidget dengan setState()
- **Form Handling**: Validation dan user input
- **Navigation Patterns**: Multi page vs Single page
- **Error Handling**: Try-catch dan user feedback
- **UI/UX States**: Loading, empty, error states

**Perbandingan:**
- **Multi Page vs Single Page**: Full form vs Dialog, Navigation vs No navigation
- **Database vs API**: Offline vs Online, Local vs Server, Fast vs Network dependent

**Teknologi:**
- `sqflite: ^2.3.0` - SQLite database
- `path_provider: ^2.1.1` - Database path
- `http: ^1.1.0` - HTTP client
- `intl: ^0.19.0` - Date formatting

**Architecture:**
- Layered architecture (UI → Service → Data)
- Service pattern untuk business logic
- Model classes dengan JSON serialization
- Reusable widgets dan dialogs

### 🔔 Push Notification Demo (`notification/`)
Aplikasi Flutter yang mendemonstrasikan implementasi lengkap Firebase Cloud Messaging (FCM) dengan local notifications dan Todo List integration.

**Fitur Utama:**

1. **🔥 Firebase Cloud Messaging (FCM)**
   - FCM token generation dan display
   - Token refresh handling
   - Push notification dari Firebase Console
   - Push notification via FCM API
   - Foreground & background message handling
   - Notification tap/click handling

2. **📲 Local Notifications**
   - Local notification dengan custom channel
   - Android notification channels
   - iOS notification permissions
   - Test notification button

3. **📝 Todo List Demo**
   - Create, read, update todo items
   - Mark todo as done/pending
   - Automatic notification saat task completed
   - FCM API integration
   - Real-time UI updates

4. **🔐 Token Management**
   - Display FCM token di UI
   - Copy token untuk testing
   - Submit token ke backend API
   - Token refresh listener

**Konsep yang Dipelajari:**
- **Firebase Cloud Messaging**: Push notification dari server
- **Local Notifications**: Notifikasi lokal dengan flutter_local_notifications
- **FCM Token Management**: Mendapatkan dan mengelola device token
- **Background & Foreground Handling**: Menangani notifikasi di berbagai app state
- **Notification Channels**: Android notification channels
- **API Integration**: Mengirim notifikasi via FCM API
- **Real-world Use Case**: Todo list dengan notifikasi otomatis

**Notification States:**
- **Foreground**: App aktif → Show local notification
- **Background**: App di background → System notification
- **Terminated**: App closed → Handle on app start
- **Notification Tap**: User tap → Navigate to page

**Teknologi:**
- `firebase_core: ^3.8.0` - Firebase core SDK
- `firebase_messaging: ^15.1.6` - FCM push notifications
- `flutter_local_notifications: ^17.2.3` - Local notification handling
- `http: ^1.2.2` - HTTP requests untuk FCM API

**Setup Requirements:**
- Firebase project dengan Android/iOS app configured
- google-services.json (Android) / GoogleService-Info.plist (iOS)
- FCM Server Key untuk API integration
- Physical device untuk full testing (simulator limited)

**Testing Methods:**
- Firebase Console test message
- FCM API via cURL/Postman
- Local notification button
- Todo completion trigger

### 🗺️ Flutter Integration Demo (`flutter_integration_demo/`)
Aplikasi Flutter yang mendemonstrasikan berbagai integrasi API dan library, meliputi OpenStreetMap integration dan Smart City Dashboard dengan multiple API integration.

**Fitur Utama:**

1. **🗺️ OpenStreetMap Integration (6 Interactive Demos)**
   - **Basic Map**: Peta dasar dengan zoom & pan controls
   - **Interactive Markers**: Tap peta untuk tambah marker dengan label custom
   - **Interactive Polylines**: Drawing polylines dengan tap berurutan
   - **Interactive Polygons**: Drawing polygons dengan minimal 3 points
   - **Interactive Circle Markers**: Circle dengan radius custom
   - **Custom Tiles**: Custom map styling dengan tile provider berbeda

2. **🌿 Smart City Dashboard**
   - **Weather Data**: Real-time cuaca dari OpenWeatherMap API
   - **Air Quality Index**: AQI real-time dari WAQI API dengan color-coded indicator
   - **Environmental News**: Berita lingkungan dari NewsAPI.org
   - **Mini Map**: OpenStreetMap integration dengan auto-update
   - **Location Picker**: Manual input atau quick select 8 kota
   - **Pull to Refresh**: Refresh semua data sekaligus

**Interactive Features:**
- User-generated content (markers, polylines, polygons, circles)
- Real-time feedback dengan SnackBar
- Console logging untuk setiap object yang dibuat
- Counter di AppBar untuk tracking objects
- Delete all buttons

**Konsep yang Dipelajari:**
- **Map Integration**: OpenStreetMap dengan flutter_map package
- **Multi-API Integration**: Combine 3 different APIs (Weather, AQI, News)
- **Location Services**: GPS location dengan geolocator
- **Permission Handling**: Runtime permissions untuk location
- **HTTP Requests**: REST API calls dengan http package
- **State Management**: StatefulWidget dengan real-time updates
- **Data Modeling**: JSON parsing dan model classes
- **UI/UX**: Material 3 design, loading states, error handling

**Teknologi:**
- `flutter_map: ^7.0.2` - OpenStreetMap integration
- `latlong2: ^0.9.1` - Latitude/Longitude handling
- `geolocator: ^13.0.2` - GPS location services
- `permission_handler: ^11.3.1` - Permission handling
- `http: ^1.1.0` - HTTP requests
- `url_launcher: ^6.2.0` - Open URLs in browser
- `intl: ^0.19.0` - Date/time formatting
- `shared_preferences: ^2.2.0` - Local storage

**APIs Used:**
- **OpenWeatherMap API**: Weather data (1,000 calls/day free)
- **WAQI API**: Air quality index (1,000 requests/minute free)
- **NewsAPI.org**: Environmental news (100 requests/day free)

**Setup Requirements:**
- API keys untuk 3 services (OpenWeatherMap, WAQI, NewsAPI)
- Location permissions (Android & iOS)
- Internet connection
- `lib/config/api_config.dart` untuk API keys configuration

**Console Logging:**
- Detailed logging untuk setiap marker, polyline, polygon, circle
- API request/response logging
- Coordinate tracking
- Object counters

**UI/UX Features:**
- Material 3 design dengan responsive cards
- Color-coded indicators untuk AQI
- Loading states untuk setiap section
- Error handling dengan retry
- Indonesian localization
- Pull to refresh functionality

**Default Settings:**
- Location: Medan, Indonesia (3.5952, 98.6722)
- Language: Indonesian (id_ID)
- Map Tiles: OpenStreetMap

## 📄 Lisensi

Proyek ini menggunakan lisensi MIT. Lihat file [LICENSE](LICENSE) untuk detail.

---

**Selamat Belajar! 🚀**

Mulai perjalanan Anda dalam pengembangan aplikasi mobile dengan Flutter!