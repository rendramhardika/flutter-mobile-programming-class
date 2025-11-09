import 'package:flutter/material.dart';

class CanonicalLayoutScreen extends StatelessWidget {
  const CanonicalLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Canonical Layouts'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'List-Detail'),
              Tab(icon: Icon(Icons.grid_on), text: 'Master-Detail'),
              Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ListDetailLayout(),
            MasterDetailLayout(),
            DashboardLayout(),
          ],
        ),
      ),
    );
  }
}

class ListDetailLayout extends StatefulWidget {
  const ListDetailLayout({super.key});

  @override
  State<ListDetailLayout> createState() => _ListDetailLayoutState();
}

class _ListDetailLayoutState extends State<ListDetailLayout> {
  int? selectedIndex;
  final List<Map<String, dynamic>> items = List.generate(
    10,
    (index) => {
      'id': index + 1,
      'title': 'Item ${index + 1}',
      'description': 'Ini adalah deskripsi untuk Item ${index + 1}.',
      'date': '${DateTime.now().subtract(Duration(days: index)).day}/' +
              '${DateTime.now().subtract(Duration(days: index)).month}/' +
              '${DateTime.now().subtract(Duration(days: index)).year}',
      'isImportant': index % 3 == 0,
    },
  );

  @override
  void initState() {
    super.initState();
    // Pilih item pertama secara default
    if (items.isNotEmpty) {
      selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // List Panel
        Container(
          width: 300,
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.grey.shade300)),
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(),
          ),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: selectedIndex == index
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.primary,
                    child: Text(
                      '${item['id']}',
                      style: TextStyle(
                        color: selectedIndex == index
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    item['title'],
                    style: TextStyle(
                      fontWeight: selectedIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    item['date'],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: item['isImportant']
                      ? const Icon(Icons.star, color: Colors.amber)
                      : null,
                  selected: selectedIndex == index,
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              );
            },
          ),
        ),
        // Detail Panel
        Expanded(
          child: selectedIndex != null ? _buildDetailPanel(items[selectedIndex!]) : _buildEmptyState(),
        ),
      ],
    );
  }

  Widget _buildDetailPanel(Map<String, dynamic> item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (item['isImportant'])
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text('Penting', style: TextStyle(color: Colors.amber)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${item['id']} • ${item['date']}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const Divider(height: 32),
          Text(
            'Deskripsi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            item['description'],
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 24),
          const Text(
            'Informasi Tambahan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Status', 'Aktif'),
          _buildInfoRow('Dibuat', 'Hari ini'),
          _buildInfoRow('Kategori', 'Contoh Kategori'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                // Aksi ketika tombol ditekan
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Item'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Text(': '),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Pilih item dari daftar untuk melihat detail',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class MasterDetailLayout extends StatelessWidget {
  const MasterDetailLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 800;
        
        return isWideScreen ? _buildWideLayout() : _buildNarrowLayout(context);
      },
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        // Master Panel
        Container(
          width: 300,
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.grey.shade300)),
          ),
          child: _buildMasterList(),
        ),
        // Detail Panel
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article, size: 64, color: Colors.blue),
                SizedBox(height: 16),
                Text(
                  'Pilih item untuk melihat detail',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return _buildMasterList();
  }

  Widget _buildMasterList() {
    final List<String> items = List.generate(10, (index) => 'Item ${index + 1}');
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(items[index]),
            subtitle: Text('Detail untuk ${items[index]}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigasi ke detail screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(title: Text('Detail ${items[index]}')),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.article, size: 64, color: Colors.blue),
                          const SizedBox(height: 16),
                          Text(
                            'Detail untuk ${items[index]}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class DashboardLayout extends StatelessWidget {
  const DashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16.0),
      crossAxisCount: _calculateCrossAxisCount(context),
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      children: [
        _buildDashboardCard(
          context,
          'Statistik',
          Icons.bar_chart,
          Colors.blue,
        ),
        _buildDashboardCard(
          context,
          'Pengguna',
          Icons.people,
          Colors.green,
        ),
        _buildDashboardCard(
          context,
          'Laporan',
          Icons.assignment,
          Colors.orange,
        ),
        _buildDashboardCard(
          context,
          'Pengaturan',
          Icons.settings,
          Colors.purple,
        ),
        _buildDashboardCard(
          context,
          'Notifikasi',
          Icons.notifications,
          Colors.red,
        ),
        _buildDashboardCard(
          context,
          'Bantuan',
          Icons.help_outline,
          Colors.teal,
        ),
      ],
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 4;
    } else if (width > 800) {
      return 3;
    } else if (width > 600) {
      return 2;
    } else {
      return 1;
    }
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title diklik')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
