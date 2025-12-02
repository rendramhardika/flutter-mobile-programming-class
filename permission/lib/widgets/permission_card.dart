import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/permission_info.dart';
import '../services/permission_service.dart';
import 'permission_rationale_dialog.dart';

/// Card widget untuk menampilkan setiap permission
class PermissionCard extends StatefulWidget {
  final PermissionInfo permissionInfo;
  final PermissionService permissionService;

  const PermissionCard({
    super.key,
    required this.permissionInfo,
    required this.permissionService,
  });

  @override
  State<PermissionCard> createState() => _PermissionCardState();
}

class _PermissionCardState extends State<PermissionCard> {
  PermissionStatus? _currentStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    final status = await widget.permissionService
        .checkPermission(widget.permissionInfo.permission);
    setState(() {
      _currentStatus = status;
    });
  }

  Future<void> _handlePermissionRequest() async {
    // Jika sudah granted, tidak perlu tampilkan dialog
    if (_currentStatus?.isGranted == true) {
      return;
    }

    // Tampilkan rationale dialog terlebih dahulu
    _showRationaleDialog();
  }

  void _showRationaleDialog() {
    showDialog(
      context: context,
      builder: (context) => PermissionRationaleDialog(
        permissionInfo: widget.permissionInfo,
        onAccept: () {
          Navigator.pop(context);
          _requestPermission();
        },
        onDecline: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isLoading = true;
    });

    final status = await widget.permissionService
        .requestPermission(widget.permissionInfo.permission);

    setState(() {
      _currentStatus = status;
      _isLoading = false;
    });

    if (status.isPermanentlyDenied) {
      _showPermanentlyDeniedDialog();
    }
  }

  void _showPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Permanently Denied'),
        content: Text(
          'You have permanently denied ${widget.permissionInfo.title} permission. '
          'Please enable it from app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (_currentStatus == null) return Colors.grey;

    switch (_currentStatus!) {
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.denied:
        return Colors.orange;
      case PermissionStatus.permanentlyDenied:
        return Colors.red;
      case PermissionStatus.restricted:
        return Colors.grey;
      case PermissionStatus.limited:
        return Colors.yellow.shade700;
      case PermissionStatus.provisional:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: _isLoading ? null : _handlePermissionRequest,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.permissionInfo.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.permissionInfo.icon,
                  color: widget.permissionInfo.color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Title & Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.permissionInfo.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.permissionInfo.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Status Badge
              if (_isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (_currentStatus != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.permissionService.getStatusDescription(_currentStatus!),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
