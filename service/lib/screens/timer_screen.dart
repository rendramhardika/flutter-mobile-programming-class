import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../services/timer_service.dart';

/// Screen utama untuk Pomodoro Timer
/// Mendemonstrasikan komunikasi antara UI dan Background Service
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _remainingSeconds = 1500; // 25 menit default
  bool _isRunning = false;
  bool _serviceStarted = false;
  bool _useLocalTimer = false; // Fallback untuk local timer
  Timer? _localTimer;

  // Preset timer durations (dalam detik)
  final List<Map<String, dynamic>> _presets = [
    {'name': 'Pomodoro', 'duration': 1500, 'icon': Icons.work}, // 25 menit
    {'name': 'Short Break', 'duration': 300, 'icon': Icons.coffee}, // 5 menit
    {'name': 'Long Break', 'duration': 900, 'icon': Icons.hotel}, // 15 menit
    {'name': 'Custom 10 Second', 'duration': 10, 'icon': Icons.timer}, // 1 menit untuk testing
  ];

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  /// Inisialisasi background service dan listen untuk updates
  Future<void> _initializeService() async {
    print('[TimerUI] Initializing timer service...');
    
    try {
      await TimerService.initializeService();
      print('[TimerUI] Timer service initialized');
      
      await TimerService.initializeNotifications();
      print('[TimerUI] Notifications initialized');

      // Listen untuk update dari background service
      FlutterBackgroundService().on('update').listen((event) {
        print('[TimerUI] === RECEIVED UPDATE FROM SERVICE ===');
        print('[TimerUI] Event data: $event');
        
        final newRemaining = event?['remaining'] as int? ?? 0;
        final newRunning = event?['isRunning'] as bool? ?? false;
        
        print('[TimerUI] Parsed - remaining: $newRemaining, running: $newRunning');
        print('[TimerUI] Current state - remaining: $_remainingSeconds, running: $_isRunning');
        
        if (mounted) {
          setState(() {
            _remainingSeconds = newRemaining;
            _isRunning = newRunning;
          });
          print('[TimerUI] State updated - remaining: $_remainingSeconds, running: $_isRunning');
        } else {
          print('[TimerUI] Widget not mounted, skipping state update');
        }
      });
      
      print('[TimerUI] Event listener setup complete');
    } catch (e) {
      print('[TimerUI] Error initializing timer service: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Timer service failed to initialize: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// Start timer dengan durasi tertentu
  Future<void> _startTimer(int durationInSeconds) async {
    print('[TimerUI] === STARTING TIMER ===');
    print('[TimerUI] Duration: $durationInSeconds seconds');
    
    try {
      if (!_serviceStarted) {
        print('[TimerUI] Starting background service...');
        
        // Check if service is already running
        final isRunning = await FlutterBackgroundService().isRunning();
        print('[TimerUI] Service running before start: $isRunning');
        
        await TimerService.startService();
        _serviceStarted = true;
        
        // Wait and verify service started
        await Future.delayed(const Duration(milliseconds: 1000));
        
        final isRunningAfter = await FlutterBackgroundService().isRunning();
        print('[TimerUI] Service running after start: $isRunningAfter');
        
        if (!isRunningAfter) {
          throw Exception('Timer service failed to start');
        }
        
        print('[TimerUI] Service started and ready');
      }

      setState(() {
        _remainingSeconds = durationInSeconds;
        _isRunning = true;
      });

      print('[TimerUI] Sending start command with duration: $durationInSeconds');
      TimerService.startTimer(durationInSeconds);
      
      print('[TimerUI] Timer start command sent successfully');
      
      // Wait a bit to see if we get response from background service
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // If no response from background service, use local timer
      if (_remainingSeconds == durationInSeconds && !_useLocalTimer) {
        print('[TimerUI] No response from background service, switching to local timer');
        _useLocalTimer = true;
        _startLocalTimer(durationInSeconds);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Using local timer (background service busy)'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
      
    } catch (e) {
      print('[TimerUI] Error starting timer: $e');
      print('[TimerUI] Falling back to local timer');
      
      // Fallback to local timer
      _useLocalTimer = true;
      _startLocalTimer(durationInSeconds);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Using local timer (background service failed)'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Start local timer as fallback
  void _startLocalTimer(int durationInSeconds) {
    print('[TimerUI] Starting local timer with duration: $durationInSeconds');
    
    _localTimer?.cancel();
    
    setState(() {
      _remainingSeconds = durationInSeconds;
      _isRunning = true;
    });
    
    _localTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRunning) {
        timer.cancel();
        return;
      }
      
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        print('[TimerUI] Local timer tick: $_remainingSeconds seconds remaining');
      } else {
        // Timer completed
        timer.cancel();
        setState(() {
          _isRunning = false;
          _remainingSeconds = 0;
        });
        
        print('[TimerUI] Local timer completed!');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Timer completed! 🎉'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    });
  }

  /// Stop/Pause timer
  void _stopTimer() {
    setState(() {
      _isRunning = false;
    });
    
    if (_useLocalTimer) {
      _localTimer?.cancel();
    } else {
      TimerService.stopTimer();
    }
  }

  /// Reset timer
  void _resetTimer() {
    setState(() {
      _remainingSeconds = 1500;
      _isRunning = false;
      _useLocalTimer = false; // Reset to try background service again
    });
    
    if (_useLocalTimer) {
      _localTimer?.cancel();
    } else {
      TimerService.resetTimer();
    }
  }

  /// Format detik menjadi MM:SS
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer Service'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isRunning ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isRunning ? Icons.play_circle : Icons.pause_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isRunning ? 'Running in Background' : 'Paused',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Timer display
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(_remainingSeconds / 60).ceil()} minutes',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Reset button
                  FloatingActionButton(
                    onPressed: _isRunning ? null : _resetTimer,
                    heroTag: 'reset',
                    backgroundColor: _isRunning ? Colors.grey : Colors.orange,
                    child: const Icon(Icons.refresh),
                  ),
                  const SizedBox(width: 20),

                  // Start/Stop button
                  FloatingActionButton.extended(
                    onPressed: _isRunning
                        ? _stopTimer
                        : () => _startTimer(_remainingSeconds),
                    heroTag: 'startstop',
                    icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(_isRunning ? 'Pause' : 'Start'),
                    backgroundColor:
                        _isRunning ? Colors.red : Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Preset buttons
              const Text(
                'Quick Start Presets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: _presets.map((preset) {
                  return ElevatedButton.icon(
                    onPressed: _isRunning
                        ? null
                        : () => _startTimer(preset['duration'] as int),
                    icon: Icon(preset['icon'] as IconData),
                    label: Text(preset['name'] as String),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              // Info card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Cara Kerja Background Service',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Timer berjalan di isolate terpisah\n'
                        '• Tetap berjalan saat app di-minimize\n'
                        '• Update real-time via notification\n'
                        '• Notifikasi saat timer selesai',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Dialog informasi tentang service
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Background Service'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Konsep yang Didemonstrasikan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. Background Service\n'
                  '   - Service berjalan di isolate terpisah\n'
                  '   - Tidak terpengaruh lifecycle UI\n'),
              Text('2. Foreground Service\n'
                  '   - Menampilkan notification persistent\n'
                  '   - User aware service sedang berjalan\n'),
              Text('3. Inter-Process Communication\n'
                  '   - UI mengirim command ke service\n'
                  '   - Service update UI via event stream\n'),
              Text('4. Local Notifications\n'
                  '   - Update progress di notification\n'
                  '   - Alert saat timer selesai\n'),
              SizedBox(height: 8),
              Text(
                'Coba minimize app saat timer berjalan!',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
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
    // Cancel local timer if active
    _localTimer?.cancel();
    
    // Tidak stop service saat widget dispose
    // Biarkan service tetap berjalan di background
    super.dispose();
  }
}
