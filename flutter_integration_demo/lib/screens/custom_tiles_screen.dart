import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

class CustomTilesScreen extends StatefulWidget {
  const CustomTilesScreen({super.key});

  @override
  State<CustomTilesScreen> createState() => _CustomTilesScreenState();
}

class _CustomTilesScreenState extends State<CustomTilesScreen> {
  String _selectedTile = 'OpenStreetMap';
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

  final Map<String, String> _tileProviders = {
    'OpenStreetMap': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    'OpenTopoMap': 'https://tile.opentopomap.org/{z}/{x}/{y}.png',
    'Humanitarian': 'https://tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
    'CyclOSM': 'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Tiles'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.indigo),
                    const SizedBox(width: 8),
                    Text(
                      'Pilih Tile Provider:',
                      style: TextStyle(
                        color: Colors.indigo.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _tileProviders.keys.map((name) {
                    return ChoiceChip(
                      label: Text(name),
                      selected: _selectedTile == name,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedTile = name;
                          });
                        }
                      },
                    );
                  }).toList(),
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
                    options: MapOptions(
                      initialCenter: _initialCenter,
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: _tileProviders[_selectedTile]!,
                        userAgentPackageName: 'com.example.flutter_integration_demo',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _initialCenter,
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
        ],
      ),
    );
  }
}
