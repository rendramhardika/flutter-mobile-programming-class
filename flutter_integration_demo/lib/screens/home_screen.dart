import 'package:flutter/material.dart';
import 'basic_map_screen.dart';
import 'markers_screen.dart';
import 'polylines_screen.dart';
import 'polygons_screen.dart';
import 'custom_tiles_screen.dart';
import 'circle_markers_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrasi OpenStreetMap'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Pilih fitur yang ingin dicoba:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildFeatureCard(
            context,
            title: '1. Basic Map',
            description: 'Peta dasar dengan zoom & pan',
            icon: Icons.map,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BasicMapScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            title: '2. Markers',
            description: 'Menambahkan pin/marker di lokasi tertentu',
            icon: Icons.location_on,
            color: Colors.red,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MarkersScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            title: '3. Polylines',
            description: 'Menggambar garis/rute di peta',
            icon: Icons.route,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PolylinesScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            title: '4. Polygons',
            description: 'Menggambar area/wilayah',
            icon: Icons.pentagon,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PolygonsScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            title: '5. Circle Markers',
            description: 'Marker berbentuk lingkaran dengan radius',
            icon: Icons.circle,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CircleMarkersScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            title: '6. Custom Tiles',
            description: 'Menggunakan tile provider berbeda',
            icon: Icons.layers,
            color: Colors.indigo,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CustomTilesScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
