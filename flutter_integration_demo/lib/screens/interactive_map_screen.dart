import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

class MarkerData {
  final LatLng position;
  final String description;

  MarkerData({required this.position, required this.description});
}

class InteractiveMapScreen extends StatefulWidget {
  const InteractiveMapScreen({super.key});

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> {
  final List<MarkerData> _markerDataList = [];
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

  Future<void> _showAddMarkerDialog(LatLng position) async {
    final TextEditingController controller = TextEditingController();
    
    final description = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Marker'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Keterangan',
              hintText: 'Masukkan keterangan untuk marker ini',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (description != null && description.isNotEmpty) {
      setState(() {
        _markerDataList.add(
          MarkerData(position: position, description: description),
        );
      });
    }
  }

  void _showMarkerInfo(MarkerData markerData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Info Marker'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Keterangan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(markerData.description),
              const SizedBox(height: 16),
              const Text(
                'Koordinat:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Lat: ${markerData.position.latitude.toStringAsFixed(6)}\nLng: ${markerData.position.longitude.toStringAsFixed(6)}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  List<Marker> _buildMarkers() {
    return _markerDataList.map((markerData) {
      return Marker(
        point: markerData.position,
        width: 200,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(markerData),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  markerData.description,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
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
      );
    }).toList();
  }

  void _clearMarkers() {
    setState(() {
      _markerDataList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Map'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _markerDataList.isEmpty ? null : _clearMarkers,
            tooltip: 'Clear all markers',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal.shade50,
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tap pada peta untuk menambah marker. Total: ${_markerDataList.length}',
                    style: TextStyle(color: Colors.teal.shade900),
                  ),
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
                        Text('Memuat lokasi Anda...'),
                      ],
                    ),
                  )
                : FlutterMap(
                    options: MapOptions(
                      initialCenter: _initialCenter,
                      initialZoom: 13.0,
                      onTap: (tapPosition, point) {
                        _showAddMarkerDialog(point);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.flutter_map',
                      ),
                      MarkerLayer(markers: _buildMarkers()),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
