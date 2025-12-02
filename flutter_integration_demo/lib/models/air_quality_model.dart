import 'package:flutter/material.dart';

class AirQualityModel {
  final int aqi;
  final String cityName;
  final double? pm25;
  final double? pm10;
  final double? o3;
  final double? no2;
  final double? so2;
  final double? co;
  final DateTime dateTime;

  AirQualityModel({
    required this.aqi,
    required this.cityName,
    this.pm25,
    this.pm10,
    this.o3,
    this.no2,
    this.so2,
    this.co,
    required this.dateTime,
  });

  factory AirQualityModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final iaqi = data['iaqi'] as Map<String, dynamic>? ?? {};
    
    return AirQualityModel(
      aqi: data['aqi'] as int,
      cityName: data['city']['name'] ?? 'Unknown',
      pm25: iaqi['pm25']?['v']?.toDouble(),
      pm10: iaqi['pm10']?['v']?.toDouble(),
      o3: iaqi['o3']?['v']?.toDouble(),
      no2: iaqi['no2']?['v']?.toDouble(),
      so2: iaqi['so2']?['v']?.toDouble(),
      co: iaqi['co']?['v']?.toDouble(),
      dateTime: DateTime.parse(data['time']['iso']),
    );
  }

  String get qualityLevel {
    if (aqi <= 50) return 'Baik';
    if (aqi <= 100) return 'Sedang';
    if (aqi <= 150) return 'Tidak Sehat untuk Sensitif';
    if (aqi <= 200) return 'Tidak Sehat';
    if (aqi <= 300) return 'Sangat Tidak Sehat';
    return 'Berbahaya';
  }

  Color get qualityColor {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow.shade700;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.brown.shade900;
  }

  IconData get qualityIcon {
    if (aqi <= 50) return Icons.sentiment_very_satisfied;
    if (aqi <= 100) return Icons.sentiment_satisfied;
    if (aqi <= 150) return Icons.sentiment_neutral;
    if (aqi <= 200) return Icons.sentiment_dissatisfied;
    return Icons.sentiment_very_dissatisfied;
  }

  String get healthImplication {
    if (aqi <= 50) return 'Kualitas udara baik, aman untuk aktivitas luar ruangan';
    if (aqi <= 100) return 'Kualitas udara dapat diterima untuk sebagian besar orang';
    if (aqi <= 150) return 'Kelompok sensitif mungkin mengalami efek kesehatan';
    if (aqi <= 200) return 'Semua orang mungkin mulai mengalami efek kesehatan';
    if (aqi <= 300) return 'Peringatan kesehatan: semua orang mungkin mengalami efek serius';
    return 'Peringatan kesehatan darurat: seluruh populasi berisiko';
  }
}
