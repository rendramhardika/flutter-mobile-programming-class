# Dart & Flutter Programming Fundamentals

## 📝 Deskripsi Singkat Project

Proyek pembelajaran komprehensif untuk mempelajari dasar-dasar pemrograman Dart dan pengembangan aplikasi Flutter. Aplikasi ini dirancang sebagai platform pembelajaran interaktif yang memungkinkan pengguna untuk menjelajahi konsep-konsep dasar Dart, komponen Flutter, dan melihat implementasi praktis dalam bentuk aplikasi contoh yang lengkap.

## 📚 Daftar Isi

- [Deskripsi Singkat Project](#-deskripsi-singkat-project)
- [Struktur Project](#-struktur-project)
- [Fitur Project](#-fitur-project)
- [Cara Menjalankan Project](#-cara-menjalankan-project)
- [Dependensi Project](#-dependensi-project)
- [Persyaratan Project](#-persyaratan-project)
- [Materi Pembelajaran](#-materi-pembelajaran)
- [Contoh Aplikasi](#-contoh-aplikasi)

## 📁 Struktur Project

Proyek ini mengikuti struktur standar aplikasi Flutter dengan beberapa folder khusus untuk materi pembelajaran:

```
dart_prog/
├── android/                    # Konfigurasi Android
├── ios/                       # Konfigurasi iOS
├── web/                       # Konfigurasi Web
├── linux/                     # Konfigurasi Linux
├── macos/                     # Konfigurasi macOS
├── windows/                   # Konfigurasi Windows
├── lib/                       # Kode sumber utama
│   ├── dart_fundamentals/     # Dasar-dasar Dart
│   │   ├── 01_variables_and_types.dart
│   │   ├── 02_functions_and_control_flow.dart
│   │   └── 03_classes_and_oop.dart
│   ├── flutter_fundamentals/  # Dasar-dasar Flutter
│   │   ├── 01_basic_widgets.dart
│   │   ├── 02_layout_widgets.dart
│   │   ├── 03_stateful_widgets.dart
│   │   └── 04_navigation_and_routing.dart
│   ├── practical_examples/    # Contoh Aplikasi
│   │   ├── 01_todo_app.dart
│   │   └── 02_calculator_app.dart
│   └── main.dart              # Entry point aplikasi utama
├── test/                      # Unit dan widget tests
├── pubspec.yaml               # Konfigurasi project dan dependencies
├── pubspec.lock               # Lock file untuk dependencies
├── analysis_options.yaml      # Konfigurasi linter
└── README.md                  # Dokumentasi project
```

## 🚀 Cara Menjalankan Project

### Menjalankan di Android Studio

1. Buka Android Studio
2. Pilih "Open an existing project"
3. Arahkan ke direktori `dart_prog`
4. Tunggu hingga proses indexing dan resolving dependencies selesai
5. Pilih emulator atau perangkat fisik dari dropdown device selector
6. Klik tombol Run (ikon play) atau tekan Shift+F10

### Menjalankan di Command Line (CMD/Terminal)

1. Buka terminal/command prompt
2. Arahkan ke direktori project:
   ```bash
   cd path/to/dart_prog
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Jalankan aplikasi:
   ```bash
   # Untuk menjalankan aplikasi utama
   flutter run
   
   # Untuk menjalankan di perangkat spesifik (jika ada multiple devices)
   flutter run -d <device-id>
   ```

### Menjalankan Contoh Dart Individual

Untuk menjalankan file Dart individual dari command line:
```bash
# Menjalankan contoh variabel dan tipe data
dart run lib/dart_fundamentals/01_variables_and_types.dart

# Menjalankan contoh fungsi dan kontrol alur
dart run lib/dart_fundamentals/02_functions_and_control_flow.dart

# Menjalankan contoh classes dan OOP
dart run lib/dart_fundamentals/03_classes_and_oop.dart
```

## 📚 Dependensi Project

Project ini menggunakan beberapa library dan plugin utama:

### Core Dependencies
- **Flutter SDK**: Framework UI untuk membuat aplikasi multi-platform
- **Dart SDK**: Bahasa pemrograman yang digunakan (versi ^3.9.0)

### UI Dependencies
- **cupertino_icons**: ^1.0.8 - Icon pack untuk tampilan iOS style

### Development Dependencies
- **flutter_lints**: ^5.0.0 - Linting rules untuk kode yang lebih bersih dan konsisten
- **flutter_test** - Library untuk unit dan widget testing

## 💻 Persyaratan Project

Untuk menjalankan project ini, pastikan sistem Anda memenuhi persyaratan berikut:

### Persyaratan Sistem
- **OS**: Windows 10/11, macOS, atau Linux
- **RAM**: Minimal 8GB (direkomendasikan 16GB)
- **Disk Space**: Minimal 10GB free space
- **Processor**: 64-bit multi-core

### Software Requirements
- **Flutter SDK**: Versi 3.0.0 atau lebih baru
- **Dart SDK**: Versi 3.0.0 atau lebih baru (biasanya sudah termasuk dalam Flutter SDK)
- **Android Studio**: Versi terbaru dengan Flutter dan Dart plugins terinstall
  - Android SDK
  - Android Emulator atau perangkat fisik dengan USB Debugging enabled
- **Atau VS Code** dengan extensions:
  - Flutter extension
  - Dart extension

### Konfigurasi Environment
- PATH environment variable yang sudah dikonfigurasi untuk Flutter dan Dart
- JDK 8 atau lebih baru untuk Android development

## 📖 Materi Pembelajaran

### 1. Dasar-dasar Dart

#### 🔢 Variabel dan Tipe Data (`01_variables_and_types.dart`)
- **Deklarasi Variabel**: `var`, `final`, `const`
- **Tipe Data Primitif**: `int`, `double`, `String`, `bool`
- **Collections**: `List`, `Set`, `Map`
- **Null Safety**: Nullable types, null-aware operators

**Konsep Utama:**
```dart
// Deklarasi variabel
var name = 'Flutter';
final String framework = 'Flutter';
const double pi = 3.14159;

// Null safety
String? nullableString;
String result = nullableString ?? 'Default';
```

#### 🔧 Fungsi dan Kontrol Alur (`02_functions_and_control_flow.dart`)
- **Fungsi**: Parameter, return types, arrow functions
- **Kontrol Alur**: if-else, switch statements
- **Loops**: for, while, do-while
- **Exception Handling**: try-catch-finally

**Konsep Utama:**
```dart
// Fungsi dengan parameter opsional
String greet(String name, [String? title]) {
  return title != null ? 'Hello $title $name' : 'Hello $name';
}

// Switch expression (Dart 3.0+)
String dayType = switch (day) {
  'Monday' || 'Tuesday' => 'Weekday',
  'Saturday' || 'Sunday' => 'Weekend',
  _ => 'Unknown'
};
```

#### 🏗️ Classes dan OOP (`03_classes_and_oop.dart`)
- **Classes**: Constructors, getters, setters
- **Inheritance**: extends, super, override
- **Abstract Classes**: abstract methods
- **Mixins**: code reuse
- **Enums**: basic dan enhanced enums

**Konsep Utama:**
```dart
// Class dengan constructor
class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  String getInfo() => 'Name: $name, Age: $age';
}

// Mixin
mixin Flyable {
  void fly() => print('Flying...');
}

class Bird with Flyable {
  // Bird can now fly()
}
```

### 2. Dasar-dasar Flutter

#### 🎨 Widget Dasar (`01_basic_widgets.dart`)
- **Text Widgets**: Text, RichText, SelectableText
- **Button Widgets**: ElevatedButton, TextButton, IconButton
- **Input Widgets**: TextField, Switch, Checkbox, Slider
- **Container**: Styling dan decoration

#### 📐 Layout Widgets (`02_layout_widgets.dart`)
- **Linear Layouts**: Row, Column
- **Stack Layout**: Stack, Positioned
- **Flexible Layouts**: Expanded, Flexible
- **Scrollable Widgets**: ListView, GridView
- **Wrap**: Auto-wrapping layout

#### 🔄 StatefulWidget (`03_stateful_widgets.dart`)
- **State Management**: setState()
- **Widget Lifecycle**: initState, dispose, didUpdateWidget
- **Form Handling**: TextEditingController, validation
- **Animations**: AnimationController, Tween

#### 🧭 Navigation (`04_navigation_and_routing.dart`)
- **Basic Navigation**: push, pop
- **Data Passing**: arguments, return values
- **Named Routes**: route configuration
- **Modals**: showDialog, showModalBottomSheet

## 🛠️ Contoh Aplikasi

### 📝 Todo App (`01_todo_app.dart`)
Aplikasi todo list lengkap dengan fitur:
- ✅ Tambah, edit, hapus todo
- 🔄 Toggle status completed
- 📊 Statistik todo
- 🗂️ Filter berdasarkan status
- 💾 State management lokal

**Fitur Utama:**
- CRUD operations
- Form validation
- Dialog interactions
- Tab navigation
- List management

### 🧮 Calculator App (`02_calculator_app.dart`)
Kalkulator dengan tampilan seperti iOS dengan fitur:
- ➕ Operasi matematika dasar (+, -, ×, ÷)
- 🔢 Input angka dan desimal
- 🔄 Clear dan clear entry
- ➖ Toggle sign (±)
- 📱 UI responsif

**Fitur Utama:**
- State management untuk kalkulasi
- Custom button widgets
- Mathematical operations
- Error handling (division by zero)
- Clean UI design

## 📄 Lisensi

Proyek ini menggunakan lisensi MIT. Lihat file LICENSE untuk detail.

---

**Happy Learning! 🚀**

Mulai perjalanan Anda dalam pengembangan aplikasi mobile dengan Dart dan Flutter!
