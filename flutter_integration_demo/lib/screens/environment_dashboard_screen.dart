import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/air_quality_model.dart';
import '../models/news_model.dart';
import '../services/weather_service.dart';
import '../services/air_quality_service.dart';
import '../services/news_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/aqi_card.dart';
import '../widgets/news_list.dart';

class EnvironmentDashboardScreen extends StatefulWidget {
  const EnvironmentDashboardScreen({super.key});

  @override
  State<EnvironmentDashboardScreen> createState() =>
      _EnvironmentDashboardScreenState();
}

class _EnvironmentDashboardScreenState
    extends State<EnvironmentDashboardScreen> {
  final MapController _mapController = MapController();
  
  WeatherModel? _weather;
  AirQualityModel? _airQuality;
  List<NewsArticle> _news = [];

  bool _isLoadingWeather = true;
  bool _isLoadingAirQuality = true;
  bool _isLoadingNews = true;

  String? _weatherError;
  String? _airQualityError;
  String? _newsError;

  double _currentLat = ApiConfig.defaultLatitude;
  double _currentLon = ApiConfig.defaultLongitude;
  String _currentCity = ApiConfig.defaultCityName;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    await Future.wait([
      _loadWeather(),
      _loadAirQuality(),
      _loadNews(),
    ]);
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoadingWeather = true;
      _weatherError = null;
    });

    try {
      final weather = await WeatherService.getCurrentWeather(
        latitude: _currentLat,
        longitude: _currentLon,
      );
      setState(() {
        _weather = weather;
        _currentCity = weather.cityName;
        _isLoadingWeather = false;
      });
    } catch (e) {
      setState(() {
        _weatherError = e.toString();
        _isLoadingWeather = false;
      });
    }
  }

  Future<void> _loadAirQuality() async {
    setState(() {
      _isLoadingAirQuality = true;
      _airQualityError = null;
    });

    try {
      final airQuality = await AirQualityService.getAirQuality(
        latitude: _currentLat,
        longitude: _currentLon,
      );
      setState(() {
        _airQuality = airQuality;
        _isLoadingAirQuality = false;
      });
    } catch (e) {
      setState(() {
        _airQualityError = e.toString();
        _isLoadingAirQuality = false;
      });
    }
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoadingNews = true;
      _newsError = null;
    });

    try {
      print('Loading news for city: $_currentCity'); // Debug
      
      NewsResponse? newsResponse;
      
      try {
        // Try to load news with city filter first
        newsResponse = await NewsService.getEnvironmentNews(
          cityName: _currentCity,
          pageSize: 10,
        );
        print('News loaded with city filter: ${newsResponse.articles.length} articles'); // Debug
        
        // If no results with city filter, try without filter
        if (newsResponse.articles.isEmpty) {
          print('No news with city filter, trying without filter...'); // Debug
          newsResponse = await NewsService.getEnvironmentNews(
            cityName: null, // No city filter
            pageSize: 10,
          );
          print('News loaded without filter: ${newsResponse.articles.length} articles'); // Debug
        }
      } catch (e) {
        // If /everything endpoint fails (e.g., free tier limitation),
        // fallback to top headlines
        print('Error with /everything endpoint, trying top headlines: $e'); // Debug
        newsResponse = await NewsService.getTopEnvironmentHeadlines(pageSize: 10);
        print('News loaded from top headlines: ${newsResponse.articles.length} articles'); // Debug
      }
      
      setState(() {
        _news = newsResponse?.articles ?? [];
        _isLoadingNews = false;
      });
    } catch (e) {
      print('Error loading news: $e'); // Debug
      setState(() {
        _newsError = e.toString();
        _isLoadingNews = false;
      });
    }
  }

  Future<void> _showLocationPicker() async {
    final TextEditingController cityController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Lokasi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kota',
                  hintText: 'Contoh: Medan, Jakarta, Bandung',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Atau pilih kota populer:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _buildCityChip('Medan'),
                  _buildCityChip('Aceh'),
                  _buildCityChip('Sibolga'),
                  _buildCityChip('Padang'),
                  _buildCityChip('Jakarta'),
                  _buildCityChip('Bandung'),
                  _buildCityChip('Surabaya'),
                  _buildCityChip('Yogyakarta'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (cityController.text.isNotEmpty) {
                  Navigator.pop(context, cityController.text);
                }
              },
              child: const Text('Terapkan'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      await _changeLocation(result);
    }
  }

  Widget _buildCityChip(String city) {
    return ActionChip(
      label: Text(city),
      onPressed: () => Navigator.pop(context, city),
    );
  }

  Future<void> _changeLocation(String cityName) async {
    setState(() {
      _currentCity = cityName;
      _isLoadingWeather = true;
      _isLoadingAirQuality = true;
    });

    try {
      print('🔄 Changing location to: $cityName');
      
      // Load weather first to get coordinates
      final weather = await WeatherService.getCurrentWeatherByCity(cityName);
      
      print('📍 Got coordinates: ${weather.latitude}, ${weather.longitude}');
      
      // Update state with weather data and new coordinates
      setState(() {
        _weather = weather;
        _currentCity = weather.cityName;
        _currentLat = weather.latitude;
        _currentLon = weather.longitude;
        _isLoadingWeather = false;
      });

      // Move map to new location
      _mapController.move(
        LatLng(_currentLat, _currentLon),
        12.0, // zoom level
      );
      
      print('🗺️ Map moved to: $_currentLat, $_currentLon');

      // Load air quality using the NEW coordinates (not city name)
      try {
        print('🏭 Loading air quality for coords: $_currentLat, $_currentLon');
        final airQuality = await AirQualityService.getAirQuality(
          latitude: _currentLat,
          longitude: _currentLon,
        );
        setState(() {
          _airQuality = airQuality;
          _isLoadingAirQuality = false;
        });
      } catch (e) {
        print('❌ Air quality error: $e');
        setState(() {
          _airQualityError = e.toString();
          _isLoadingAirQuality = false;
        });
      }

      // Reload news for the new city
      await _loadNews();
      
      print('✅ Location change completed');
    } catch (e) {
      print('❌ Location change error: $e');
      setState(() {
        _weatherError = e.toString();
        _isLoadingWeather = false;
        _isLoadingAirQuality = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data untuk $cityName')),
        );
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadAllData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Lingkungan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: _showLocationPicker,
            tooltip: 'Ganti Lokasi',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Current Time and Location
            _buildHeader(),
            const SizedBox(height: 16),

            // Mini Map
            _buildMiniMap(),
            const SizedBox(height: 16),

            // Weather Card
            _buildWeatherSection(),
            const SizedBox(height: 16),

            // Air Quality Card
            _buildAirQualitySection(),
            const SizedBox(height: 16),

            // News List
            _buildNewsSection(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.eco, color: Colors.green.shade700, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentCity,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('EEEE, d MMMM yyyy • HH:mm', 'id_ID')
                        .format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniMap() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 200,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(_currentLat, _currentLon),
            initialZoom: 12.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.flutter_integration_demo',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(_currentLat, _currentLon),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherSection() {
    if (_isLoadingWeather) {
      return _buildLoadingCard('Memuat data cuaca...');
    }

    if (_weatherError != null) {
      return _buildErrorCard('Cuaca', _weatherError!);
    }

    if (_weather == null) {
      return _buildErrorCard('Cuaca', 'Data tidak tersedia');
    }

    return WeatherCard(weather: _weather!);
  }

  Widget _buildAirQualitySection() {
    if (_isLoadingAirQuality) {
      return _buildLoadingCard('Memuat data kualitas udara...');
    }

    if (_airQualityError != null) {
      return _buildErrorCard('Kualitas Udara', _airQualityError!);
    }

    if (_airQuality == null) {
      return _buildErrorCard('Kualitas Udara', 'Data tidak tersedia');
    }

    return AqiCard(airQuality: _airQuality!);
  }

  Widget _buildNewsSection() {
    if (_isLoadingNews) {
      return _buildLoadingCard('Memuat berita...');
    }

    if (_newsError != null) {
      return _buildErrorCard('Berita', _newsError!);
    }

    return NewsList(
      articles: _news,
      cityName: _currentCity,
    );
  }

  Widget _buildLoadingCard(String message) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String title, String error) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Gagal Memuat $title',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _refreshData,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
