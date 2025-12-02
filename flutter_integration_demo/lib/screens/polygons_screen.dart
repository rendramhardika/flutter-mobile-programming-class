import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

class PolygonsScreen extends StatefulWidget {
  const PolygonsScreen({super.key});

  @override
  State<PolygonsScreen> createState() => _PolygonsScreenState();
}

class _PolygonsScreenState extends State<PolygonsScreen> {
  LatLng _initialCenter = LocationService.defaultLocation;
  bool _isLoadingLocation = true;
  
  // List untuk menyimpan polygon yang dibuat user
  final List<Polygon> _userPolygons = [];
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
    print('🔷 Mulai menggambar polygon');
  }

  void _finishDrawing() {
    if (_currentPoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal 3 titik untuk membuat polygon')),
      );
      return;
    }

    final colors = [
      Colors.purple.withValues(alpha: 0.3),
      Colors.teal.withValues(alpha: 0.3),
      Colors.orange.withValues(alpha: 0.3),
      Colors.pink.withValues(alpha: 0.3),
    ];
    final borderColors = [Colors.purple, Colors.teal, Colors.orange, Colors.pink];
    final colorIndex = _userPolygons.length % colors.length;

    final newPolygon = Polygon(
      points: List.from(_currentPoints),
      color: colors[colorIndex],
      borderColor: borderColors[colorIndex],
      borderStrokeWidth: 3.0,
    );

    setState(() {
      _userPolygons.add(newPolygon);
      _currentPoints.clear();
      _isDrawing = false;
    });

    print('✅ Polygon selesai dibuat:');
    print('   Jumlah points: ${newPolygon.points.length}');
    print('   Warna: ${borderColors[colorIndex]}');
    print('   Total polygons: ${_userPolygons.length}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Polygon dengan ${newPolygon.points.length} titik berhasil ditambahkan')),
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
    final defaultPolygons = [
      // Area 1 - Merah (Sekitar Merdeka Walk)
      Polygon(
        points: [
          const LatLng(3.5920, 98.6680),
          const LatLng(3.5920, 98.6760),
          const LatLng(3.5980, 98.6760),
          const LatLng(3.5980, 98.6680),
        ],
        color: Colors.red.withValues(alpha: 0.3),
        borderColor: Colors.red,
        borderStrokeWidth: 3.0,
      ),
      // Area 2 - Biru (Sekitar Istana Maimun)
      Polygon(
        points: [
          const LatLng(3.5850, 98.6700),
          const LatLng(3.5850, 98.6780),
          const LatLng(3.5910, 98.6780),
          const LatLng(3.5910, 98.6700),
        ],
        color: Colors.blue.withValues(alpha: 0.3),
        borderColor: Colors.blue,
        borderStrokeWidth: 3.0,
      ),
      // Area 3 - Hijau (Bentuk segitiga - Sekitar Masjid Raya)
      Polygon(
        points: [
          const LatLng(3.5880, 98.6720),
          const LatLng(3.5920, 98.6750),
          const LatLng(3.5880, 98.6780),
        ],
        color: Colors.green.withValues(alpha: 0.3),
        borderColor: Colors.green,
        borderStrokeWidth: 3.0,
      ),
    ];

    // Polygon yang sedang digambar (preview)
    final currentPolygon = _currentPoints.length >= 3
        ? Polygon(
            points: _currentPoints,
            color: Colors.green.withValues(alpha: 0.3),
            borderColor: Colors.green,
            borderStrokeWidth: 3.0,
          )
        : null;

    // Gabungkan semua polygons
    final allPolygons = [
      ...defaultPolygons,
      ..._userPolygons,
      if (currentPolygon != null) currentPolygon,
    ];

    // Markers untuk points saat drawing
    final drawingMarkers = _currentPoints
        .map((point) => Marker(
              point: point,
              width: 20,
              height: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isDrawing 
            ? 'Drawing... (${_currentPoints.length} points)' 
            : 'Polygons (${_userPolygons.length} ditambahkan)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (!_isDrawing && _userPolygons.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Hapus semua polygon',
              onPressed: () {
                setState(() {
                  _userPolygons.clear();
                });
                print('🗑️ Semua user polygons dihapus');
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
                    PolygonLayer(polygons: allPolygons),
                    if (_isDrawing) MarkerLayer(markers: drawingMarkers),
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
                                  icon: const Icon(Icons.pentagon_outlined),
                                  label: const Text('Gambar Polygon'),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 48),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap tombol untuk mulai, lalu tap pada peta untuk menambah titik (min. 3)',
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
