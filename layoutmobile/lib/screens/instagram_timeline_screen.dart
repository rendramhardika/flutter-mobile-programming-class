import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:developer' as developer;

class InstagramTimelineScreen extends StatefulWidget {
  const InstagramTimelineScreen({super.key});

  @override
  State<InstagramTimelineScreen> createState() => _InstagramTimelineScreenState();
}

class _InstagramTimelineScreenState extends State<InstagramTimelineScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _posts = [];
  bool _isLoading = false;
  static const int _perPage = 5;
  final _random = math.Random();
  
  // Set untuk melacak view yang sudah di-recycle
  final Set<int> _recycledViews = <int>{};
  
  // Flag untuk menampilkan overlay debug info
  bool _showDebugOverlay = false;

  // Variable untuk throttle log scroll
  DateTime? _lastLogTime;
  
  @override
  void initState() {
    super.initState();
    developer.log('InstagramTimelineScreen initialized');
    _loadMorePosts();
    
    _scrollController.addListener(() {
      // Hanya log setiap 500ms untuk mengurangi spam log
      final now = DateTime.now();
      if (_lastLogTime == null || now.difference(_lastLogTime!).inMilliseconds > 500) {
        developer.log('Scroll position: ${_scrollController.position.pixels}');
        _lastLogTime = now;
      }
      
      if (_scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent - 200) {
        developer.log('Loading more posts - near end of list');
        _loadMorePosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Fungsi untuk memuat data tambahan
  Future<void> _loadMorePosts() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    // Simulasi pengambilan data dari API
    await Future.delayed(const Duration(seconds: 1));
    
    developer.log('Loading $_perPage more posts, current count: ${_posts.length}');
    final newPosts = List.generate(_perPage, (index) {
      final id = _posts.length + index + 1;
      // Setiap item ke-4 adalah iklan
      final isAd = id % 4 == 0;
      
      // Hanya log untuk post pertama dan terakhir dalam batch untuk mengurangi spam
      if (index == 0 || index == _perPage - 1) {
        developer.log('Creating ${isAd ? "ad" : "feed"} post with id: $id');
      }
      return {
        'id': id,
        'type': isAd ? 'ad' : 'feed',
        'username': isAd ? 'sponsor_${id % 5 + 1}' : 'user_${id % 10 + 1}',
        'userAvatar': 'https://i.pravatar.cc/150?img=${id % 70}',
        'caption': isAd 
            ? 'Iklan: Produk terbaru kami! Dapatkan diskon 20% untuk pembelian pertama. #iklan #promo #diskon'
            : 'Posting foto hari ini. Menikmati hari yang cerah! #lifestyle #photo #moment ${id % 2 == 0 ? "#travel #adventure" : "#food #delicious"}',
        'likes': isAd ? _random.nextInt(500) + 100 : _random.nextInt(5000) + 500,
        'comments': isAd ? _random.nextInt(20) + 5 : _random.nextInt(100) + 10,
        'timeAgo': '${_random.nextInt(23) + 1} ${_random.nextBool() ? 'jam' : 'menit'} yang lalu',
        'imageCount': isAd ? 1 : _random.nextInt(3) + 1,
        'location': isAd ? null : _random.nextBool() ? 'Jakarta, Indonesia' : null,
      };
    });

    setState(() {
      _posts.addAll(newPosts);
      _isLoading = false;
    });
  }

  // Fungsi untuk me-refresh data
  Future<void> _refresh() async {
    setState(() {
      _posts.clear();
    });
    
    await _loadMorePosts();
  }
  
  // Fungsi untuk melacak proses recycling view
  void _logViewRecycling(int index, String viewType) {
    // Cek apakah item sudah ada di recycled views, jika sudah ada, tidak perlu log lagi
    if (_recycledViews.contains(index)) {
      return;
    }
    
    developer.log('RecyclerView: recycling view at index $index, type: $viewType');
    developer.log('  - Visible range: ${_getVisibleItemRange()}');
    
    // Tambahkan index ke set recycled views tanpa setState
    // Kita tidak bisa memanggil setState selama proses build
    _recycledViews.add(index);
    
    // Hanya panggil setState sekali untuk setiap item yang baru di-recycle
    // untuk menghindari infinite loop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          // This empty setState will trigger a rebuild with the updated _recycledViews
        });
      }
    });
  }
  
  // Mendapatkan range item yang terlihat
  String _getVisibleItemRange() {
    if (_scrollController.positions.isEmpty) return "No positions attached";
    
    final double viewportHeight = _scrollController.position.viewportDimension;
    final double scrollOffset = _scrollController.position.pixels;
    
    // Estimasi item yang terlihat (asumsi rata-rata tinggi item 400px)
    final double avgItemHeight = 400.0;
    final int firstVisible = (scrollOffset / avgItemHeight).floor();
    final int lastVisible = ((scrollOffset + viewportHeight) / avgItemHeight).ceil();
    
    return "$firstVisible to $lastVisible";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Instagram Timeline',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Debug button to show RecyclerView implementation logs
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              developer.log('===== RecyclerView Debug Info =====');
              developer.log('Total posts: ${_posts.length}');
              developer.log('Feed posts: ${_posts.where((p) => p['type'] == 'feed').length}');
              developer.log('Ad posts: ${_posts.where((p) => p['type'] == 'ad').length}');
              developer.log('Current scroll position: ${_scrollController.position.pixels}');
              developer.log('Max scroll extent: ${_scrollController.position.maxScrollExtent}');
              
              // Show a snackbar to indicate logs were printed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('RecyclerView logs printed to console'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Debug RecyclerView',
          ),
          // Toggle debug overlay
          IconButton(
            icon: Icon(_showDebugOverlay ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _showDebugOverlay = !_showDebugOverlay;
              });
            },
            tooltip: 'Toggle debug overlay',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Stack(
        children: [
          _posts.isEmpty && _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                controller: _scrollController,
                itemCount: _posts.length + 1, // +1 untuk loading indicator
                itemBuilder: (context, index) {
                  // Tampilkan loading indicator di bagian bawah
                  if (index == _posts.length) {
                    // Log hanya sekali saat loading indicator dibuat
                    if (_isLoading) {
                      developer.log('Building loading indicator at index $index');
                    }
                    return _buildLoadingIndicator();
                  }
                  
                  final post = _posts[index];
                  // Log hanya untuk item pertama dan setiap kelipatan 5 untuk mengurangi spam
                  if (index == 0 || index % 5 == 0) {
                    developer.log('Building post at index $index, type: ${post['type']}, id: ${post['id']}');
                  }
                  
                  // Tampilkan post sesuai tipenya
                  if (post['type'] == 'ad') {
                    _logViewRecycling(index, 'ad');
                    return _buildAdPost(post);
                  } else {
                    _logViewRecycling(index, 'feed');
                    return _buildFeedPost(post);
                  }
                },
              ),
            ),
            // Debug overlay
            if (_showDebugOverlay)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'RecyclerView Debug Info',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total posts: ${_posts.length} (${_posts.where((p) => p["type"] == "feed").length} feed, ${_posts.where((p) => p["type"] == "ad").length} ads)',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Recycled views: ${_recycledViews.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Visible range: ${_getVisibleItemRange()}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Green border = recycled feed, Orange border = recycled ad',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
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
            : _posts.isEmpty
                ? const Text('Tidak ada data')
                : const Text('Tidak ada data lagi'),
      ),
    );
  }

  // Widget untuk menampilkan post feed
  Widget _buildFeedPost(Map<String, dynamic> post) {
    final int index = _posts.indexWhere((p) => p['id'] == post['id']);
    final bool isRecycled = _recycledViews.contains(index);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: isRecycled ? Border.all(color: Colors.green, width: 2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header post (avatar, username, more button)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(post['userAvatar']),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['username'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    if (post['location'] != null)
                      Text(
                        post['location'],
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_vert),
              ],
            ),
          ),
          
          // Image content
          SizedBox(
            height: 300,
            child: PageView.builder(
              itemCount: post['imageCount'],
              itemBuilder: (context, imageIndex) {
                return Container(
                  color: Colors.primaries[post['id'] % Colors.primaries.length].withOpacity(0.3),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.primaries[post['id'] % Colors.primaries.length],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.favorite_border, size: 28),
                const SizedBox(width: 16.0),
                const Icon(Icons.chat_bubble_outline, size: 24),
                const SizedBox(width: 16.0),
                const Icon(Icons.send_outlined, size: 24),
                const Spacer(),
                const Icon(Icons.bookmark_border, size: 28),
              ],
            ),
          ),
          
          // Like count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              '${post['likes']} suka',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 13.0,
                ),
                children: [
                  TextSpan(
                    text: post['username'] + ' ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: post['caption'],
                  ),
                ],
              ),
            ),
          ),
          
          // View all comments
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Text(
              'Lihat semua ${post['comments']} komentar',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13.0,
              ),
            ),
          ),
          
          // Time ago
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Text(
              post['timeAgo'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11.0,
              ),
            ),
          ),
          
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }

  // Widget untuk menampilkan post iklan
  Widget _buildAdPost(Map<String, dynamic> post) {
    final int index = _posts.indexWhere((p) => p['id'] == post['id']);
    final bool isRecycled = _recycledViews.contains(index);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: isRecycled ? Border.all(color: Colors.orange, width: 2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header post (avatar, username, sponsored tag, more button)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(post['userAvatar']),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: const Text(
                            'Sponsored',
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_vert),
              ],
            ),
          ),
          
          // Ad image content
          Container(
            height: 300,
            color: Colors.amber.withOpacity(0.3),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: Icon(
                    Icons.shopping_bag,
                    size: 100,
                    color: Colors.amber[700],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka halaman produk')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    child: const Text('Beli Sekarang'),
                  ),
                ),
              ],
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.favorite_border, size: 28),
                const SizedBox(width: 16.0),
                const Icon(Icons.chat_bubble_outline, size: 24),
                const SizedBox(width: 16.0),
                const Icon(Icons.send_outlined, size: 24),
                const Spacer(),
                const Icon(Icons.bookmark_border, size: 28),
              ],
            ),
          ),
          
          // Like count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              '${post['likes']} suka',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Caption with ad tag
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 13.0,
                ),
                children: [
                  TextSpan(
                    text: post['username'] + ' ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: post['caption'],
                  ),
                ],
              ),
            ),
          ),
          
          // View all comments
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Text(
              'Lihat semua ${post['comments']} komentar',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13.0,
              ),
            ),
          ),
          
          // Time ago
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Text(
              post['timeAgo'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11.0,
              ),
            ),
          ),
          
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
