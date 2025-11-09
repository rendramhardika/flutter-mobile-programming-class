# 📋 Form Flutter - Aplikasi Manajemen Tugas

## 📝 Deskripsi

Aplikasi Flutter untuk manajemen tugas dengan fitur form yang lengkap. Aplikasi ini dirancang untuk membantu pengguna dalam mengelola daftar tugas dengan antarmuka yang intuitif dan fungsionalitas yang lengkap.

## ✨ Fitur Utama

### 🔐 Autentikasi Pengguna
- Halaman login dengan validasi form
- Penyimpanan data pengguna (nama dan NIM)
- Validasi input untuk memastikan data yang dimasukkan valid

### 📋 Manajemen Tugas
- Tambah tugas baru dengan detail lengkap
- Edit tugas yang sudah ada
- Hapus tugas yang tidak diperlukan
- Tandai tugas sebagai selesai

### 📊 Tampilan Interaktif
- Daftar tugas dengan kartu informatif
- Warna kode prioritas (tinggi, sedang, rendah)
- Progress bar untuk melacak kemajuan tugas
- Indikator visual untuk tugas yang mendekati deadline
- Tema gelap/terang yang responsif

### ⚙️ Validasi Form
- Validasi input untuk semua field
- Pesan error yang informatif
- Pencegahan pengiriman form yang tidak valid

### 🔔 Notifikasi
- Peringatan untuk tugas yang mendekati deadline
- Konfirmasi sebelum menghapus tugas
- Feedback visual untuk aksi pengguna

## 🚀 Panduan Instalasi

1. Pastikan Flutter SDK sudah terinstall di sistem Anda
2. Clone repositori ini atau unduh source code
3. Masuk ke direktori proyek:
   ```bash
   cd formflutter
   ```
4. Dapatkan dependencies yang dibutuhkan:
   ```bash
   flutter pub get
   ```
5. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## 🛠️ Teknologi yang Digunakan

- **Flutter** - Framework untuk membangun antarmuka pengguna
- **Dart** - Bahasa pemrograman yang digunakan
- **Material Design 3** - Untuk desain antarmuka yang modern
- **Intl** - Untuk format tanggal dan waktu

## 📂 Struktur Proyek

```
lib/
├── main.dart              # Entry point aplikasi
├── models/               # Model data
│   └── data_item.dart    # Model untuk item tugas
├── pages/                # Halaman aplikasi
│   ├── login_page.dart   # Halaman login
│   ├── data_list_page.dart  # Halaman daftar tugas
│   ├── add_data_page.dart   # Halaman tambah tugas
│   └── edit_task_page.dart  # Halaman edit tugas
└── widgets/              # Komponen UI yang dapat digunakan ulang
    ├── sweet_alert_dialog.dart
    └── sweet_toast.dart
```

## 🎨 Tema dan Gaya

Aplikasi ini menggunakan Material Design 3 dengan warna kustom:
- Warna primer: Biru
- Warna sekunder: Ungu
- Dukungan tema gelap/terang

### SweetAlertDialog

Dialog konfirmasi yang lebih menarik dengan animasi dan ikon:

```dart
SweetAlertDialog.show(
  context: context,
  title: 'Hapus Tugas',
  content: 'Apakah Anda yakin ingin menghapus tugas "${item.title}"?',
  alertType: AlertType.warning,
  confirmText: 'HAPUS',
  cancelText: 'BATAL',
  onConfirm: () {
    // Kode untuk menghapus tugas
  },
);
```

### SweetToast

Notifikasi toast yang lebih menarik dengan ikon dan warna yang berbeda berdasarkan tipe:

```dart
// Notifikasi sukses
SweetToast.showSuccess(
  context: context,
  message: 'Tugas berhasil dihapus',
  duration: const Duration(seconds: 5),
  actionLabel: 'BATALKAN',
  onAction: () {
    // Kode untuk membatalkan penghapusan
  },
);

// Notifikasi informasi
SweetToast.showInfo(
  context: context,
  message: 'Tugas telah dikembalikan',
  duration: const Duration(seconds: 2),
);
```

## 📱 Kompatibilitas

- Android 5.0 (API level 21) atau lebih baru
- iOS 11.0 atau lebih baru
- Web (Chrome, Firefox, Safari, Edge)
- Desktop (Windows, macOS, Linux)


## 📄 Lisensi

Proyek ini dilisensikan di bawah MIT License - lihat file [LICENSE](LICENSE) untuk detailnya.

---

**Selamat Menggunakan!** 🎉

Aplikasi ini dikembangkan untuk keperluan pembelajaran dan dapat digunakan sebagai referensi dalam pengembangan aplikasi Flutter dengan form yang kompleks.