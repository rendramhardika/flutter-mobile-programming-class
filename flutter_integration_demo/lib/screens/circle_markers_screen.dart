import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

class CircleMarkersScreen extends StatefulWidget {
  const CircleMarkersScreen({super.key});

  @override
  State<CircleMarkersScreen> createState() => _CircleMarkersScreenState();
}

class _CircleMarkersScreenState extends State<CircleMarkersScreen> {
  LatLng _initialCenter = LocationService.defaultLocation;
  bool _isLoadingLocation = true;
  
  // List untuk menyimpan circle marker yang dibuat user
  final List<CircleMarker> _userCircles = [];

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

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    _showAddCircleDialog(point);
  }

  Future<void> _showAddCircleDialog(LatLng point) async {
    final TextEditingController radiusController = TextEditingController(text: '100');
    final TextEditingController labelController = TextEditingController();
    
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Circle Marker'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Koordinat: ${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  labelText: 'Label (opsional)',
                  hintText: 'Contoh: Area Parkir',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: radiusController,
                decoration: const InputDecoration(
                  labelText: 'Radius (pixel)',
                  hintText: '50-200',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.radio_button_unchecked),
                ),
                keyboardType: TextInputType.number,
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
                final radius = double.tryParse(radiusController.text) ?? 100;
                Navigator.pop(context, {
                  'label': labelController.text,
                  'radius': radius,
                });
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      _addCircle(point, result['label'] as String, result['radius'] as double);
    }
  }

  void _addCircle(LatLng point, String label, double radius) {
    final colors = [
      Colors.purple.withValues(alpha: 0.3),
      Colors.teal.withValues(alpha: 0.3),
      Colors.orange.withValues(alpha: 0.3),
      Colors.pink.withValues(alpha: 0.3),
    ];
    final borderColors = [Colors.purple, Colors.teal, Colors.orange, Colors.pink];
    final colorIndex = _userCircles.length % colors.length;

    final newCircle = CircleMarker(
      point: point,
      color: colors[colorIndex],
      borderColor: borderColors[colorIndex],
      borderStrokeWidth: 3.0,
      radius: radius,
    );

    setState(() {
      _userCircles.add(newCircle);
    });

    // Log circle yang dibuat
    print('🔵 Circle Marker ditambahkan:');
    print('   Label: ${label.isEmpty ? "(tanpa label)" : label}');
    print('   Koordinat: ${point.latitude}, ${point.longitude}');
    print('   Radius: $radius px');
    print('   Warna: ${borderColors[colorIndex]}');
    print('   Total circles: ${_userCircles.length}');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Circle marker dengan radius $radius px berhasil ditambahkan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultCircles = [
      CircleMarker(
        point: const LatLng(3.5952, 98.6722), // Merdeka Walk
        color: Colors.red.withValues(alpha: 0.3),
        borderColor: Colors.red,
        borderStrokeWidth: 3.0,
        radius: 100, // radius dalam pixel
      ),
      CircleMarker(
        point: const LatLng(3.5878, 98.6738), // Istana Maimun
        color: Colors.blue.withValues(alpha: 0.3),
        borderColor: Colors.blue,
        borderStrokeWidth: 3.0,
        radius: 80,
      ),
      CircleMarker(
        point: const LatLng(3.5896, 98.6738), // Masjid Raya
        color: Colors.green.withValues(alpha: 0.3),
        borderColor: Colors.green,
        borderStrokeWidth: 3.0,
        radius: 120,
      ),
      CircleMarker(
        point: const LatLng(3.5878, 98.6738), // Inner circle
        color: Colors.orange.withValues(alpha: 0.5),
        borderColor: Colors.orange,
        borderStrokeWidth: 2.0,
        radius: 40,
      ),
    ];

    final markers = [
      Marker(
        point: const LatLng(3.5952, 98.6722),
        child: const Icon(Icons.location_on, color: Colors.red, size: 30),
      ),
      Marker(
        point: const LatLng(3.5878, 98.6738),
        child: const Icon(Icons.location_on, color: Colors.blue, size: 30),
      ),
      Marker(
        point: const LatLng(3.5896, 98.6738),
        child: const Icon(Icons.location_on, color: Colors.green, size: 30),
      ),
    ];

    // Gabungkan semua circles
    final allCircles = [...defaultCircles, ..._userCircles];

    return Scaffold(
      appBar: AppBar(
        title: Text('Circle Markers (${_userCircles.length} ditambahkan)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_userCircles.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Hapus semua circle',
              onPressed: () {
                setState(() {
                  _userCircles.clear();
                });
                print('🗑️ Semua user circles dihapus');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua circle dihapus')),
                );
              },
            ),
        ],
      ),
      body: _isLoadingLocation
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
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: _initialCenter,
                    initialZoom: 11.5,
                    onTap: _onMapTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.flutter_integration_demo',
                    ),
                    CircleLayer(circles: allCircles),
                    MarkerLayer(markers: markers),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Tap pada peta untuk menambah circle marker',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
