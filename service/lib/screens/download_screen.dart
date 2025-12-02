import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../models/download_item.dart';
import '../services/download_service.dart';

/// Screen untuk Download Manager
/// Mendemonstrasikan background download dengan progress tracking
class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  List<DownloadItem> _downloads = [];
  int _activeDownloads = 0;
  bool _serviceStarted = false;
  bool _useLocalSimulation = false; // Fallback jika service gagal
  final TextEditingController _urlController = TextEditingController();
  final Map<String, Timer> _localTimers = {}; // Untuk local simulation

  // Sample URLs untuk demo
  final List<Map<String, dynamic>> _sampleFiles = [
    {
      'name': 'Sample Document.pdf',
      'url': 'https://example.com/document.pdf',
      'size': 2500000, // 2.5 MB
      'icon': Icons.picture_as_pdf,
    },
    {
      'name': 'Profile Image.jpg',
      'url': 'https://example.com/image.jpg',
      'size': 1800000, // 1.8 MB
      'icon': Icons.image,
    },
    {
      'name': 'Music Track.mp3',
      'url': 'https://example.com/music.mp3',
      'size': 4200000, // 4.2 MB
      'icon': Icons.music_note,
    },
    {
      'name': 'Video Clip.mp4',
      'url': 'https://example.com/video.mp4',
      'size': 8500000, // 8.5 MB
      'icon': Icons.video_file,
    },
    {
      'name': 'Large Movie.mkv',
      'url': 'https://example.com/large-movie.mkv',
      'size': 25000000, // 25 MB - Progress lebih lama
      'icon': Icons.movie,
    },
    {
      'name': 'Software Installer.exe',
      'url': 'https://example.com/installer.exe',
      'size': 45000000, // 45 MB - Progress sangat lama
      'icon': Icons.install_desktop,
    },
    {
      'name': 'Presentation.pptx',
      'url': 'https://example.com/presentation.pptx',
      'size': 3200000, // 3.2 MB
      'icon': Icons.slideshow,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  /// Inisialisasi download service dan listen untuk updates
  Future<void> _initializeService() async {
    print('[DownloadUI] Initializing download service...');
    
    try {
      // Try background service first, but catch any errors
      try {
        await DownloadService.initializeService();
        print('[DownloadUI] Download service initialized');
        
        await DownloadService.initializeNotifications();
        print('[DownloadUI] Notifications initialized');

        // Listen untuk update dari background service
        FlutterBackgroundService().on('downloadUpdate').listen((event) {
          print('[DownloadUI] Received update from service: $event');
          if (mounted) {
            setState(() {
              final downloadsData = event?['downloads'] as List<dynamic>? ?? [];
              _downloads = downloadsData
                  .map((data) => DownloadItem.fromMap(data as Map<String, dynamic>))
                  .toList();
              _activeDownloads = event?['activeCount'] as int? ?? 0;
              print('[DownloadUI] Updated UI - ${_downloads.length} downloads, $_activeDownloads active');
            });
          }
        });
        
        // Listen untuk heartbeat dari background service
        FlutterBackgroundService().on('heartbeat').listen((event) {
          print('[DownloadUI] Received heartbeat from service: $event');
        });
        
        print('[DownloadUI] Event listener setup complete');
      } catch (serviceError) {
        print('[DownloadUI] Background service failed: $serviceError');
        print('[DownloadUI] Switching to local simulation mode permanently');
        
        // Force local simulation mode due to service error
        setState(() {
          _useLocalSimulation = true;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Background service unavailable: ${serviceError.toString().split(':').last}\nUsing local simulation mode'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      print('[DownloadUI] Critical error initializing: $e');
      // Force local mode
      setState(() {
        _useLocalSimulation = true;
      });
    }
  }

  /// Start download service jika belum berjalan
  Future<void> _ensureServiceStarted() async {
    // If already using local simulation, skip service startup
    if (_useLocalSimulation) {
      print('[DownloadUI] Using local simulation - skipping service startup');
      return;
    }
    
    if (!_serviceStarted) {
      print('[DownloadUI] Starting download service...');
      
      try {
        // Try to start service with simpler approach
        print('[DownloadUI] Attempting to start background service...');
        await DownloadService.startService();
        
        // Wait for service to initialize
        await Future.delayed(const Duration(milliseconds: 1000));
        
        final isRunning = await FlutterBackgroundService().isRunning();
        print('[DownloadUI] Service running after start: $isRunning');
        
        if (!isRunning) {
          throw Exception('Service failed to start');
        }
        
        _serviceStarted = true;
        print('[DownloadUI] Download service ready');
        
      } catch (e) {
        print('[DownloadUI] Background service failed: $e');
        print('[DownloadUI] Falling back to local simulation');
        
        // Auto-switch to local simulation
        setState(() {
          _useLocalSimulation = true;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Background service failed\nUsing local simulation mode'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        
        // Don't rethrow - just use local simulation
        return;
      }
    }
  }

  /// Tambah download baru
  Future<void> _addDownload(String fileName, String url, int totalBytes) async {
    print('[DownloadUI] === ADDING DOWNLOAD ===');
    print('[DownloadUI] File: $fileName');
    print('[DownloadUI] Size: ${_formatBytes(totalBytes)}');
    print('[DownloadUI] Using local simulation: $_useLocalSimulation');
    
    try {
      // Try background service first
      if (!_useLocalSimulation) {
        print('[DownloadUI] Attempting background service...');
        await _ensureServiceStarted();
        print('[DownloadUI] Service started, creating download item...');

        final downloadItem = DownloadItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          fileName: fileName,
          url: url,
          totalBytes: totalBytes,
        );

        print('[DownloadUI] Created download item: ${downloadItem.id}');
        print('[DownloadUI] Calling DownloadService.addDownload...');
        
        DownloadService.addDownload(downloadItem);
        
        print('[DownloadUI] Download added to service successfully');
      } else {
        // Use local simulation
        print('[DownloadUI] Using local simulation directly...');
        _addLocalDownload(fileName, url, totalBytes);
      }
    } catch (e) {
      print('[DownloadUI] Error with background service: $e');
      print('[DownloadUI] Switching to local simulation...');
      
      // Switch to local simulation
      setState(() {
        _useLocalSimulation = true;
      });
      _addLocalDownload(fileName, url, totalBytes);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Using local simulation (background service unavailable)'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  /// Local simulation sebagai fallback
  void _addLocalDownload(String fileName, String url, int totalBytes) {
    print('[DownloadUI] === ADDING LOCAL DOWNLOAD ===');
    print('[DownloadUI] File: $fileName');
    print('[DownloadUI] Size: ${_formatBytes(totalBytes)}');
    
    final downloadItem = DownloadItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fileName: fileName,
      url: url,
      totalBytes: totalBytes,
      status: DownloadStatus.downloading,
      startTime: DateTime.now(),
    );
    
    print('[DownloadUI] Created download item: ${downloadItem.id}');
    print('[DownloadUI] Current downloads count: ${_downloads.length}');
    print('[DownloadUI] Active downloads: $_activeDownloads');
    
    setState(() {
      _downloads.add(downloadItem);
      _activeDownloads++;
      print('[DownloadUI] Updated state - Downloads: ${_downloads.length}, Active: $_activeDownloads');
    });
    
    // Start local simulation timer
    print('[DownloadUI] Starting local simulation timer...');
    _startLocalSimulation(downloadItem);
  }

  /// Simulasi download lokal
  void _startLocalSimulation(DownloadItem item) {
    final random = Random();
    final bytesPerSecond = 50000 + random.nextInt(450000); // 50KB-500KB/s
    final bytesPerUpdate = (bytesPerSecond * 0.2).round(); // Update setiap 200ms
    
    print('[DownloadUI] Starting local simulation for: ${item.fileName}');
    print('[DownloadUI] Simulated speed: ${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s');
    
    // Show local notification for download start
    _showLocalNotification(
      'Download Started',
      'Starting download: ${item.fileName}',
    );
    
    print('[DownloadUI] Creating timer for: ${item.id}');
    print('[DownloadUI] Bytes per update: $bytesPerUpdate');
    
    _localTimers[item.id] = Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) {
        final index = _downloads.indexWhere((d) => d.id == item.id);
        if (index == -1) {
          print('[DownloadUI] Timer: Download item not found, canceling timer');
          timer.cancel();
          _localTimers.remove(item.id);
          return;
        }
        
        final currentItem = _downloads[index];
        if (currentItem.status != DownloadStatus.downloading) {
          print('[DownloadUI] Timer: Download not in downloading status, canceling timer');
          timer.cancel();
          _localTimers.remove(item.id);
          return;
        }
        
        int newDownloaded = currentItem.downloadedBytes + bytesPerUpdate;
        
        // Debug log every 10 updates (2 seconds)
        if (newDownloaded % (bytesPerUpdate * 10) < bytesPerUpdate) {
          final progress = ((newDownloaded / currentItem.totalBytes) * 100).round();
          print('[DownloadUI] Timer update: ${currentItem.fileName} - $progress% (${_formatBytes(newDownloaded)}/${_formatBytes(currentItem.totalBytes)})');
        }
        
        if (newDownloaded >= currentItem.totalBytes) {
          // Download completed
          newDownloaded = currentItem.totalBytes;
          setState(() {
            _downloads[index] = currentItem.copyWith(
              downloadedBytes: newDownloaded,
              status: DownloadStatus.completed,
              endTime: DateTime.now(),
            );
            _activeDownloads--;
          });
          
          timer.cancel();
          _localTimers.remove(item.id);
          
          // Show completion notification
          _showLocalNotification(
            'Download Complete! 📁',
            '${currentItem.fileName} downloaded successfully',
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Download completed: ${currentItem.fileName}'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          // Update progress
          setState(() {
            _downloads[index] = currentItem.copyWith(
              downloadedBytes: newDownloaded,
            );
          });
          
          // Update notification every 5 seconds to avoid spam
          if (newDownloaded % (bytesPerUpdate * 25) < bytesPerUpdate) {
            final progress = ((newDownloaded / currentItem.totalBytes) * 100).round();
            _showLocalNotification(
              'Downloading: ${currentItem.fileName}',
              '$progress% • ${_formatBytes(newDownloaded)} / ${_formatBytes(currentItem.totalBytes)}',
            );
          }
        }
      },
    );
  }

  /// Show local notification (fallback for when background service fails)
  void _showLocalNotification(String title, String body) {
    // This is a simple notification - in real app you'd use flutter_local_notifications
    print('[DownloadUI] Local Notification: $title - $body');
    
    if (mounted) {
      // Show as SnackBar since we can't access system notifications from UI thread
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title\n$body'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blue.shade700,
        ),
      );
    }
  }

  /// Format bytes helper
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Pause download
  void _pauseDownload(String downloadId) {
    if (_useLocalSimulation) {
      _pauseLocalDownload(downloadId);
    } else {
      DownloadService.pauseDownload(downloadId);
    }
  }

  /// Resume download
  void _resumeDownload(String downloadId) {
    if (_useLocalSimulation) {
      _resumeLocalDownload(downloadId);
    } else {
      DownloadService.resumeDownload(downloadId);
    }
  }

  /// Cancel download
  void _cancelDownload(String downloadId) {
    if (_useLocalSimulation) {
      _cancelLocalDownload(downloadId);
    } else {
      DownloadService.cancelDownload(downloadId);
    }
  }

  /// Pause local download
  void _pauseLocalDownload(String downloadId) {
    final index = _downloads.indexWhere((d) => d.id == downloadId);
    if (index != -1 && _downloads[index].status == DownloadStatus.downloading) {
      _localTimers[downloadId]?.cancel();
      _localTimers.remove(downloadId);
      
      setState(() {
        _downloads[index] = _downloads[index].copyWith(status: DownloadStatus.paused);
        _activeDownloads--;
      });
    }
  }

  /// Resume local download
  void _resumeLocalDownload(String downloadId) {
    final index = _downloads.indexWhere((d) => d.id == downloadId);
    if (index != -1 && _downloads[index].status == DownloadStatus.paused) {
      setState(() {
        _downloads[index] = _downloads[index].copyWith(status: DownloadStatus.downloading);
        _activeDownloads++;
      });
      
      _startLocalSimulation(_downloads[index]);
    }
  }

  /// Cancel local download
  void _cancelLocalDownload(String downloadId) {
    final index = _downloads.indexWhere((d) => d.id == downloadId);
    if (index != -1) {
      _localTimers[downloadId]?.cancel();
      _localTimers.remove(downloadId);
      
      setState(() {
        if (_downloads[index].status == DownloadStatus.downloading) {
          _activeDownloads--;
        }
        _downloads[index] = _downloads[index].copyWith(status: DownloadStatus.cancelled);
      });
    }
  }

  /// Clear completed downloads
  void _clearCompleted() {
    if (_useLocalSimulation) {
      setState(() {
        _downloads.removeWhere((d) => d.status.isFinished);
      });
    } else {
      DownloadService.clearCompleted();
    }
  }

  /// Toggle between background service and local simulation
  void _toggleServiceMode() {
    setState(() {
      _useLocalSimulation = !_useLocalSimulation;
      _serviceStarted = false; // Reset service state
    });
    
    // Clear existing downloads when switching modes
    setState(() {
      // Cancel all local timers
      for (final timer in _localTimers.values) {
        timer.cancel();
      }
      _localTimers.clear();
      
      // Clear downloads list
      _downloads.clear();
      _activeDownloads = 0;
    });
    
    if (mounted) {
      final mode = _useLocalSimulation ? 'Local Simulation' : 'Background Service';
      final description = _useLocalSimulation 
          ? 'Progress in app only, pauses when minimized'
          : 'Progress in notification bar, runs when minimized';
          
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to $mode mode\n$description'),
          backgroundColor: _useLocalSimulation ? Colors.orange : Colors.blue,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  /// Test local simulation directly
  void _testLocalSimulation() {
    print('[DownloadUI] === TESTING LOCAL SIMULATION ===');
    
    // Force local simulation mode
    setState(() {
      _useLocalSimulation = true;
    });
    
    // Create test download
    final testItem = DownloadItem(
      id: 'test_local_${DateTime.now().millisecondsSinceEpoch}',
      fileName: 'Test Local Download.txt',
      url: 'https://test.local/file.txt',
      totalBytes: 5000000, // 5 MB for visible progress
      status: DownloadStatus.downloading,
      startTime: DateTime.now(),
    );
    
    print('[DownloadUI] Adding test download to local simulation: ${testItem.fileName}');
    
    setState(() {
      _downloads.add(testItem);
      _activeDownloads++;
    });
    
    // Start simulation
    _startLocalSimulation(testItem);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Started test local simulation download (5MB)'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Test service functionality
  Future<void> _testService() async {
    print('[DownloadUI] === TESTING SERVICE ===');
    
    try {
      // Test 1: Check if service is running
      print('[DownloadUI] Test 1: Checking if service is running...');
      final isRunning = FlutterBackgroundService().isRunning();
      print('[DownloadUI] Service running: ${await isRunning}');
      
      // Test 2: Try to start service
      print('[DownloadUI] Test 2: Starting service...');
      await _ensureServiceStarted();
      
      // Test 3: Check again after start
      final isRunningAfter = FlutterBackgroundService().isRunning();
      print('[DownloadUI] Service running after start: ${await isRunningAfter}');
      
      // Test 4: Try direct add download
      print('[DownloadUI] Test 3: Adding test download...');
      final testItem = DownloadItem(
        id: 'test_${DateTime.now().millisecondsSinceEpoch}',
        fileName: 'test_file.txt',
        url: 'https://test.com/file.txt',
        totalBytes: 1000000,
      );
      
      DownloadService.addDownload(testItem);
      print('[DownloadUI] Test download added');
      
      // Show result
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service test completed - check console logs'),
            backgroundColor: Colors.blue,
          ),
        );
      }
      
    } catch (e) {
      print('[DownloadUI] Test error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Service test failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Generate random file size untuk custom download
  int _generateRandomSize() {
    final random = Random();
    return 500000 + random.nextInt(9500000); // 0.5MB - 10MB
  }

  /// Dialog untuk custom download
  void _showCustomDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Download'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'File URL',
                hintText: 'https://example.com/file.zip',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Catatan: Ini hanya simulasi download.\nUkuran file akan digenerate secara random.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final url = _urlController.text.trim();
              if (url.isNotEmpty) {
                final fileName = url.split('/').last.isNotEmpty 
                    ? url.split('/').last 
                    : 'custom_file.bin';
                _addDownload(fileName, url, _generateRandomSize());
                _urlController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Manager'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_useLocalSimulation ? Icons.cloud_off : Icons.cloud),
            onPressed: _toggleServiceMode,
            tooltip: _useLocalSimulation ? 'Try Background Service' : 'Use Local Simulation',
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _testLocalSimulation,
            tooltip: 'Test Local Simulation',
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: _testService,
            tooltip: 'Test Service',
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _downloads.any((d) => d.status.isFinished) 
                ? _clearCompleted 
                : null,
            tooltip: 'Clear Completed',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      _activeDownloads > 0 ? Icons.download : Icons.download_done,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _activeDownloads > 0 
                          ? '$_activeDownloads downloads active'
                          : 'No active downloads',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_downloads.length} total',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                if (_useLocalSimulation) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber,
                          size: 16,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Using Local Simulation (Background service unavailable)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Sample downloads section
          if (_downloads.isEmpty) ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No downloads yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try downloading sample files below',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Downloads list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _downloads.length,
                itemBuilder: (context, index) {
                  final download = _downloads[index];
                  return _buildDownloadItem(download);
                },
              ),
            ),
          ],

          // Sample files section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Sample Files',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _showCustomDownloadDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Custom'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _sampleFiles.map((file) {
                    return ElevatedButton.icon(
                      onPressed: () {
                        print('[DownloadUI] Sample file button clicked: ${file['name']}');
                        _addDownload(
                          file['name'] as String,
                          file['url'] as String,
                          file['size'] as int,
                        );
                      },
                      icon: Icon(file['icon'] as IconData),
                      label: Text(file['name'] as String),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build download item widget
  Widget _buildDownloadItem(DownloadItem download) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  _getFileIcon(download.fileName),
                  size: 24,
                  color: Color(download.status.colorValue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        download.fileName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        download.url,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(download.status.colorValue).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(download.status.colorValue).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    download.status.displayName,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(download.status.colorValue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Progress bar (only for active downloads)
            if (download.status == DownloadStatus.downloading) ...[
              LinearProgressIndicator(
                value: download.progressPercent / 100,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(download.status.colorValue),
                ),
              ),
              const SizedBox(height: 4),
            ],

            // Info row
            Row(
              children: [
                Text(
                  '${download.formattedDownloaded} / ${download.formattedSize}',
                  style: const TextStyle(fontSize: 12),
                ),
                if (download.status == DownloadStatus.downloading) ...[
                  Text(
                    ' • ${download.progressPercent.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    ' • ${download.formattedSpeed}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    ' • ETA: ${download.estimatedTimeRemaining}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
                const Spacer(),
                // Action buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (download.status.canPause)
                      IconButton(
                        onPressed: () => _pauseDownload(download.id),
                        icon: const Icon(Icons.pause),
                        iconSize: 20,
                        tooltip: 'Pause',
                      ),
                    if (download.status.canResume)
                      IconButton(
                        onPressed: () => _resumeDownload(download.id),
                        icon: const Icon(Icons.play_arrow),
                        iconSize: 20,
                        tooltip: 'Resume',
                      ),
                    if (!download.status.isFinished)
                      IconButton(
                        onPressed: () => _cancelDownload(download.id),
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                        tooltip: 'Cancel',
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Get appropriate icon for file type
  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp3':
      case 'wav':
      case 'flac':
        return Icons.music_note;
      case 'mp4':
      case 'avi':
      case 'mkv':
        return Icons.video_file;
      case 'pptx':
      case 'ppt':
        return Icons.slideshow;
      case 'docx':
      case 'doc':
        return Icons.description;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// Dialog informasi tentang download service
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Download Manager'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Fitur yang Didemonstrasikan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. Background Download Service\n'
                  '   - Download berjalan di isolate terpisah\n'
                  '   - Tetap berjalan saat app di-minimize\n'),
              Text('2. Progress Tracking\n'
                  '   - Real-time progress update\n'
                  '   - Progress bar di notification\n'),
              Text('3. Queue Management\n'
                  '   - Multiple downloads bersamaan\n'
                  '   - Automatic queue processing\n'),
              Text('4. Download Controls\n'
                  '   - Pause, Resume, Cancel\n'
                  '   - Clear completed downloads\n'),
              SizedBox(height: 8),
              Text(
                'Catatan: Ini adalah simulasi download.\nTidak ada file yang benar-benar didownload.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    
    // Cancel all local timers
    for (final timer in _localTimers.values) {
      timer.cancel();
    }
    _localTimers.clear();
    
    super.dispose();
  }
}
