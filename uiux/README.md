# UI/UX Flutter Demo

Aplikasi demonstrasi yang menampilkan berbagai prinsip dan pola UI/UX dalam pengembangan aplikasi mobile menggunakan Flutter.

## Fitur Utama

1. **Prinsip Desain Visual**
   - Menampilkan contoh penerapan prinsip-prinsip desain visual seperti kontras, keselarasan, kedekatan, dan pengulangan.
   - Mencakup tipografi, skema warna, dan tata letak yang baik.

2. **Panduan Platform (Android/iOS)**
   - Menunjukkan perbedaan dan penerapan Material Design (Android) dan Human Interface Guidelines (iOS).
   - Komponen UI yang spesifik platform.

3. **Pola Navigasi Mobile**
   - Berbagai pola navigasi umum di aplikasi mobile.
   - Contoh implementasi tab, drawer, bottom navigation, dan navigasi bersarang.

4. **Microinteractions & Feedback**
   - Contoh interaksi mikro untuk meningkatkan pengalaman pengguna.
   - Animasi, transisi, dan umpan balik visual.

5. **Aksesibilitas & Desain Inklusif**
   - Prinsip desain yang dapat diakses.
   - Dukungan pembaca layar, ukuran teks yang dapat disesuaikan, dan rasio kontras.

6. **Gamifikasi**
   - Elemen game dalam UI/UX.
   - Badge, progress bar, achievement, dan mekanisme reward.

## Persyaratan Sistem

- Flutter SDK (versi terbaru direkomendasikan)
- Dart SDK (versi 3.9.0 atau lebih tinggi)
- Perangkat atau emulator dengan Android/iOS

## Cara Menjalankan

1. Pastikan Flutter SDK sudah terinstall di sistem Anda
2. Clone repository ini
3. Masuk ke direktori proyek:
   ```bash
   cd uiux
   ```
4. Dapatkan dependencies:
   ```bash
   flutter pub get
   ```
5. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## Dependensi Utama

- `flutter`: SDK Flutter
- `cupertino_icons`: Ikon gaya iOS
- `percent_indicator`: Widget untuk menampilkan indikator persentase

## Struktur Proyek

```
lib/
├── main.dart              # Entry point aplikasi
├── screens/               # Berisi berbagai layar aplikasi
│   ├── accessibility_screen.dart
│   ├── design_principles_screen.dart
│   ├── gamification_screen.dart
│   ├── microinteractions_screen.dart
│   ├── navigation_patterns_screen.dart
│   └── platform_guidelines_screen.dart
```

## Lisensi

Proyek ini dilisensikan di bawah MIT License - lihat file [LICENSE](LICENSE) untuk detailnya.

## Referensi

- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design Guidelines](https://material.io/design)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Inclusive Components](https://inclusive-components.design/)
