import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/news_model.dart';

class NewsService {
  /// Get environment news in Indonesian
  static Future<NewsResponse> getEnvironmentNews({
    String? cityName,
    int pageSize = 10,
    int page = 1,
  }) async {
    // Search for environment-related keywords in Indonesian
    // If cityName is provided, include it in the search
    final environmentKeywords = 'lingkungan OR iklim OR "perubahan iklim" OR "kualitas udara" OR polusi OR "energi terbarukan"';
    final query = cityName != null && cityName.isNotEmpty
        ? '$cityName '
        : '';
    
    print('📰 News API Query: $query');
    
    final url = Uri.parse(
      '${ApiConfig.newsApiBaseUrl}/everything?'
      'q=$query&'
      'language=id&'
      'sortBy=publishedAt&'
      'pageSize=$pageSize&'
      'page=$page&'
      'apiKey=${ApiConfig.newsApiKey}',
    );

    print('📰 News API URL: $url');

    try {
      final response = await http.get(url);
      print('📰 News API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📰 News API Results: ${data['totalResults']} total articles');
        return NewsResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        print('News API Error 401: ${response.body}'); // Debug
        throw Exception('API Key tidak valid. Silakan periksa konfigurasi API key Anda.');
      } else if (response.statusCode == 426) {
        print('News API Error 426: ${response.body}'); // Debug
        throw Exception('Upgrade diperlukan. Silakan periksa paket NewsAPI Anda.');
      } else if (response.statusCode == 429) {
        print('News API Error 429: ${response.body}'); // Debug
        throw Exception('Terlalu banyak permintaan. Silakan coba lagi nanti.');
      } else {
        print('News API Error ${response.statusCode}: ${response.body}'); // Debug
        throw Exception('Gagal memuat berita: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get top headlines about environment
  static Future<NewsResponse> getTopEnvironmentHeadlines({
    int pageSize = 10,
  }) async {
    final url = Uri.parse(
      '${ApiConfig.newsApiBaseUrl}/top-headlines?'
      'country=id&'
      'category=science&'
      'pageSize=$pageSize&'
      'apiKey=${ApiConfig.newsApiKey}',
    );

    print('📰 News API (Top Headlines): $url');

    try {
      final response = await http.get(url);
      print('📰 News API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return NewsResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('API Key tidak valid. Silakan periksa konfigurasi API key Anda.');
      } else {
        throw Exception('Gagal memuat berita: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
