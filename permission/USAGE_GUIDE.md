# Usage Guide - Permission Implementation

Panduan lengkap untuk mengimplementasikan permission handling di aplikasi Flutter Anda menggunakan architecture dan patterns dari project ini.

## 📋 Table of Contents

1. [Basic Usage](#basic-usage)
2. [Permission Service](#permission-service)
3. [Permission Rationale Dialog](#permission-rationale-dialog)
4. [Permission Card Widget](#permission-card-widget)
5. [Advanced Usage](#advanced-usage)
6. [Best Practices](#best-practices)
7. [Platform-Specific Notes](#platform-specific-notes)
8. [Testing](#testing)
9. [Common Issues](#common-issues)

---

## Basic Usage

### 1. Import Service

```dart
import 'package:permission/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
```

### 2. Inisialisasi Service

```dart
final permissionService = PermissionService();
```

### 3. Check Permission Status

```dart
// Check single permission
final status = await permissionService.checkPermission(Permission.camera);

// Check if granted
final isGranted = await permissionService.isPermissionGranted(Permission.camera);

// Check if permanently denied
final isPermanentlyDenied = await permissionService.isPermissionPermanentlyDenied(Permission.camera);
```

### 4. Request Permission

```dart
// Request single permission
final status = await permissionService.requestPermission(Permission.camera);

if (status.isGranted) {
  // Permission granted, lanjutkan operasi
  print('Camera permission granted!');
} else if (status.isPermanentlyDenied) {
  // Permission permanently denied, arahkan ke settings
  await openAppSettings();
} else {
  // Permission denied, tampilkan pesan
  print('Camera permission denied');
}
```

### 5. Request Multiple Permissions

```dart
final permissions = [
  Permission.camera,
  Permission.microphone,
  Permission.location,
];

final statuses = await permissionService.requestMultiplePermissions(permissions);

statuses.forEach((permission, status) {
  print('${permission.toString()}: ${status.toString()}');
});
```

### 6. Handle Permanently Denied

```dart
Future<void> handleCameraPermission() async {
  final status = await permissionService.requestPermission(Permission.camera);
  
  if (status.isPermanentlyDenied) {
    // Show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text('Please enable camera permission in settings'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
```

## Permission Rationale Dialog

### Mengapa Rationale Dialog Penting?

Rationale dialog adalah **UX best practice** yang menjelaskan kepada user **mengapa** aplikasi memerlukan permission **sebelum** system permission dialog muncul. Ini meningkatkan acceptance rate hingga 50%.

### Implementasi Rationale Dialog

```dart
import 'package:flutter/material.dart';
import 'package:permission/widgets/permission_rationale_dialog.dart';
import 'package:permission/models/permission_info.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestCameraWithRationale(BuildContext context) async {
  final permissionInfo = PermissionInfo(
    permission: Permission.camera,
    title: 'Camera',
    description: 'Ambil foto untuk profil Anda',
    icon: Icons.camera_alt,
    color: Colors.blue,
    rationale: 'Kami memerlukan akses kamera untuk memungkinkan Anda '
               'mengambil foto profil dan berbagi momen dengan teman.',
    benefits: [
      'Ambil foto profil yang menarik',
      'Bagikan momen langsung dari kamera',
      'Edit dan filter foto sebelum upload',
    ],
  );

  // Show rationale dialog first
  final shouldRequest = await showDialog<bool>(
    context: context,
    builder: (context) => PermissionRationaleDialog(
      permissionInfo: permissionInfo,
      onAccept: () => Navigator.pop(context, true),
      onDecline: () => Navigator.pop(context, false),
    ),
  );

  // If user accepts, request permission
  if (shouldRequest == true) {
    final status = await Permission.camera.request();
    
    if (status.isGranted) {
      // Open camera
      print('Camera permission granted!');
    } else if (status.isPermanentlyDenied) {
      // Show settings dialog
      _showSettingsDialog(context);
    }
  }
}

void _showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Permission Required'),
      content: const Text(
        'Camera permission is permanently denied. '
        'Please enable it in app settings.',
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
```

### Customizing Rationale Dialog

```dart
final permissionInfo = PermissionInfo(
  permission: Permission.location,
  title: 'Location',
  description: 'Temukan tempat menarik di sekitar Anda',
  icon: Icons.location_on,
  color: Colors.green,
  
  // Rationale: Jelaskan MENGAPA permission diperlukan
  rationale: 'Kami memerlukan akses lokasi Anda untuk menampilkan '
             'restoran, cafe, dan tempat menarik di sekitar Anda. '
             'Lokasi Anda hanya digunakan saat aplikasi aktif.',
  
  // Benefits: Jelaskan MANFAAT untuk user
  benefits: [
    'Temukan tempat menarik terdekat',
    'Dapatkan rekomendasi personal berdasarkan lokasi',
    'Navigasi langsung ke tujuan',
    'Lihat estimasi waktu tempuh yang akurat',
  ],
);
```

## Permission Card Widget

### Basic Implementation

```dart
import 'package:permission/widgets/permission_card.dart';
import 'package:permission/models/permission_info.dart';
import 'package:permission/services/permission_service.dart';

class MyPermissionsScreen extends StatelessWidget {
  final permissionService = PermissionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PermissionCard(
            permissionInfo: PermissionInfo(
              permission: Permission.camera,
              title: 'Camera',
              description: 'Access camera to take photos',
              icon: Icons.camera_alt,
              color: Colors.blue,
              rationale: 'We need camera access to let you take photos.',
              benefits: ['Take profile photos', 'Share moments'],
            ),
            permissionService: permissionService,
          ),
          const SizedBox(height: 12),
          PermissionCard(
            permissionInfo: PermissionInfo(
              permission: Permission.microphone,
              title: 'Microphone',
              description: 'Record audio messages',
              icon: Icons.mic,
              color: Colors.red,
              rationale: 'We need microphone access for voice messages.',
              benefits: ['Send voice messages', 'Make voice calls'],
            ),
            permissionService: permissionService,
          ),
        ],
      ),
    );
  }
}
```

### Custom Permission Card

Jika Anda ingin membuat custom card:

```dart
class CustomPermissionCard extends StatefulWidget {
  final PermissionInfo permissionInfo;
  
  const CustomPermissionCard({required this.permissionInfo});
  
  @override
  State<CustomPermissionCard> createState() => _CustomPermissionCardState();
}

class _CustomPermissionCardState extends State<CustomPermissionCard> {
  PermissionStatus? _status;
  
  @override
  void initState() {
    super.initState();
    _checkPermission();
  }
  
  Future<void> _checkPermission() async {
    final status = await widget.permissionInfo.permission.status;
    setState(() => _status = status);
  }
  
  Future<void> _requestPermission() async {
    // Show rationale dialog first
    final shouldRequest = await showDialog<bool>(
      context: context,
      builder: (context) => PermissionRationaleDialog(
        permissionInfo: widget.permissionInfo,
        onAccept: () => Navigator.pop(context, true),
        onDecline: () => Navigator.pop(context, false),
      ),
    );
    
    if (shouldRequest == true) {
      final status = await widget.permissionInfo.permission.request();
      setState(() => _status = status);
      
      if (status.isPermanentlyDenied) {
        _showSettingsDialog();
      }
    }
  }
  
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${widget.permissionInfo.title} Permission'),
        content: const Text('Please enable permission in settings.'),
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
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          widget.permissionInfo.icon,
          color: widget.permissionInfo.color,
        ),
        title: Text(widget.permissionInfo.title),
        subtitle: Text(widget.permissionInfo.description),
        trailing: _buildStatusBadge(),
        onTap: _requestPermission,
      ),
    );
  }
  
  Widget _buildStatusBadge() {
    if (_status == null) return const CircularProgressIndicator();
    
    Color color;
    String text;
    
    switch (_status!) {
      case PermissionStatus.granted:
        color = Colors.green;
        text = 'Granted';
        break;
      case PermissionStatus.denied:
        color = Colors.orange;
        text = 'Denied';
        break;
      case PermissionStatus.permanentlyDenied:
        color = Colors.red;
        text = 'Blocked';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
```

## Advanced Usage

### 1. Conditional Permission Request

Request permission hanya ketika dibutuhkan:

```dart
class CameraFeature {
  final PermissionService _permissionService = PermissionService();
  
  Future<bool> openCamera(BuildContext context) async {
    // Check if already granted
    final isGranted = await _permissionService.isPermissionGranted(
      Permission.camera,
    );
    
    if (isGranted) {
      // Directly open camera
      return _launchCamera();
    }
    
    // Show rationale and request
    final shouldRequest = await _showRationaleDialog(context);
    if (!shouldRequest) return false;
    
    final status = await _permissionService.requestPermission(
      Permission.camera,
    );
    
    if (status.isGranted) {
      return _launchCamera();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog(context);
    }
    
    return false;
  }
  
  Future<bool> _launchCamera() async {
    // Your camera implementation
    print('Opening camera...');
    return true;
  }
  
  Future<bool> _showRationaleDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Access'),
        content: const Text('We need camera access to take photos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    ) ?? false;
  }
  
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Blocked'),
        content: const Text(
          'Camera permission is blocked. Please enable it in settings.',
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
}
```

### 2. Permission Groups

Request multiple related permissions:

```dart
class PermissionGroups {
  final PermissionService _permissionService = PermissionService();
  
  // Location permissions group
  Future<bool> requestLocationPermissions() async {
    final permissions = [
      Permission.location,
      Permission.locationWhenInUse,
    ];
    
    final statuses = await _permissionService.requestMultiplePermissions(
      permissions,
    );
    
    // Check if at least one location permission is granted
    return statuses.values.any((status) => status.isGranted);
  }
  
  // Media permissions group
  Future<Map<String, bool>> requestMediaPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.photos,
      Permission.microphone,
    ];
    
    final statuses = await _permissionService.requestMultiplePermissions(
      permissions,
    );
    
    return {
      'camera': statuses[Permission.camera]?.isGranted ?? false,
      'photos': statuses[Permission.photos]?.isGranted ?? false,
      'microphone': statuses[Permission.microphone]?.isGranted ?? false,
    };
  }
  
  // Social permissions group
  Future<bool> requestSocialPermissions() async {
    final permissions = [
      Permission.contacts,
      Permission.calendar,
    ];
    
    final statuses = await _permissionService.requestMultiplePermissions(
      permissions,
    );
    
    return statuses.values.every((status) => status.isGranted);
  }
}
```

### 3. Permission State Management

Menggunakan Provider/Riverpod untuk state management:

```dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider extends ChangeNotifier {
  final Map<Permission, PermissionStatus> _statuses = {};
  
  PermissionStatus? getStatus(Permission permission) {
    return _statuses[permission];
  }
  
  Future<void> checkPermission(Permission permission) async {
    final status = await permission.status;
    _statuses[permission] = status;
    notifyListeners();
  }
  
  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    _statuses[permission] = status;
    notifyListeners();
  }
  
  Future<void> checkAllPermissions(List<Permission> permissions) async {
    for (final permission in permissions) {
      await checkPermission(permission);
    }
  }
  
  bool isGranted(Permission permission) {
    return _statuses[permission]?.isGranted ?? false;
  }
  
  bool isPermanentlyDenied(Permission permission) {
    return _statuses[permission]?.isPermanentlyDenied ?? false;
  }
}

// Usage
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PermissionProvider(),
      child: MaterialApp(
        home: PermissionsScreen(),
      ),
    );
  }
}

class PermissionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PermissionProvider>(context);
    
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: const Text('Camera'),
            trailing: Text(
              provider.isGranted(Permission.camera) ? 'Granted' : 'Denied',
            ),
            onTap: () => provider.requestPermission(Permission.camera),
          ),
        ],
      ),
    );
  }
}
```

### 4. Real-World Scenarios

#### Scenario 1: Social Media App

```dart
class SocialMediaPermissions {
  Future<void> setupNewPost(BuildContext context) async {
    // Request camera and photos for posting
    final permissions = [Permission.camera, Permission.photos];
    final statuses = await permissions.request();
    
    final cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
    final photosGranted = statuses[Permission.photos]?.isGranted ?? false;
    
    if (cameraGranted || photosGranted) {
      // Show post creation screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CreatePostScreen()),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera or Photos permission is required'),
        ),
      );
    }
  }
}
```

#### Scenario 2: Delivery App

```dart
class DeliveryAppPermissions {
  Future<bool> startDelivery(BuildContext context) async {
    // Check location permission
    final locationStatus = await Permission.location.status;
    
    if (!locationStatus.isGranted) {
      // Show rationale
      final shouldRequest = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location Required'),
          content: const Text(
            'We need your location to:\n'
            '• Track delivery progress\n'
            '• Show estimated arrival time\n'
            '• Navigate to destination',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Enable Location'),
            ),
          ],
        ),
      );
      
      if (shouldRequest != true) return false;
      
      final status = await Permission.location.request();
      if (!status.isGranted) return false;
    }
    
    // Start tracking
    return true;
  }
}
```

#### Scenario 3: Video Call App

```dart
class VideoCallPermissions {
  Future<bool> startVideoCall(BuildContext context) async {
    // Need both camera and microphone
    final permissions = [Permission.camera, Permission.microphone];
    
    // Check current status
    final cameraStatus = await Permission.camera.status;
    final micStatus = await Permission.microphone.status;
    
    if (cameraStatus.isGranted && micStatus.isGranted) {
      return true; // Already have permissions
    }
    
    // Show rationale
    final shouldRequest = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Video Call Permissions'),
        content: const Text(
          'To make video calls, we need:\n\n'
          '📷 Camera - To show your video\n'
          '🎤 Microphone - To transmit your voice\n\n'
          'Your privacy is important. You can disable '
          'camera/microphone during the call.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    
    if (shouldRequest != true) return false;
    
    // Request permissions
    final statuses = await permissions.request();
    
    final allGranted = statuses.values.every((s) => s.isGranted);
    
    if (!allGranted) {
      // Show which permissions are missing
      final missing = <String>[];
      if (!(statuses[Permission.camera]?.isGranted ?? false)) {
        missing.add('Camera');
      }
      if (!(statuses[Permission.microphone]?.isGranted ?? false)) {
        missing.add('Microphone');
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Missing permissions: ${missing.join(", ")}'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    }
    
    return allGranted;
  }
}
```

## Best Practices

### 1. Always Check Before Request

**DO:** Check permission status sebelum request
```dart
Future<void> useCamera() async {
  // Check first
  final isGranted = await permissionService.isPermissionGranted(Permission.camera);
  
  if (!isGranted) {
    // Request if not granted
    final status = await permissionService.requestPermission(Permission.camera);
    if (!status.isGranted) {
      _showPermissionDeniedMessage();
      return;
    }
  }
  
  // Use camera
  _openCamera();
}
```

**DON'T:** Langsung request tanpa check
```dart
// ❌ Bad practice
Future<void> useCamera() async {
  await Permission.camera.request(); // Might annoy users
  _openCamera();
}
```

### 2. Provide Context to User (CRITICAL)

**DO:** Jelaskan MENGAPA dan MANFAAT sebelum request
```dart
Future<void> requestLocationWithRationale(BuildContext context) async {
  // ✅ Good: Show detailed rationale
  final shouldRequest = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Location Access'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why we need this:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('We need location access to show nearby places.'),
          const SizedBox(height: 16),
          const Text(
            'Benefits for you:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('• Find restaurants near you'),
          const Text('• Get accurate delivery estimates'),
          const Text('• Discover local events'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Not Now'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Allow'),
        ),
      ],
    ),
  );

  if (shouldRequest == true) {
    await Permission.location.request();
  }
}
```

**DON'T:** Request tanpa penjelasan
```dart
// ❌ Bad: No explanation
Future<void> requestLocation() async {
  await Permission.location.request(); // User confused why
}
```

### 3. Handle All Permission States

**DO:** Handle semua possible states
```dart
Future<void> handlePermission(
  BuildContext context,
  Permission permission,
) async {
  final status = await permission.request();
  
  switch (status) {
    case PermissionStatus.granted:
      // ✅ Permission granted - proceed with feature
      _proceedWithFeature();
      break;
      
    case PermissionStatus.denied:
      // ⚠️ Denied - can request again later
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission denied. You can grant it later.'),
          duration: Duration(seconds: 3),
        ),
      );
      break;
      
    case PermissionStatus.permanentlyDenied:
      // ❌ Permanently denied - must go to settings
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'This permission is required for the feature. '
            'Please enable it in app settings.',
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
      break;
      
    case PermissionStatus.restricted:
      // 🔒 Restricted by system (parental controls, MDM, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Permission is restricted by system settings.',
          ),
        ),
      );
      break;
      
    case PermissionStatus.limited:
      // 📊 Limited access (iOS 14+ photos)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Limited access granted.'),
          action: SnackBarAction(
            label: 'Learn More',
            onPressed: _showLimitedAccessInfo,
          ),
        ),
      );
      break;
      
    case PermissionStatus.provisional:
      // 🔔 Provisional (iOS notifications)
      // Notifications delivered quietly
      _setupProvisionalNotifications();
      break;
  }
}
```

### 4. Request at the Right Time

**DO:** Request permission ketika user akan menggunakan feature
```dart
// ✅ Good: Request when user taps "Take Photo" button
void onTakePhotoPressed() async {
  final status = await Permission.camera.request();
  if (status.isGranted) {
    _openCamera();
  }
}
```

**DON'T:** Request semua permissions saat app launch
```dart
// ❌ Bad: Request all at once on app start
void initState() {
  super.initState();
  _requestAllPermissions(); // Overwhelming for users
}
```

### 5. Graceful Degradation

**DO:** Provide alternative jika permission denied
```dart
Future<void> addProfilePhoto(BuildContext context) async {
  final status = await Permission.camera.request();
  
  if (status.isGranted) {
    // Use camera
    _openCamera();
  } else {
    // Offer alternative: pick from gallery
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Not Available'),
        content: const Text('Would you like to pick a photo from gallery?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _pickFromGallery();
            },
            child: const Text('Choose from Gallery'),
          ),
        ],
      ),
    );
  }
}
```

### 6. Don't Request Repeatedly

**DO:** Track permission requests
```dart
class PermissionManager {
  final Map<Permission, DateTime> _lastRequested = {};
  final Duration _cooldown = const Duration(hours: 24);
  
  Future<bool> shouldRequestPermission(Permission permission) async {
    final lastTime = _lastRequested[permission];
    if (lastTime != null) {
      final elapsed = DateTime.now().difference(lastTime);
      if (elapsed < _cooldown) {
        return false; // Don't annoy user
      }
    }
    return true;
  }
  
  Future<PermissionStatus> requestPermission(Permission permission) async {
    _lastRequested[permission] = DateTime.now();
    return await permission.request();
  }
}
```

### 7. Clear Error Messages

**DO:** Provide actionable error messages
```dart
void _showPermissionError(BuildContext context, Permission permission) {
  String message;
  String action;
  
  switch (permission) {
    case Permission.camera:
      message = 'Camera access is required to take photos.';
      action = 'Enable Camera';
      break;
    case Permission.location:
      message = 'Location access is required to find nearby places.';
      action = 'Enable Location';
      break;
    default:
      message = 'Permission is required for this feature.';
      action = 'Enable';
  }
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: action,
        onPressed: () => openAppSettings(),
      ),
      duration: const Duration(seconds: 5),
    ),
  );
}
```

## Platform-Specific Notes

### Android

- Beberapa permissions memerlukan Android API level tertentu
- `READ_MEDIA_IMAGES` dan `READ_MEDIA_VIDEO` untuk Android 13+
- `POST_NOTIFICATIONS` untuk Android 13+

### iOS

- Semua permissions memerlukan usage description di Info.plist
- Location permission memiliki 3 level: WhenInUse, Always, AlwaysAndWhenInUse
- Photos permission bisa limited (iOS 14+)

## Testing

```dart
// Mock untuk testing
class MockPermissionService extends PermissionService {
  @override
  Future<PermissionStatus> checkPermission(Permission permission) async {
    return PermissionStatus.granted;
  }
  
  @override
  Future<PermissionStatus> requestPermission(Permission permission) async {
    return PermissionStatus.granted;
  }
}
```

## Common Issues

### Issue: Permission always returns denied on emulator
**Solution**: Test on real device untuk hasil akurat

### Issue: iOS permission tidak muncul
**Solution**: Pastikan usage description sudah ditambahkan di Info.plist

### Issue: Android permission tidak work
**Solution**: Check AndroidManifest.xml dan pastikan permission sudah declared

### Issue: Permission dialog tidak muncul setelah permanently denied
**Solution**: 
```dart
if (await permission.isPermanentlyDenied) {
  // Must open settings
  await openAppSettings();
}
```

### Issue: iOS permission tidak work di simulator
**Solution**: Test di real device. Beberapa permissions tidak tersedia di simulator.

### Issue: Android 13+ notification permission
**Solution**: 
```dart
// Add to AndroidManifest.xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

// Request in code
if (Platform.isAndroid) {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}
```

## Additional Resources

### Official Documentation
- [permission_handler package](https://pub.dev/packages/permission_handler) - Official package docs
- [Flutter Documentation](https://docs.flutter.dev/) - Flutter official docs

### Platform Guidelines  
- [Android Runtime Permissions](https://developer.android.com/training/permissions/requesting) - Android best practices
- [iOS App Permissions](https://developer.apple.com/documentation/uikit/protecting_the_user_s_privacy/requesting_access_to_protected_resources) - iOS guidelines

### UX Guidelines
- [Material Design - Permissions](https://m2.material.io/design/platform-guidance/android-permissions.html) - Android UX patterns
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/privacy) - iOS UX patterns

### Related Files
- [README.md](README.md) - Project overview dan setup
- [lib/services/permission_service.dart](lib/services/permission_service.dart) - Permission service implementation
- [lib/widgets/permission_rationale_dialog.dart](lib/widgets/permission_rationale_dialog.dart) - Rationale dialog widget

---

**Need Help?** Check the [Common Issues](#common-issues) section or refer to the official documentation.

**Happy Coding! 🚀**
