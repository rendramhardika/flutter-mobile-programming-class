import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

class MarkersScreen extends StatefulWidget {
  const MarkersScreen({super.key});

  @override
  State<MarkersScreen> createState() => _MarkersScreenState();
}

class _MarkersScreenState extends State<MarkersScreen> {
  LatLng _initialCenter = LocationService.defaultLocation;
  bool _isLoadingLocation = true;
  
  // List untuk menyimpan marker yang dibuat user
  final List<Marker> _userMarkers = [];

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
    _showAddMarkerDialog(point);
  }

  Future<void> _showAddMarkerDialog(LatLng point) async {
    final TextEditingController labelController = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Marker'),
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
                  labelText: 'Label Marker',
                  hintText: 'Contoh: Rumah Saya',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
                autofocus: true,
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
                if (labelController.text.isNotEmpty) {
                  Navigator.pop(context, labelController.text);
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      _addMarker(point, result);
    }
  }

  void _addMarker(LatLng point, String label) {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple];
    final color = colors[_userMarkers.length % colors.length];
    
    final newMarker = Marker(
      point: point,
      width: 100,
      height: 80,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Icon(
            Icons.location_on,
            color: color,
            size: 40,
          ),
        ],
      ),
    );

    setState(() {
      _userMarkers.add(newMarker);
    });

    // Log marker yang dibuat
    print('📍 Marker ditambahkan:');
    print('   Label: $label');
    print('   Koordinat: ${point.latitude}, ${point.longitude}');
    print('   Total markers: ${_userMarkers.length}');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marker "$label" berhasil ditambahkan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Beberapa lokasi terkenal di Medan (contoh default)
    final defaultMarkers = [
      Marker(
        point: const LatLng(3.5952, 98.6722), // Merdeka Walk
        width: 100,
        height: 80,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              child: const Text(
                'Merdeka Walk',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ],
        ),
      ),
      Marker(
        point: const LatLng(3.5878, 98.6738), // Istana Maimun
        width: 100,
        height: 80,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              child: const Text(
                'Istana Maimun',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(
              Icons.location_on,
              color: Colors.blue,
              size: 40,
            ),
          ],
        ),
      ),
      Marker(
        point: const LatLng(3.5896, 98.6738), // Masjid Raya
        width: 100,
        height: 80,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              child: const Text(
                'Masjid Raya',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(
              Icons.location_on,
              color: Colors.green,
              size: 40,
            ),
          ],
        ),
      ),
    ];

    // Gabungkan default markers dengan user markers
    final allMarkers = [...defaultMarkers, ..._userMarkers];

    return Scaffold(
      appBar: AppBar(
        title: Text('Markers (${_userMarkers.length} ditambahkan)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_userMarkers.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Hapus semua marker',
              onPressed: () {
                setState(() {
                  _userMarkers.clear();
                });
                print('🗑️ Semua user markers dihapus');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua marker dihapus')),
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
                    initialZoom: 12.0,
                    onTap: _onMapTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.flutter_integration_demo',
                    ),
                    MarkerLayer(markers: allMarkers),
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
                              'Tap pada peta untuk menambah marker',
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
