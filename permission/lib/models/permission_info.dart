import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Model untuk informasi permission
class PermissionInfo {
  final Permission permission;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String rationale;
  final List<String> benefits;

  const PermissionInfo({
    required this.permission,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.rationale,
    required this.benefits,
  });

  /// Daftar semua permissions yang akan di-demo
  static List<PermissionInfo> getAllPermissions() {
    return [
      PermissionInfo(
        permission: Permission.camera,
        title: 'Camera',
        description: 'Access camera to take photos and videos',
        icon: Icons.camera_alt,
        color: Colors.blue,
        rationale: 'Kami memerlukan akses kamera untuk memungkinkan Anda mengambil foto dan video langsung dari aplikasi.',
        benefits: [
          'Ambil foto profil atau dokumen',
          'Scan QR code atau barcode',
          'Rekam video untuk konten',
          'Gunakan fitur AR dan filter',
        ],
      ),
      PermissionInfo(
        permission: Permission.microphone,
        title: 'Microphone',
        description: 'Access microphone to record audio',
        icon: Icons.mic,
        color: Colors.red,
        rationale: 'Akses mikrofon diperlukan untuk merekam audio, melakukan panggilan suara, atau menggunakan fitur voice command.',
        benefits: [
          'Rekam pesan suara',
          'Lakukan panggilan audio/video',
          'Gunakan voice command',
          'Transkripsi suara ke teks',
        ],
      ),
      PermissionInfo(
        permission: Permission.location,
        title: 'Location',
        description: 'Access device location',
        icon: Icons.location_on,
        color: Colors.green,
        rationale: 'Lokasi Anda membantu kami memberikan konten yang relevan berdasarkan area Anda dan fitur berbasis lokasi.',
        benefits: [
          'Temukan tempat terdekat',
          'Navigasi dan petunjuk arah',
          'Konten lokal yang relevan',
          'Check-in lokasi',
        ],
      ),
      PermissionInfo(
        permission: Permission.photos,
        title: 'Photos',
        description: 'Access photo library',
        icon: Icons.photo_library,
        color: Colors.purple,
        rationale: 'Akses galeri foto memungkinkan Anda memilih dan mengunggah foto yang sudah ada di perangkat Anda.',
        benefits: [
          'Upload foto dari galeri',
          'Pilih foto profil',
          'Bagikan momen Anda',
          'Edit dan filter foto',
        ],
      ),
      PermissionInfo(
        permission: Permission.contacts,
        title: 'Contacts',
        description: 'Access contacts list',
        icon: Icons.contacts,
        color: Colors.orange,
        rationale: 'Akses kontak memudahkan Anda untuk mengundang teman, berbagi konten, atau melakukan komunikasi dengan mudah.',
        benefits: [
          'Undang teman dengan mudah',
          'Sinkronisasi kontak',
          'Kirim pesan ke kontak',
          'Temukan teman yang sudah terdaftar',
        ],
      ),
      PermissionInfo(
        permission: Permission.notification,
        title: 'Notifications',
        description: 'Send notifications',
        icon: Icons.notifications,
        color: Colors.teal,
        rationale: 'Notifikasi membantu Anda tetap update dengan informasi penting, pesan baru, dan aktivitas terkini.',
        benefits: [
          'Terima update penting',
          'Notifikasi pesan baru',
          'Pengingat dan reminder',
          'Alert aktivitas terkini',
        ],
      ),
      PermissionInfo(
        permission: Permission.calendar,
        title: 'Calendar',
        description: 'Access calendar events',
        icon: Icons.calendar_today,
        color: Colors.indigo,
        rationale: 'Akses kalender memungkinkan aplikasi untuk menambahkan event, reminder, dan sinkronisasi jadwal Anda.',
        benefits: [
          'Tambah event ke kalender',
          'Sinkronisasi jadwal',
          'Reminder otomatis',
          'Lihat jadwal mendatang',
        ],
      ),
    ];
  }
}
