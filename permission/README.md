# Permission Demo App

Aplikasi Flutter yang mendemonstrasikan implementasi lengkap permission handling dengan UX best practices menggunakan `permission_handler` package. Project ini menunjukkan cara yang benar untuk meminta, mengelola, dan menangani berbagai jenis permissions di Android dan iOS.

## 📱 Features

### Permissions yang Didukung

Aplikasi ini mendemonstrasikan cara handle 7 jenis permissions:

- 📷 **Camera** - Akses kamera untuk mengambil foto dan video
- 🎤 **Microphone** - Akses microphone untuk merekam audio
- 📍 **Location** - Akses lokasi device untuk layanan berbasis lokasi
- 📁 **Photos** - Akses photo library untuk memilih dan menyimpan gambar
- 📞 **Contacts** - Akses daftar kontak pengguna
- 🔔 **Notifications** - Mengirim push notifications ke pengguna
- 📅 **Calendar** - Akses dan modifikasi calendar events

### ✨ UX Best Practices

#### Permission Rationale Dialog
Dialog yang muncul **sebelum** system permission dialog, menjelaskan:
- **Mengapa** permission diperlukan dengan penjelasan yang jelas
- **Manfaat** yang akan didapat user dari permission tersebut
- **Privacy assurance** bahwa data user aman dan tidak akan dibagikan
- **Visual design** yang menarik dengan icon dan color coding

#### Additional Features
- **Confirmation Dialog** - Dialog konfirmasi sebelum request all permissions sekaligus
- **Visual Status Indicators** - Badge dengan color coding untuk setiap permission state:
  - ✅ Green = Granted
  - ⚠️ Orange = Denied
  - ❌ Red = Permanently Denied
  - 🔒 Grey = Restricted
  - 📊 Yellow = Limited
- **Settings Redirect** - Automatic redirect ke app settings jika permission permanently denied
- **Real-time Status Update** - Status permission update otomatis setelah user memberikan/menolak

## 🏗️ Struktur Project

```
lib/
├── models/
│   └── permission_info.dart              # Model untuk data permission
├── services/
│   └── permission_service.dart           # Service layer untuk permission logic
├── widgets/
│   ├── permission_card.dart              # Widget card untuk setiap permission
│   └── permission_rationale_dialog.dart  # Dialog rationale sebelum request
├── screens/
│   └── permission_demo_screen.dart       # Main screen
└── main.dart
```

## 🚀 Quick Start

### 1. Install Dependencies

```bash
cd permission
flutter pub get
```

### 2. Run Aplikasi

**Android:**
```bash
flutter run
```

**iOS (memerlukan Mac):**
```bash
flutter run -d ios
```

**Pilih device tertentu:**
```bash
flutter devices  # Lihat daftar devices
flutter run -d <device-id>
```

### 3. Testing Permissions

#### Single Permission Request:
1. Tap pada card permission yang ingin di-test
2. **Rationale dialog** akan muncul dengan penjelasan lengkap
3. Klik "Izinkan" untuk melanjutkan ke system permission dialog
4. Pilih "Allow" atau "Deny" pada system dialog
5. Status akan update otomatis dengan color indicator

#### Multiple Permissions Request:
1. Klik tombol "Request All Permissions" di bottom
2. Confirmation dialog akan muncul
3. Klik "Request" untuk melanjutkan
4. Rationale dialog akan muncul untuk setiap permission
5. Semua status akan update setelah selesai

#### Handling Permanently Denied:
- Jika permission permanently denied (ditolak 2x di Android)
- Dialog akan muncul dengan opsi "Open Settings"
- User akan diarahkan ke app settings untuk enable permission manual

## 🔧 Konfigurasi Platform

### Android Configuration

Permissions sudah dikonfigurasi di `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_CONTACTS"/>
<uses-permission android:name="android.permission.WRITE_CONTACTS"/>
<uses-permission android:name="android.permission.READ_CALENDAR"/>
<uses-permission android:name="android.permission.WRITE_CALENDAR"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

**Minimum SDK:** 21 (Android 5.0)
**Target SDK:** 34 (Android 14)

### iOS Configuration

Usage descriptions sudah ditambahkan di `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi memerlukan akses kamera untuk mengambil foto</string>

<key>NSMicrophoneUsageDescription</key>
<string>Aplikasi memerlukan akses microphone untuk merekam audio</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi memerlukan akses lokasi untuk fitur berbasis lokasi</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi memerlukan akses photo library untuk memilih gambar</string>

<key>NSContactsUsageDescription</key>
<string>Aplikasi memerlukan akses kontak untuk fitur berbagi</string>

<key>NSCalendarsUsageDescription</key>
<string>Aplikasi memerlukan akses calendar untuk mengelola events</string>
```

**Minimum iOS Version:** 12.0

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  permission_handler: ^11.3.1  # Main package untuk permission handling

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

**Key Package:**
- `permission_handler: ^11.3.1` - Package untuk handle runtime permissions di Android & iOS

## 💡 Implementation Flow

### Permission Request Flow

```
┌─────────────────────────────────────────────────────────────┐
│ 1. User taps permission card                                │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. Check current permission status                          │
│    - PermissionService.checkPermission()                    │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. Show Rationale Dialog                                    │
│    - Explain why permission is needed                       │
│    - Show benefits to user                                  │
│    - Privacy assurance                                      │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. User clicks "Izinkan" → Request Permission               │
│    - PermissionService.requestPermission()                  │
│    - System permission dialog appears                       │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. Handle Response                                          │
│    ✅ Granted → Update UI, enable feature                   │
│    ⚠️ Denied → Show message, can request again             │
│    ❌ Permanently Denied → Show settings dialog             │
└─────────────────────────────────────────────────────────────┘
```

### Key Components

1. **PermissionService** - Service layer untuk semua permission logic
2. **PermissionInfo** - Model untuk data permission (title, icon, rationale, benefits)
3. **PermissionRationaleDialog** - Custom dialog untuk menjelaskan permission
4. **PermissionCard** - Widget card untuk menampilkan status permission
5. **PermissionDemoScreen** - Main screen dengan list semua permissions

## 🎯 Permission States

- **Granted** ✅ - Permission diberikan
- **Denied** ⚠️ - Permission ditolak (bisa request lagi)
- **Permanently Denied** ❌ - Permission ditolak permanent (harus via settings)
- **Restricted** 🔒 - Permission dibatasi oleh sistem
- **Limited** 📊 - Permission diberikan dengan batasan (iOS 14+)

## 🐛 Troubleshooting

### Permission tidak muncul di Android
**Solusi:**
- Pastikan permission sudah declared di `AndroidManifest.xml`
- Clean dan rebuild project: `flutter clean && flutter pub get`
- Uninstall app dan install ulang

### Permission tidak muncul di iOS
**Solusi:**
- Pastikan usage description sudah ada di `Info.plist`
- Clean build folder: `flutter clean`
- Delete app dari simulator/device dan install ulang
- Check iOS deployment target minimal 12.0

### Permission selalu denied di emulator
**Solusi:**
- Test di real device untuk hasil akurat
- Beberapa permissions (camera, location) terbatas di emulator
- Reset emulator permissions: Settings → Apps → Your App → Permissions

### Permanently denied tidak bisa direset
**Solusi:**
- Uninstall dan install ulang aplikasi
- Atau: Settings → Apps → Your App → Permissions → Reset

## 📝 Important Notes

- ⚠️ **Testing di real device sangat direkomendasikan** untuk hasil akurat
- 📱 Beberapa permissions mungkin tidak tersedia di semua platform
- 🔄 Emulator memiliki keterbatasan untuk camera, location, dan sensor permissions
- 🎯 Selalu tampilkan rationale sebelum request permission (UX best practice)
- 🔒 Handle semua permission states (granted, denied, permanently denied, restricted, limited)
- ⏰ Request permission pada saat yang tepat (contextual), bukan saat app launch

## 📚 Learning Resources

### Documentation
- [USAGE_GUIDE.md](USAGE_GUIDE.md) - Panduan lengkap cara menggunakan permission service
- [permission_handler package](https://pub.dev/packages/permission_handler) - Official package documentation
- [Flutter Documentation](https://docs.flutter.dev/) - Flutter official docs

### Platform Guidelines
- [Android Permissions Guide](https://developer.android.com/guide/topics/permissions/overview) - Android permission best practices
- [Android Runtime Permissions](https://developer.android.com/training/permissions/requesting) - Request permissions at runtime
- [iOS Permissions Guide](https://developer.apple.com/documentation/uikit/protecting_the_user_s_privacy) - iOS privacy and permissions
- [iOS Requesting Access](https://developer.apple.com/documentation/uikit/protecting_the_user_s_privacy/requesting_access_to_protected_resources) - Request protected resources

### Best Practices
- [Material Design - Permissions](https://m2.material.io/design/platform-guidance/android-permissions.html) - UX guidelines untuk permissions
- [Human Interface Guidelines - Permissions](https://developer.apple.com/design/human-interface-guidelines/privacy) - iOS UX guidelines

## 👨‍💻 Author

Project ini dibuat untuk keperluan pembelajaran Flutter Mobile Programming.

## 📄 License

Project ini dibuat untuk tujuan edukasi.

---

**Happy Coding! 🚀**
