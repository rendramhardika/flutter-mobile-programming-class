# Setup API Keys untuk Environment Dashboard

Untuk menggunakan fitur **Smart City Dashboard**, Anda perlu mendaftar dan mendapatkan API keys dari 3 layanan berikut:

## 1. OpenWeatherMap API

### Cara Mendaftar:
1. Kunjungi: https://openweathermap.org/api
2. Klik **"Sign Up"** atau **"Get API Key"**
3. Buat akun gratis
4. Setelah login, pergi ke **API Keys** di dashboard
5. Copy API key Anda

### Free Tier:
- ✅ 1,000 API calls per hari
- ✅ Current weather data
- ✅ Air pollution data
- ✅ Tidak perlu kartu kredit

### Endpoint yang Digunakan:
- Current Weather: `/weather`
- Air Pollution: `/air_pollution` (opsional, kita pakai WAQI)

---

## 2. WAQI (World Air Quality Index) API

### Cara Mendaftar:
1. Kunjungi: https://aqicn.org/data-platform/token/
2. Isi form dengan:
   - Nama
   - Email
   - Deskripsi penggunaan (contoh: "Educational project for environment monitoring")
3. Submit form
4. Cek email Anda untuk mendapatkan API token

### Free Tier:
- ✅ 1,000 requests per menit
- ✅ Real-time air quality data
- ✅ Coverage global
- ✅ Tidak perlu kartu kredit

### Endpoint yang Digunakan:
- Get AQI by coordinates: `/feed/geo:{lat};{lon}/`
- Get AQI by city: `/feed/{city}/`

---

## 3. NewsAPI.org

### Cara Mendaftar:
1. Kunjungi: https://newsapi.org/register
2. Isi form registrasi
3. Verifikasi email
4. Login dan copy API key dari dashboard

### Free Tier (Developer Plan):
- ✅ 100 requests per hari
- ✅ Akses ke semua endpoint
- ✅ Berita dari 150,000+ sources
- ⚠️ Hanya untuk development (tidak untuk production)

### Endpoint yang Digunakan:
- Everything: `/everything` (search berita dengan keyword)
- Top Headlines: `/top-headlines` (berita terbaru)

---

## Cara Memasukkan API Keys

### Langkah 1: Buka File Konfigurasi
Buka file: `lib/config/api_config.dart`

### Langkah 2: Paste API Keys
Ganti placeholder dengan API keys Anda:

```dart
class ApiConfig {
  // OpenWeatherMap API Key
  static const String openWeatherMapApiKey = 'PASTE_YOUR_KEY_HERE';
  
  // WAQI API Key
  static const String waqiApiKey = 'PASTE_YOUR_KEY_HERE';
  
  // NewsAPI.org API Key
  static const String newsApiKey = 'PASTE_YOUR_KEY_HERE';
  
  // ... (sisanya tidak perlu diubah)
}
```

### Langkah 3: Save dan Run
1. Save file
2. Run `flutter pub get` (jika belum)
3. Run aplikasi

---

## Testing API Keys

### Test OpenWeatherMap:
```bash
curl "https://api.openweathermap.org/data/2.5/weather?q=Medan&appid=YOUR_API_KEY"
```

### Test WAQI:
```bash
curl "https://api.waqi.info/feed/medan/?token=YOUR_TOKEN"
```

### Test NewsAPI:
```bash
curl "https://newsapi.org/v2/everything?q=environment&language=id&apiKey=YOUR_API_KEY"
```

---

## Troubleshooting

### Error: "API Key tidak valid"
- ✅ Pastikan API key sudah di-copy dengan benar (tidak ada spasi)
- ✅ Untuk OpenWeatherMap, tunggu beberapa menit setelah registrasi (aktivasi API key)
- ✅ Pastikan tidak ada tanda kutip tambahan di config file

### Error: "Terlalu banyak permintaan"
- ⚠️ Anda sudah mencapai limit free tier
- 💡 Tunggu 24 jam untuk reset (untuk NewsAPI)
- 💡 Gunakan cache atau kurangi frekuensi refresh

### Error: "Data tidak tersedia untuk lokasi ini"
- 💡 Coba kota lain yang lebih besar (Jakarta, Bandung, Surabaya)
- 💡 Untuk WAQI, tidak semua kota kecil memiliki monitoring station

---

## Tips Penggunaan

1. **Jangan commit API keys ke Git**
   - Tambahkan `api_config.dart` ke `.gitignore` jika akan di-push ke repository public

2. **Gunakan dengan bijak**
   - Free tier memiliki limit
   - Implementasikan caching untuk mengurangi API calls
   - Jangan refresh terlalu sering

3. **Production Ready**
   - Untuk production, gunakan environment variables
   - Upgrade ke paid plan jika diperlukan
   - Implementasikan proper error handling

---

## Lokasi Default

Default lokasi adalah **Medan, Indonesia**:
- Latitude: 3.5952
- Longitude: 98.6722

Anda bisa mengubahnya di `lib/config/api_config.dart`:

```dart
static const double defaultLatitude = 3.5952;
static const double defaultLongitude = 98.6722;
static const String defaultCityName = 'Medan';
```

---

## Support

Jika mengalami masalah:
1. Periksa console untuk error messages
2. Pastikan internet connection aktif
3. Test API keys dengan curl command di atas
4. Periksa dokumentasi official dari masing-masing API provider

**Happy Coding! 🚀**
