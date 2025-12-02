import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static const LatLng defaultLocation = LatLng(-6.2088, 106.8456); // Jakarta

  /// Show info dialog before requesting location permission
  static Future<bool> _showLocationPermissionInfo(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue),
              SizedBox(width: 8),
              Text('Izin Akses Lokasi'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aplikasi ini memerlukan akses lokasi untuk:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Menampilkan peta di lokasi Anda saat ini'),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Memberikan pengalaman navigasi yang lebih baik'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Jika Anda tidak memberikan izin, peta akan ditampilkan dengan lokasi default (Jakarta).',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Tidak Sekarang'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Lanjutkan'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  /// Show notification about permission result
  static void _showPermissionNotification(
    BuildContext context,
    bool granted,
  ) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            granted ? Icons.check_circle : Icons.cancel,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              granted
                  ? 'Izin lokasi diberikan. Peta akan menampilkan lokasi Anda.'
                  : 'Izin lokasi ditolak. Peta akan menampilkan lokasi default (Jakarta).',
            ),
          ),
        ],
      ),
      backgroundColor: granted ? Colors.green : Colors.orange,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Request location permission and get current location
  static Future<LatLng> getLocationWithPermission(BuildContext context) async {
    // Show info dialog first
    final userWantsToProceed = await _showLocationPermissionInfo(context);
    
    if (!userWantsToProceed) {
      // User chose not to proceed
      _showPermissionNotification(context, false);
      return defaultLocation;
    }

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showPermissionNotification(context, false);
        return defaultLocation;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showPermissionNotification(context, false);
          return defaultLocation;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionNotification(context, false);
        return defaultLocation;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _showPermissionNotification(context, true);
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      // If any error occurs, use default location
      _showPermissionNotification(context, false);
      return defaultLocation;
    }
  }
}
