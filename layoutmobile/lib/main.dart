import 'package:flutter/material.dart';
import 'screens/layout_examples_screen.dart';
import 'screens/layout_transition_guide.dart';
import 'screens/list_grid_examples_screen.dart';
import 'screens/canonical_layout_screen.dart';
import 'screens/recycler_view_screen.dart';
import 'screens/instagram_timeline_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Layout Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Layout Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flutter Layout Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Tombol untuk Layout Examples
            _buildMenuButton(
              context: context,
              text: 'View Layout Examples',
              icon: Icons.dashboard,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LayoutExamplesScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Tombol untuk Layout Transition Guide
            _buildMenuButton(
              context: context,
              text: 'Layout Transition Guide',
              icon: Icons.compare_arrows,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LayoutTransitionGuide(),
                ),
              ),
              isOutlined: true,
            ),
            const SizedBox(height: 12),
            // Tombol untuk List & Grid View
            _buildMenuButton(
              context: context,
              text: 'List & Grid View',
              icon: Icons.view_list,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListGridExamplesScreen(),
                ),
              ),
              isOutlined: true,
            ),
            const SizedBox(height: 12),
            // Tombol untuk Canonical Layout
            _buildMenuButton(
              context: context,
              text: 'Canonical Layout',
              icon: Icons.view_quilt,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CanonicalLayoutScreen(),
                ),
              ),
              isOutlined: true,
            ),
            const SizedBox(height: 12),
            // Tombol untuk RecyclerView
            _buildMenuButton(
              context: context,
              text: 'RecyclerView',
              icon: Icons.list_alt,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecyclerViewScreen(),
                ),
              ),
              isOutlined: true,
            ),
            const SizedBox(height: 12),
            // Tombol untuk Instagram Timeline
            _buildMenuButton(
              context: context,
              text: 'Instagram Timeline',
              icon: Icons.photo_library,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InstagramTimelineScreen(),
                ),
              ),
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method untuk membuat tombol menu
  Widget _buildMenuButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: 250,
      child: isOutlined 
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(
                text,
                style: const TextStyle(fontSize: 15),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(
                text,
                style: const TextStyle(fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
    );
  }
}
