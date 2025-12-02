import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/air_quality_model.dart';

class AirQualityService {
  /// Get air quality by coordinates
  static Future<AirQualityModel> getAirQuality({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      '${ApiConfig.waqiBaseUrl}/feed/geo:$latitude;$longitude/?'
      'token=${ApiConfig.waqiApiKey}',
    );

    print('🏭 Air Quality API (by coords): $url');

    try {
      final response = await http.get(url);
      print('🏭 Air Quality API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'ok') {
          return AirQualityModel.fromJson(data);
        } else {
          throw Exception('Data kualitas udara tidak tersedia untuk lokasi ini');
        }
      } else if (response.statusCode == 401) {
        throw Exception('API Key tidak valid. Silakan periksa konfigurasi API key Anda.');
      } else {
        throw Exception('Gagal memuat data kualitas udara: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get air quality by city name
  static Future<AirQualityModel> getAirQualityByCity(String cityName) async {
    final url = Uri.parse(
      '${ApiConfig.waqiBaseUrl}/feed/$cityName/?'
      'token=${ApiConfig.waqiApiKey}',
    );

    print('🏭 Air Quality API (by city): $url');

    try {
      final response = await http.get(url);
      print('🏭 Air Quality API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'ok') {
          return AirQualityModel.fromJson(data);
        } else {
          throw Exception('Data kualitas udara tidak tersedia untuk kota ini');
        }
      } else if (response.statusCode == 401) {
        throw Exception('API Key tidak valid. Silakan periksa konfigurasi API key Anda.');
      } else {
        throw Exception('Gagal memuat data kualitas udara: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
