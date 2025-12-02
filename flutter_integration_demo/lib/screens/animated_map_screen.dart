import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

class AnimatedMapScreen extends StatefulWidget {
  const AnimatedMapScreen({super.key});

  @override
  State<AnimatedMapScreen> createState() => _AnimatedMapScreenState();
}

class _AnimatedMapScreenState extends State<AnimatedMapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  LatLng _initialCenter = LocationService.defaultLocation;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    final location = await LocationService.getLocationWithPermission(context);
    if (mounted) {
      setState(() {
        _initialCenter = location;
        _isLoadingLocation = false;
      });
    }
  }

  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Monas',
      'position': const LatLng(-6.2088, 106.8456),
      'zoom': 15.0,
    },
    {
      'name': 'Bundaran HI',
      'position': const LatLng(-6.1751, 106.8650),
      'zoom': 16.0,
    },
    {
      'name': 'Taman Mini',
      'position': const LatLng(-6.3020, 106.8970),
      'zoom': 14.0,
    },
    {
      'name': 'Ancol',
      'position': const LatLng(-6.1223, 106.8423),
      'zoom': 15.0,
    },
  ];

  int _currentLocationIndex = 0;

  void _animateToLocation(int index) {
    setState(() {
      _currentLocationIndex = index;
    });

    final location = _locations[index];
    _mapController.move(
      location['position'] as LatLng,
      location['zoom'] as double,
    );
  }

  void _nextLocation() {
    final nextIndex = (_currentLocationIndex + 1) % _locations.length;
    _animateToLocation(nextIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Movement'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.pink.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.pink),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lokasi: ${_locations[_currentLocationIndex]['name']}',
                        style: TextStyle(
                          color: Colors.pink.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: List.generate(_locations.length, (index) {
                    return ElevatedButton(
                      onPressed: () => _animateToLocation(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentLocationIndex == index
                            ? Colors.pink
                            : Colors.grey.shade300,
                        foregroundColor: _currentLocationIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Text(_locations[index]['name']),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoadingLocation
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Memuat lokasi...'),
                      ],
                    ),
                  )
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _initialCenter,
                      initialZoom: 13.0,
                    ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.flutter_map',
                ),
                MarkerLayer(
                  markers: _locations.map((loc) {
                    return Marker(
                      point: loc['position'] as LatLng,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              loc['name'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextLocation,
        child: const Icon(Icons.skip_next),
      ),
    );
  }
}
