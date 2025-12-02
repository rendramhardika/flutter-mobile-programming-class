import 'package:permission_handler/permission_handler.dart';

/// Service untuk handle semua permission logic
class PermissionService {
  /// Check status permission
  Future<PermissionStatus> checkPermission(Permission permission) async {
    return await permission.status;
  }

  /// Request permission
  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status;
  }

  /// Check apakah permission granted
  Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// Check apakah permission denied permanently
  Future<bool> isPermissionPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Request multiple permissions sekaligus
  Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
    List<Permission> permissions,
  ) async {
    return await permissions.request();
  }

  /// Get status description yang user-friendly
  String getStatusDescription(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'Granted';
      case PermissionStatus.denied:
        return 'Denied';
      case PermissionStatus.restricted:
        return 'Restricted';
      case PermissionStatus.limited:
        return 'Limited';
      case PermissionStatus.permanentlyDenied:
        return 'Permanently Denied';
      case PermissionStatus.provisional:
        return 'Provisional';
    }
  }

  /// Get color berdasarkan status
  String getStatusColor(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'green';
      case PermissionStatus.denied:
        return 'orange';
      case PermissionStatus.permanentlyDenied:
        return 'red';
      case PermissionStatus.restricted:
        return 'grey';
      case PermissionStatus.limited:
        return 'yellow';
      case PermissionStatus.provisional:
        return 'blue';
    }
  }
}
