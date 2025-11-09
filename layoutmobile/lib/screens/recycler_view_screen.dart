import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class RecyclerViewScreen extends StatefulWidget {
  const RecyclerViewScreen({super.key});

  @override
  State<RecyclerViewScreen> createState() => _RecyclerViewScreenState();
}

class _RecyclerViewScreenState extends State<RecyclerViewScreen> {
  // Controller untuk scroll
  final ScrollController _scrollController = ScrollController();
  
  // Data untuk list
  final List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;
  static const int _perPage = 20;

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    
    // Tambah listener untuk scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreItems();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Fungsi untuk memuat data tambahan
  Future<void> _loadMoreItems() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    // Simulasi pengambilan data dari API/database
    await Future.delayed(const Duration(seconds: 1));
    
    final newItems = List.generate(_perPage, (index) {
      final id = _items.length + index + 1;
      return {
        'id': id,
        'title': 'Item $id',
        'description': 'Deskripsi untuk item $id. ' 
            'Ini adalah contoh teks deskripsi yang lebih panjang untuk menunjukkan ' 
            'bagaimana teks yang panjang ditangani dalam item list.',
        'date': '${DateTime.now().subtract(Duration(days: id)).day}/' 
                '${DateTime.now().subtract(Duration(days: id)).month}/' 
                '${DateTime.now().subtract(Duration(days: id)).year}',
        'isPinned': id % 5 == 0, // Setiap item kelima akan di-pin
        'hasAttachment': id % 3 == 0, // Setiap item ketiga memiliki lampiran
      };
    });

    setState(() {
      _items.addAll(newItems);
      _isLoading = false;
    });
  }

  // Fungsi untuk me-refresh data
  Future<void> _refresh() async {
    setState(() {
      _items.clear();
    });
    
    await _loadMoreItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecyclerView Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _items.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _items.length + 1, // +1 untuk loading indicator
                  itemBuilder: (context, index) {
                    // Tampilkan loading indicator di bagian bawah
                    if (index == _items.length) {
                      return _buildLoadingIndicator();
                    }
                    
                    final item = _items[index];
                    
                    // Untuk item yang di-pin, tampilkan dengan gaya berbeda
                    if (item['isPinned'] as bool) {
                      return _buildPinnedItem(item, index);
                    }
                    
                    return _buildListItem(item, index);
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        tooltip: 'Scroll ke atas',
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  // Widget untuk menampilkan loading indicator
  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _items.isEmpty
                ? const Text('Tidak ada data')
                : const Text('Tidak ada data lagi'),
      ),
    );
  }

  // Widget untuk menampilkan item yang di-pin
  Widget _buildPinnedItem(Map<String, dynamic> item, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 12.0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Text(
                          'PINNED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item['date'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                _buildItemContent(item),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan item biasa
  Widget _buildListItem(Map<String, dynamic> item, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: _buildItemContent(item),
          ),
        ),
      ),
    );
  }

  // Widget untuk konten item (digunakan oleh kedua jenis item)
  Widget _buildItemContent(Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        // Aksi ketika item ditekan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda memilih: ${item['title']}')),
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar/Icon
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.primaries[item['id'] % Colors.primaries.length],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      item['id'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                // Konten
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        item['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Footer dengan aksi
                      Row(
                        children: [
                          Text(
                            item['date'],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Spacer(),
                          if (item['hasAttachment'] as bool)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.attach_file,
                                size: 16.0,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14.0,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
