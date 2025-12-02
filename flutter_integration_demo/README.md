# Flutter Integration Demo

Aplikasi Flutter yang mendemonstrasikan berbagai integrasi API dan library, meliputi:
- **OpenStreetMap Integration** menggunakan `flutter_map`
- **Smart City Dashboard** dengan integrasi Weather, Air Quality, dan News API

## 📱 Fitur Utama

### 🗺️ 1. Integrasi OpenStreetMap (6 Menu)

#### **1.1 Basic Map**
- Peta dasar dengan kontrol zoom dan pan
- Menggunakan tile dari OpenStreetMap
- Location permission handling
- Default lokasi: Medan, Indonesia

#### **1.2 Markers (Interaktif)** ⭐
- **Tap peta** untuk menambah marker
- Dialog input label marker
- Marker dengan label di atas icon
- Warna berbeda untuk setiap marker
- Counter di AppBar
- Tombol hapus semua marker
- **Console logging** setiap marker yang dibuat

#### **1.3 Polylines (Interaktif)** ⭐
- **Tombol "Gambar Polyline"** untuk mulai drawing
- Tap berurutan pada peta untuk menambah titik
- Preview polyline hijau saat drawing
- Minimal 2 titik untuk membuat polyline
- Tombol "Selesai" dan "Batal"
- Counter points di AppBar
- Warna berbeda untuk setiap polyline
- **Console logging** setiap polyline yang dibuat

#### **1.4 Polygons (Interaktif)** ⭐
- **Tombol "Gambar Polygon"** untuk mulai drawing
- Tap berurutan pada peta untuk menambah titik
- Preview polygon hijau dengan marker di setiap point
- Minimal 3 titik untuk membuat polygon
- Tombol "Selesai" dan "Batal"
- Counter points di AppBar
- Warna berbeda untuk setiap polygon
- **Console logging** setiap polygon yang dibuat

#### **1.5 Circle Markers (Interaktif)** ⭐
- **Tap peta** untuk menambah circle marker
- Dialog input label dan radius (dalam pixel)
- Circle dengan radius custom
- Warna berbeda untuk setiap circle
- Counter di AppBar
- Tombol hapus semua circle
- **Console logging** setiap circle yang dibuat

#### **1.6 Custom Tiles**
- Menggunakan tile provider berbeda
- Demonstrasi custom map styling

---

### 🌿 2. Smart City Dashboard

Dashboard lingkungan yang mengintegrasikan 3 API berbeda:

#### **2.1 Weather Data (OpenWeatherMap API)**
- Cuaca real-time
- Temperature, humidity, wind speed
- Weather description dalam Bahasa Indonesia
- Weather icon dari API
- Koordinat lokasi

#### **2.2 Air Quality Index (WAQI API)**
- Real-time AQI value
- Color-coded indicator (Good/Moderate/Unhealthy/etc)
- Health implications dalam Bahasa Indonesia
- Detail pollutants (PM2.5, PM10, O3, NO2)
- Emoji indicator mood

#### **2.3 Environmental News (NewsAPI.org)**
- Berita lingkungan terkini dalam Bahasa Indonesia
- Filter berdasarkan kota yang dipilih
- Thumbnail images
- Time ago format ("2 jam yang lalu")
- Tap to open in browser
- Source attribution

#### **2.4 Mini Map**
- OpenStreetMap integration
- Marker di lokasi terpilih
- Interactive (zoom & pan)
- Auto-update saat ganti lokasi

#### **2.5 Location Picker**
- Input manual nama kota
- Quick select: Medan, Aceh, Sibolga, Padang, Jakarta, Bandung, Surabaya, Yogyakarta
- Auto-update semua data (weather, AQI, news, map)

#### **2.6 Pull to Refresh**
- Swipe down untuk refresh
- Refresh button di AppBar
- Loading indicators untuk setiap section

---

## 🛠️ Tech Stack

### Dependencies
```yaml
dependencies:
  flutter_map: ^7.0.2          # OpenStreetMap integration
  latlong2: ^0.9.1             # Latitude/Longitude handling
  geolocator: ^13.0.2          # GPS location services
  permission_handler: ^11.3.1  # Permission handling
  http: ^1.1.0                 # HTTP requests
  intl: ^0.19.0                # Date/time formatting
  url_launcher: ^6.2.0         # Open URLs
  shared_preferences: ^2.2.0   # Local storage
```

### APIs Used
1. **OpenWeatherMap API** - Weather data
   - Endpoint: `/weather`
   - Free tier: 1,000 calls/day
   
2. **WAQI (World Air Quality Index) API** - Air quality data
   - Endpoint: `/feed/geo:{lat};{lon}/`
   - Free tier: 1,000 requests/minute
   
3. **NewsAPI.org** - Environmental news
   - Endpoint: `/everything`
   - Free tier: 100 requests/day

---

## 📦 Installation

### 1. Clone Repository
```bash
git clone <repository-url>
cd flutter_map
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Setup API Keys
Buka file `lib/config/api_config.dart` dan paste API keys Anda:

```dart
class ApiConfig {
  static const String openWeatherMapApiKey = 'YOUR_KEY_HERE';
  static const String waqiApiKey = 'YOUR_KEY_HERE';
  static const String newsApiKey = 'YOUR_KEY_HERE';
}
```

**Cara mendapatkan API Keys:**
- OpenWeatherMap: https://openweathermap.org/api
- WAQI: https://aqicn.org/data-platform/token/
- NewsAPI: https://newsapi.org/register

Lihat `SETUP_API_KEYS.md` untuk panduan lengkap.

### 4. Run Application
```bash
flutter run
```

---

## 📱 Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi memerlukan akses lokasi untuk menampilkan peta</string>
```

---

## 🎯 Features Highlights

### ✨ Interactive Features
- **User-generated content**: User bisa menambah marker, polyline, polygon, dan circle sendiri
- **Real-time feedback**: SnackBar notifications dan visual feedback
- **Console logging**: Setiap object yang dibuat ter-log di console dengan detail lengkap

### 🔍 Console Logging Format
```
📍 Marker ditambahkan:
   Label: Rumah Saya
   Koordinat: 3.5952, 98.6722
   Total markers: 1

✏️ Mulai menggambar polyline
📍 Point ditambahkan: 3.5952, 98.6722
   Total points: 2
✅ Polyline selesai dibuat:
   Jumlah points: 2
   Total polylines: 1

🔷 Polygon selesai dibuat:
   Jumlah points: 3
   Total polygons: 1

🔵 Circle Marker ditambahkan:
   Radius: 150.0 px
   Total circles: 1

🌤️ Weather API (by city): https://api.openweathermap.org/...
🏭 Air Quality API (by coords): https://api.waqi.info/...
📰 News API Results: 15 total articles
```

### 🎨 UI/UX Features
- Material 3 design
- Responsive cards dengan elevation
- Color-coded indicators
- Loading states
- Error handling dengan retry
- Pull to refresh
- Indonesian localization

---

## 📂 Project Structure

```
lib/
├── main.dart                           # Entry point
├── config/
│   └── api_config.dart                # API keys configuration
├── models/
│   ├── weather_model.dart             # Weather data model
│   ├── air_quality_model.dart         # AQI data model
│   └── news_model.dart                # News data model
├── services/
│   ├── location_service.dart          # Location & permission handling
│   ├── weather_service.dart           # OpenWeatherMap API
│   ├── air_quality_service.dart       # WAQI API
│   └── news_service.dart              # NewsAPI integration
├── widgets/
│   ├── weather_card.dart              # Weather display widget
│   ├── aqi_card.dart                  # AQI display widget
│   └── news_list.dart                 # News list widget
└── screens/
    ├── landing_screen.dart            # Main landing page
    ├── home_screen.dart               # OSM menu list
    ├── basic_map_screen.dart          # Basic map demo
    ├── markers_screen.dart            # Interactive markers
    ├── polylines_screen.dart          # Interactive polylines
    ├── polygons_screen.dart           # Interactive polygons
    ├── circle_markers_screen.dart     # Interactive circles
    ├── custom_tiles_screen.dart       # Custom tiles demo
    └── environment_dashboard_screen.dart  # Smart City Dashboard
```

---

## 🧪 Testing

### Test OpenStreetMap Features
1. Buka "Integrasi Open Street Map"
2. Test setiap menu (1-6)
3. Untuk menu interaktif (2-5):
   - Coba tambah object
   - Cek console log
   - Test tombol hapus

### Test Smart City Dashboard
1. Buka "Smart City Dashboard"
2. Pastikan API keys sudah di-setup
3. Cek data weather, AQI, dan news
4. Test location picker
5. Test pull to refresh

---

## 🐛 Troubleshooting

### Location Permission Tidak Muncul
- Pastikan permissions sudah ditambahkan di `AndroidManifest.xml`
- Uninstall dan install ulang aplikasi

### API Tidak Mengembalikan Data
- Cek console log untuk error messages
- Pastikan API keys valid
- Cek internet connection
- Lihat `SETUP_API_KEYS.md` untuk troubleshooting

### News Tidak Muncul
- NewsAPI free tier hanya untuk development
- Cek console log: `📰 News API Response: 426` = upgrade required
- Aplikasi akan otomatis fallback ke top headlines

---

## 📝 Notes

- **Default Location**: Medan, Indonesia (3.5952, 98.6722)
- **Language**: Indonesian (id_ID)
- **Map Tiles**: OpenStreetMap
- **User Agent**: com.example.flutter_map

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📄 License

This project is for educational purposes.

---

## 👨‍💻 Author

Created as a demonstration of Flutter integration capabilities.

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [flutter_map Package](https://pub.dev/packages/flutter_map)
- [OpenStreetMap](https://www.openstreetmap.org/)
- [OpenWeatherMap API](https://openweathermap.org/api)
- [WAQI API](https://aqicn.org/api/)
- [NewsAPI](https://newsapi.org/)

---

**Happy Coding! 🚀**
