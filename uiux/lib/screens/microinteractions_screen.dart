import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MicrointeractionsScreen extends StatefulWidget {
  const MicrointeractionsScreen({super.key});

  @override
  State<MicrointeractionsScreen> createState() => _MicrointeractionsScreenState();
}

class _MicrointeractionsScreenState extends State<MicrointeractionsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isLiked = false;
  int _likeCount = 42;
  double _progressValue = 0.0;
  bool _showConfetti = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchResults = false;
  final List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _simulateLoading() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
      _animationController.forward().then((_) => _animationController.reverse());
    });
  }

  void _startProgress() {
    _progressValue = 0.0;
    _showConfetti = false;
    const oneSec = Duration(milliseconds: 100);
    Timer.periodic(oneSec, (Timer timer) {
      if (_progressValue >= 1.0) {
        timer.cancel();
        setState(() {
          _showConfetti = true;
        });
        // Hide confetti after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => _showConfetti = false);
          }
        });
      } else {
        setState(() {
          _progressValue += 0.1;
        });
      }
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _showSearchResults = false;
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _showSearchResults = true;
      _searchResults.clear();
      // Simulate search results
      for (int i = 0; i < 5; i++) {
        _searchResults.add('$query result ${i + 1}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Microinteractions & Feedback'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loading Indicator Section
            _buildSectionTitle('1. Loading & Transition'),
            const SizedBox(height: 8),
            _buildLoadingIndicator(),
            const SizedBox(height: 16),
            _buildProgressIndicator(),
            const SizedBox(height: 24),

            // Visual Feedback Section
            _buildSectionTitle('2. Visual/Audio Feedback'),
            const SizedBox(height: 8),
            _buildLikeButton(),
            const SizedBox(height: 16),
            _buildRippleEffectButton(),
            const SizedBox(height: 24),

            // Guidance Interaction Section
            _buildSectionTitle('3. Guidance Interaction'),
            const SizedBox(height: 8),
            _buildSearchBar(),
            if (_showSearchResults) _buildSearchResults(),
            const SizedBox(height: 16),
            _buildSwipeToDismissExample(),
          ],
        ),
      ),
      floatingActionButton: _showConfetti
          ? TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1.0, end: 0.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 1.0 + (1.0 - value) * 2,
                    child: const Icon(
                      Icons.celebration,
                      color: Colors.amber,
                      size: 48,
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loading Indicator',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text('Click the button to simulate loading'),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _simulateLoading,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Load Data'),
              ),
            ),
            if (_isLoading) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
              const Text('Loading your content...', textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Indicator',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _progressValue,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 8),
            Text('${(_progressValue * 100).toInt()}% Complete'),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _startProgress,
                child: const Text('Start Progress'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeButton() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Like Button with Animation',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text('Tap the heart to like'),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : null,
                        size: 32,
                      ),
                      onPressed: _toggleLike,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_likeCount',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRippleEffectButton() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ripple Effect Button',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text('Press and hold for ripple effect'),
            const SizedBox(height: 16),
            Center(
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                onTapDown: (_) {
                  HapticFeedback.lightImpact();
                },
                child: Ink(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Tap Me',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search with Auto-suggest',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _showSearchResults = false;
                            _searchResults.clear();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: _performSearch,
              onSubmitted: (_) {
                // Close keyboard on submit
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.search),
            title: Text(_searchResults[index]),
            onTap: () {
              // Close keyboard and clear search
              FocusScope.of(context).unfocus();
              _searchController.clear();
              setState(() {
                _showSearchResults = false;
                _searchResults.clear();
              });
              // Show snackbar with selected result
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selected: ${_searchResults[index]}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSwipeToDismissExample() {
    final items = List.generate(5, (index) => 'Item ${index + 1}');
    
    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Swipe to Dismiss',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text('Swipe items left or right to dismiss'),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.hourglass_empty, size: 48, color: Colors.grey),
                        const SizedBox(height: 8),
                        const Text('No items left'),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              // Reset items
                              items.clear();
                              for (int i = 0; i < 5; i++) {
                                items.add('Item ${i + 1}');
                              }
                            });
                          },
                          child: const Text('Reset Items'),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Dismissible(
                        key: Key(item),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.green,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.archive, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            items.removeAt(index);
                          });
                          
                          // Show undo snackbar
                          final snackBar = SnackBar(
                            content: Text('$item dismissed'),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                setState(() {
                                  items.insert(index, item);
                                });
                              },
                            ),
                          );
                          
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.drag_handle),
                            title: Text(item),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
