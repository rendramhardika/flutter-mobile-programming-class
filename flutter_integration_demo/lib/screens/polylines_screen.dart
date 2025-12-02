import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

class PolylinesScreen extends StatefulWidget {
  const PolylinesScreen({super.key});

  @override
  State<PolylinesScreen> createState() => _PolylinesScreenState();
}

class _PolylinesScreenState extends State<PolylinesScreen> {
  LatLng _initialCenter = LocationService.defaultLocation;
  bool _isLoadingLocation = true;
  
  // List untuk menyimpan polyline yang dibuat user
  final List<Polyline> _userPolylines = [];
  final List<LatLng> _currentPoints = [];
  bool _isDrawing = false;

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
    if (_isDrawing) {
      setState(() {
        _currentPoints.add(point);
      });
      print('📍 Point ditambahkan: ${point.latitude}, ${point.longitude}');
      print('   Total points: ${_currentPoints.length}');
    }
  }

  void _startDrawing() {
    setState(() {
      _isDrawing = true;
      _currentPoints.clear();
    });
    print('✏️ Mulai menggambar polyline');
  }

  void _finishDrawing() {
    if (_currentPoints.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal 2 titik untuk membuat polyline')),
      );
      return;
    }

    final colors = [Colors.purple, Colors.teal, Colors.orange, Colors.pink];
    final color = colors[_userPolylines.length % colors.length];

    final newPolyline = Polyline(
      points: List.from(_currentPoints),
      color: color,
      strokeWidth: 4.0,
    );

    setState(() {
      _userPolylines.add(newPolyline);
      _currentPoints.clear();
      _isDrawing = false;
    });

    print('✅ Polyline selesai dibuat:');
    print('   Jumlah points: ${newPolyline.points.length}');
    print('   Warna: $color');
    print('   Total polylines: ${_userPolylines.length}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Polyline dengan ${newPolyline.points.length} titik berhasil ditambahkan')),
    );
  }

  void _cancelDrawing() {
    setState(() {
      _currentPoints.clear();
      _isDrawing = false;
    });
    print('❌ Drawing dibatalkan');
  }

  @override
  Widget build(BuildContext context) {
    // Rute dari Merdeka Walk ke Istana Maimun ke Masjid Raya (contoh default)
    final defaultPolylines = [
      Polyline(
        points: [
          const LatLng(3.5952, 98.6722), // Merdeka Walk
          const LatLng(3.5915, 98.6730),
          const LatLng(3.5878, 98.6738), // Istana Maimun
        ],
        color: Colors.blue,
        strokeWidth: 4.0,
      ),
      Polyline(
        points: [
          const LatLng(3.5878, 98.6738), // Istana Maimun
          const LatLng(3.5887, 98.6738),
          const LatLng(3.5896, 98.6738), // Masjid Raya
        ],
        color: Colors.red,
        strokeWidth: 4.0,
        borderColor: Colors.white,
        borderStrokeWidth: 2.0,
      ),
    ];

    final markers = [
      Marker(
        point: const LatLng(3.5952, 98.6722),
        child: const Icon(Icons.location_on, color: Colors.green, size: 40),
      ),
      Marker(
        point: const LatLng(3.5878, 98.6738),
        child: const Icon(Icons.location_on, color: Colors.orange, size: 40),
      ),
      Marker(
        point: const LatLng(3.5896, 98.6738),
        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
      ),
    ];

    // Polyline yang sedang digambar (preview)
    final currentPolyline = _currentPoints.isNotEmpty
        ? Polyline(
            points: _currentPoints,
            color: Colors.green,
            strokeWidth: 4.0,
          )
        : null;

    // Gabungkan semua polylines
    final allPolylines = [
      ...defaultPolylines,
      ..._userPolylines,
      if (currentPolyline != null) currentPolyline,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isDrawing 
            ? 'Drawing... (${_currentPoints.length} points)' 
            : 'Polylines (${_userPolylines.length} ditambahkan)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (!_isDrawing && _userPolylines.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Hapus semua polyline',
              onPressed: () {
                setState(() {
                  _userPolylines.clear();
                });
                print('🗑️ Semua user polylines dihapus');
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
                    PolylineLayer(polylines: allPolylines),
                    MarkerLayer(markers: markers),
                  ],
                ),
                // Control buttons
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _isDrawing
                      ? Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _finishDrawing,
                                icon: const Icon(Icons.check),
                                label: Text('Selesai (${_currentPoints.length})'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: _cancelDrawing,
                              icon: const Icon(Icons.close),
                              label: const Text('Batal'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _startDrawing,
                                  icon: const Icon(Icons.edit_road),
                                  label: const Text('Gambar Polyline'),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 48),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap tombol untuk mulai, lalu tap pada peta untuk menambah titik',
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                  textAlign: TextAlign.center,
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
