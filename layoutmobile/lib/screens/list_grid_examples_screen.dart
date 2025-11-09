import 'package:flutter/material.dart';

class ListGridExamplesScreen extends StatelessWidget {
  const ListGridExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List & Grid View'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'List View'),
              Tab(icon: Icon(Icons.grid_on), text: 'Grid View'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ListViewExample(),
            GridViewExample(),
          ],
        ),
      ),
    );
  }
}

class ListViewExample extends StatelessWidget {
  const ListViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
            ),
            title: Text(items[index]),
            subtitle: Text('Ini adalah ${items[index].toLowerCase()}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${items[index]} diklik')),
              );
            },
          ),
        );
      },
    );
  }
}

class GridViewExample extends StatelessWidget {
  const GridViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = List.generate(12, (index) {
      final color = Colors.primaries[index % Colors.primaries.length];
      return {
        'title': 'Produk ${index + 1}',
        'price': 'Rp ${(index + 1) * 10000}',
        'color': color,
      };
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item['title']} dipilih')),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar/placeholder
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: item['color'].withOpacity(0.3),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag,
                          size: 48,
                          color: item['color'],
                        ),
                      ),
                    ),
                    // Konten
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['price'],
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 18),
                                  SizedBox(width: 4),
                                  Text('4.5'),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Baru',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
