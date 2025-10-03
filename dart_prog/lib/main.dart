import 'package:flutter/material.dart';
import 'flutter_fundamentals/01_basic_widgets.dart';
import 'flutter_fundamentals/02_layout_widgets.dart';
import 'flutter_fundamentals/03_stateful_widgets.dart';
import 'flutter_fundamentals/04_navigation_and_routing.dart';
import 'practical_examples/01_todo_app.dart';
import 'practical_examples/02_calculator_app.dart';

void main() {
  runApp(const DartFlutterLearningApp());
}

class DartFlutterLearningApp extends StatelessWidget {
  const DartFlutterLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart & Flutter Learning',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dart & Flutter Learning'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.school,
                      size: 64,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Selamat Datang di Pembelajaran Dart & Flutter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pelajari dasar-dasar pemrograman Dart dan pengembangan aplikasi Flutter',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Dart Fundamentals Section
            const Text(
              'DASAR-DASAR DART',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            
            _buildMenuCard(
              context,
              'Variabel dan Tipe Data',
              'Pelajari tentang variabel, tipe data, dan null safety',
              Icons.data_object,
              Colors.blue,
              () => _showDartExampleDialog(context, 'dart_fundamentals/01_variables_and_types.dart', 'Variabel dan Tipe Data'),
            ),
            
            _buildMenuCard(
              context,
              'Fungsi dan Kontrol Alur',
              'Pelajari tentang fungsi, if-else, loops, dan exception handling',
              Icons.account_tree,
              Colors.green,
              () => _showDartExampleDialog(context, 'dart_fundamentals/02_functions_and_control_flow.dart', 'Fungsi dan Kontrol Alur'),
            ),
            
            _buildMenuCard(
              context,
              'Classes dan OOP',
              'Pelajari tentang class, inheritance, abstract class, dan mixins',
              Icons.class_,
              Colors.orange,
              () => _showDartExampleDialog(context, 'dart_fundamentals/03_classes_and_oop.dart', 'Classes dan OOP'),
            ),
            
            const SizedBox(height: 20),
            
            // Flutter Fundamentals Section
            const Text(
              'DASAR-DASAR FLUTTER',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            
            _buildMenuCard(
              context,
              'Widget Dasar',
              'Pelajari tentang Text, Button, Image, dan Input widgets',
              Icons.widgets,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BasicWidgetsDemo()),
              ),
            ),
            
            _buildMenuCard(
              context,
              'Layout Widgets',
              'Pelajari tentang Row, Column, Stack, ListView, dan GridView',
              Icons.view_quilt,
              Colors.teal,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LayoutWidgetsDemo()),
              ),
            ),
            
            _buildMenuCard(
              context,
              'StatefulWidget',
              'Pelajari tentang state management dan lifecycle',
              Icons.refresh,
              Colors.indigo,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatefulWidgetsDemo()),
              ),
            ),
            
            _buildMenuCard(
              context,
              'Navigation & Routing',
              'Pelajari tentang navigasi antar halaman dan routing',
              Icons.navigation,
              Colors.cyan,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NavigationDemo()),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Practical Examples Section
            const Text(
              'CONTOH APLIKASI PRAKTIS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            
            _buildMenuCard(
              context,
              'Todo App',
              'Aplikasi todo list dengan CRUD operations',
              Icons.checklist,
              Colors.red,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TodoApp()),
              ),
            ),
            
            _buildMenuCard(
              context,
              'Calculator App',
              'Aplikasi kalkulator dengan operasi matematika dasar',
              Icons.calculate,
              Colors.brown,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalculatorApp()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _showDartExampleDialog(BuildContext context, String fileName, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ini adalah contoh Dart console application.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Untuk menjalankan contoh ini, gunakan terminal:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SelectableText(
                'dart run lib/$fileName',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Atau buka file tersebut di IDE dan jalankan dengan tombol Run.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Buka file lib/$fileName di IDE untuk melihat kode'),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Lihat Kode'),
          ),
        ],
      ),
    );
  }
}
