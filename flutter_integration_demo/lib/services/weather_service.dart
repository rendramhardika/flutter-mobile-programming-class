import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/weather_model.dart';

class WeatherService {
  /// Get current weather by coordinates
  static Future<WeatherModel> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      '${ApiConfig.openWeatherMapBaseUrl}/weather?'
      'lat=$latitude&'
      'lon=$longitude&'
      'appid=${ApiConfig.openWeatherMapApiKey}&'
      'units=metric&'
      'lang=id',
    );

    print('🌤️ Weather API (by coords): $url');

    try {
      final response = await http.get(url);
      print('🌤️ Weather API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('API Key tidak valid. Silakan periksa konfigurasi API key Anda.');
      } else {
        throw Exception('Gagal memuat data cuaca: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get current weather by city name
  static Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    final url = Uri.parse(
      '${ApiConfig.openWeatherMapBaseUrl}/weather?'
      'q=$cityName&'
      'appid=${ApiConfig.openWeatherMapApiKey}&'
      'units=metric&'
      'lang=id',
    );

    print('🌤️ Weather API (by city): $url');

    try {
      final response = await http.get(url);
      print('🌤️ Weather API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('API Key tidak valid. Silakan periksa konfigurasi API key Anda.');
      } else if (response.statusCode == 404) {
        throw Exception('Kota tidak ditemukan');
      } else {
        throw Exception('Gagal memuat data cuaca: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
