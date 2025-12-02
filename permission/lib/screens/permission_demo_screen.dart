import 'package:flutter/material.dart';
import '../models/permission_info.dart';
import '../services/permission_service.dart';
import '../widgets/permission_card.dart';

/// Main screen untuk demo permission
class PermissionDemoScreen extends StatefulWidget {
  const PermissionDemoScreen({super.key});

  @override
  State<PermissionDemoScreen> createState() => _PermissionDemoScreenState();
}

class _PermissionDemoScreenState extends State<PermissionDemoScreen> {
  final PermissionService _permissionService = PermissionService();
  final List<PermissionInfo> _permissions = PermissionInfo.getAllPermissions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tap pada permission untuk melihat detail',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Anda akan melihat penjelasan mengapa permission diperlukan sebelum request',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          
          // Permission List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _permissions.length,
              itemBuilder: (context, index) {
                return PermissionCard(
                  permissionInfo: _permissions[index],
                  permissionService: _permissionService,
                );
              },
            ),
          ),
        ],
      ),
      
      // Floating Action Button untuk request all
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _requestAllPermissions,
        icon: const Icon(Icons.check_circle),
        label: const Text('Request All'),
      ),
    );
  }

  Future<void> _requestAllPermissions() async {
    // Tampilkan confirmation dialog terlebih dahulu
    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 12),
            Text('Request All Permissions'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aplikasi akan meminta izin untuk mengakses:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ..._permissions.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(p.icon, size: 18, color: p.color),
                      const SizedBox(width: 8),
                      Text(p.title),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Anda akan melihat beberapa dialog permission dari sistem. Mohon izinkan semua untuk pengalaman terbaik.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Lanjutkan'),
          ),
        ],
      ),
    );

    if (shouldProceed != true) return;

    // Show loading dialog
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Requesting all permissions...'),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final permissions = _permissions.map((p) => p.permission).toList();
    await _permissionService.requestMultiplePermissions(permissions);

    if (mounted) {
      Navigator.pop(context);
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All permissions requested!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
