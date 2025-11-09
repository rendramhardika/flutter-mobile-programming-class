import 'package:flutter/material.dart';

class NavigationPatternsScreen extends StatefulWidget {
  const NavigationPatternsScreen({super.key});

  @override
  State<NavigationPatternsScreen> createState() => _NavigationPatternsScreenState();
}

class _NavigationPatternsScreenState extends State<NavigationPatternsScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  bool _isRefreshing = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Navigation Patterns'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Navigation Patterns'),
                    content: const Text(
                      'This screen demonstrates different navigation patterns used in mobile applications:\n\n'
                      '• Bottom Navigation vs Drawer Menu\n'
                      '• Tab-based Navigation\n'
                      '• Gesture-based Navigation\n\n'
                      'Try interacting with the different elements to see how they work.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('CLOSE'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Bottom Nav'),
              Tab(text: 'Tab Nav'),
              Tab(text: 'Gestures'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.blue),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Navigation Demo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'user@example.com',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Home selected from drawer')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings selected from drawer')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Feedback'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help selected from drawer')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sign out selected from drawer')),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Bottom Navigation vs Hamburger Menu Tab
            _buildBottomNavVsDrawerTab(),
            
            // Tab-based Navigation Tab
            _buildTabBasedNavigationTab(),
            
            // Gesture-based Navigation Tab
            _buildGestureBasedNavigationTab(),
          ],
        ),
        bottomNavigationBar: _tabController.index == 0 ? BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ) : null,
      ),
    );
  }

  Widget _buildBottomNavVsDrawerTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bottom Navigation vs Hamburger Menu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This tab demonstrates two common navigation patterns:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              
              // Bottom Navigation Section
              const Text(
                '1. Bottom Navigation Bar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bottom navigation bars are visible at the bottom of the screen and provide quick access to top-level destinations. Try tapping the icons below.',
              ),
              const SizedBox(height: 24),
              
              // Hamburger Menu Section
              const Text(
                '2. Hamburger Menu (Drawer)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Drawer menus are hidden by default and can be opened by tapping the menu icon or by swiping from the left edge of the screen.',
              ),
              const SizedBox(height: 16),
              
              ElevatedButton.icon(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu),
                label: const Text('Open Drawer Menu'),
              ),
            ],
          ),
        ),
        
        const Divider(),
        
        // Content based on selected bottom nav item
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildSelectedBottomNavContent(),
        ),
        const SizedBox(height: 80), // Add some padding at the bottom
      ],
    ));
  }

  Widget _buildSelectedBottomNavContent() {
    switch (_selectedIndex) {
      case 0:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Home Screen',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'This is the home tab content.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Search Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is the search tab content.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      case 2:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Profile Screen',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'This is the profile tab content.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Edit Profile'),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTabBasedNavigationTab() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Photos'),
              Tab(text: 'Albums'),
              Tab(text: 'Shared'),
              Tab(text: 'For You'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Photos Tab
                GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.blue.withOpacity(0.2 + (index % 5) * 0.1),
                      child: Center(
                        child: Icon(
                          Icons.photo,
                          size: 40,
                          color: Colors.blue.withOpacity(0.5 + (index % 5) * 0.1),
                        ),
                      ),
                    );
                  },
                ),
                
                // Albums Tab
                ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        color: Colors.blue.withOpacity(0.2 + (index % 5) * 0.1),
                        child: const Icon(Icons.photo_album),
                      ),
                      title: Text('Album ${index + 1}'),
                      subtitle: Text('${(index + 1) * 5} photos'),
                      onTap: () {},
                    );
                  },
                ),
                
                // Shared Tab
                ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text('Shared Album ${index + 1}'),
                      subtitle: Text('Shared with ${(index % 3) + 2} people'),
                      trailing: const Icon(Icons.cloud_done),
                      onTap: () {},
                    );
                  },
                ),
                
                // For You Tab
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome, size: 80, color: Colors.blue),
                      const SizedBox(height: 16),
                      const Text(
                        'Memories',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your personalized memories will appear here.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Create Memory'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGestureBasedNavigationTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gesture-based Navigation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This tab demonstrates common gesture-based navigation patterns:',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: PageView(
            children: [
              // Pull to Refresh
              RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Center(
                      child: Text(
                        'Pull to Refresh',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Pull down to trigger the refresh indicator',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: _isRefreshing
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.arrow_downward, size: 40),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(
                      15,
                      (index) => ListTile(
                        title: Text('Item ${index + 1}'),
                        subtitle: Text('Pull to refresh demonstration'),
                        leading: const CircleAvatar(child: Icon(Icons.refresh)),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Swipe to Dismiss
              ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key('item_$index'),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.blue,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.archive, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      String action = direction == DismissDirection.startToEnd
                          ? 'deleted'
                          : 'archived';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Item ${index + 1} was $action'),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text('Swipe Item ${index + 1}'),
                      subtitle: const Text('Swipe left or right to dismiss'),
                      leading: const CircleAvatar(child: Icon(Icons.swipe)),
                    ),
                  );
                },
              ),
              
              // Drag to Reorder
              ReorderableListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    key: Key('$index'),
                    title: Text('Draggable Item ${index + 1}'),
                    subtitle: const Text('Long press and drag to reorder'),
                    leading: const Icon(Icons.drag_indicator),
                    trailing: const Icon(Icons.drag_handle),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    // In a real app, you would reorder your data here
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Item moved from position $oldIndex to $newIndex'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        
        // Page indicator
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Swipe horizontally to see more examples'),
              const SizedBox(width: 8),
              const Icon(Icons.swipe, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
