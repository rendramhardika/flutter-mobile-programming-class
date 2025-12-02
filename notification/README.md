# 🔔 Flutter Push Notification Demo

Aplikasi Flutter yang mendemonstrasikan implementasi lengkap **Firebase Cloud Messaging (FCM)** dengan **local notifications** dan integrasi **Todo List** untuk pembelajaran notification handling di berbagai state aplikasi.

## 🎯 Tujuan Pembelajaran

Project ini dibuat untuk memahami:
- ✅ **Firebase Cloud Messaging (FCM)** - Push notification dari server
- ✅ **Local Notifications** - Notifikasi lokal dengan flutter_local_notifications
- ✅ **FCM Token Management** - Mendapatkan dan mengelola device token
- ✅ **Background & Foreground Handling** - Menangani notifikasi di berbagai app state
- ✅ **Notification Channels** - Android notification channels
- ✅ **API Integration** - Mengirim notifikasi via FCM API
- ✅ **Real-world Use Case** - Todo list dengan notifikasi otomatis

## 📱 Fitur Utama

### 1. 🔥 Firebase Cloud Messaging (FCM)
- ✅ FCM token generation dan display
- ✅ Token refresh handling
- ✅ Push notification dari Firebase Console
- ✅ Push notification via FCM API
- ✅ Foreground message handling
- ✅ Background message handling
- ✅ Notification tap/click handling

### 2. 📲 Local Notifications
- ✅ Local notification dengan custom channel
- ✅ Notification dengan title, body, dan payload
- ✅ Test notification button
- ✅ Android notification channels
- ✅ iOS notification permissions

### 3. 📝 Todo List Demo
- ✅ Create, read, update todo items
- ✅ Mark todo as done/pending
- ✅ Automatic notification saat task completed
- ✅ FCM API integration untuk kirim notifikasi
- ✅ Real-time UI updates

### 4. 🔐 Token Management
- ✅ Display FCM token di UI
- ✅ Copy token untuk testing
- ✅ Submit token ke backend API
- ✅ Token refresh listener

### 5. 🎨 UI/UX Features
- ✅ Clean dan modern interface
- ✅ Loading indicators
- ✅ Success/error feedback
- ✅ Selectable FCM token
- ✅ Instructions untuk testing

## 🛠️ Teknologi & Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  
  # Firebase
  firebase_core: ^3.8.0              # Firebase core SDK
  firebase_messaging: ^15.1.6        # FCM untuk push notifications
  
  # Local Notifications
  flutter_local_notifications: ^17.2.3  # Local notification handling
  
  # HTTP Client
  http: ^1.2.2                       # HTTP requests untuk FCM API
```

**Package Details:**
- **firebase_core**: Initialize Firebase dalam Flutter app
- **firebase_messaging**: Handle FCM push notifications
- **flutter_local_notifications**: Show local notifications dengan custom channels
- **http**: Make HTTP requests ke FCM API untuk kirim notifikasi

## 📂 Struktur Project

```
lib/
├── main.dart                          # Entry point aplikasi
├── models/
│   └── todo.dart                      # Model data Todo
├── pages/
│   └── todo_page.dart                 # Halaman Todo List
└── services/
    ├── notification_service.dart      # Service untuk FCM & local notifications
    └── todo_api_service.dart          # Service untuk API Todo & kirim notifikasi
```

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK**: 3.9.0 atau lebih tinggi
- **Dart SDK**: 3.9.0 atau lebih tinggi
- **Firebase Account**: Untuk membuat Firebase project
- **IDE**: Android Studio / VS Code dengan Flutter extension
- **Device**: Physical device (recommended) atau emulator
- **Note**: iOS simulator tidak support push notifications

### Setup Firebase

#### 1. Buat Firebase Project

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik "Add project" atau "Create a project"
3. Masukkan project name (contoh: "Flutter Notification Demo")
4. Enable Google Analytics (optional)
5. Klik "Create project"

#### 2. Tambahkan Android App

1. Di Firebase Console, klik "Add app" → pilih Android icon
2. Masukkan **Android package name**: `com.example.notification`
   - Cek di `android/app/build.gradle` → `applicationId`
3. Download `google-services.json`
4. Letakkan file di: `android/app/google-services.json`
5. Follow setup instructions di Firebase Console

#### 3. Tambahkan iOS App (Optional)

1. Di Firebase Console, klik "Add app" → pilih iOS icon
2. Masukkan **iOS bundle ID**: `com.example.notification`
   - Cek di `ios/Runner.xcodeproj/project.pbxproj` → `PRODUCT_BUNDLE_IDENTIFIER`
3. Download `GoogleService-Info.plist`
4. Buka `ios/Runner.xcworkspace` di Xcode
5. Drag `GoogleService-Info.plist` ke Runner folder
6. Enable capabilities:
   - Push Notifications
   - Background Modes → Remote notifications

#### 4. Get FCM Server Key

1. Firebase Console → Project Settings (⚙️)
2. Tab "Cloud Messaging"
3. Copy **Server key** (Legacy)
4. Update di `lib/services/todo_api_service.dart`:

```dart
static const String fcmServerKey = 'YOUR_ACTUAL_FCM_SERVER_KEY';
```

### Instalasi

1. **Clone repository**
```bash
git clone https://github.com/rendramhardika/flutter-mobile-programming-class.git
cd flutter-mobile-programming-class/notification
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run aplikasi**
```bash
flutter run
```

**Important:** Test di **physical device** untuk full functionality. Emulator/simulator memiliki keterbatasan untuk push notifications.

## 📖 Cara Menggunakan

### 1. Testing FCM Token

**Langkah:**
1. Buka aplikasi
2. FCM Token akan ditampilkan di card pertama
3. Token bisa di-copy dengan long press atau select
4. Simpan token untuk testing

**FCM Token Format:**
```
eXaMpLe_FcM_ToKeN:APA91bH...(very long string)
```

### 2. Testing Local Notification

**Langkah:**
1. Tap tombol **"Send Test Local Notification"**
2. Notifikasi akan muncul di notification tray
3. Tap notifikasi untuk buka app

**Expected Result:**
- Title: "Test Notification"
- Body: "This is a test local notification"
- Sound & vibration (jika enabled)

### 3. Testing Push Notification via Firebase Console

**Langkah:**
1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project Anda
3. Navigate ke **Cloud Messaging** (di sidebar)
4. Klik **"Send your first message"** atau **"New campaign"**
5. Isi notification:
   - **Notification title**: "Test dari Firebase"
   - **Notification text**: "Ini test push notification"
6. Klik **"Send test message"**
7. Paste **FCM Token** dari app
8. Klik **"Test"**

**Testing Scenarios:**
- **App di foreground**: Notifikasi muncul sebagai local notification
- **App di background**: Notifikasi muncul di notification tray
- **App terminated**: Notifikasi muncul di notification tray
- **Tap notification**: App terbuka dan message di-handle

### 4. Testing Push Notification via API (Postman/cURL)

**cURL Command:**
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Content-Type: application/json" \
  -H "Authorization: key=YOUR_FCM_SERVER_KEY" \
  -d '{
    "to": "YOUR_FCM_TOKEN_HERE",
    "notification": {
      "title": "Test dari API",
      "body": "Ini test notification via FCM API"
    },
    "data": {
      "custom_key": "custom_value",
      "action": "open_page"
    },
    "priority": "high"
  }'
```

**Postman Setup:**
1. Method: **POST**
2. URL: `https://fcm.googleapis.com/fcm/send`
3. Headers:
   - `Content-Type`: `application/json`
   - `Authorization`: `key=YOUR_FCM_SERVER_KEY`
4. Body (raw JSON):
```json
{
  "to": "YOUR_FCM_TOKEN",
  "notification": {
    "title": "Test Notification",
    "body": "This is a test message"
  },
  "data": {
    "type": "test",
    "timestamp": "2024-01-01T00:00:00Z"
  }
}
```

### 5. Testing Todo List dengan Notifikasi

**Langkah:**
1. Tap tombol **"📝 Todo List Demo"**
2. Tap **FAB (+)** untuk add todo
3. Isi form:
   - **Title**: "Complete project documentation"
   - **Description**: "Write comprehensive README"
4. Tap **"Add Todo"**
5. Tap **checkbox** atau **todo item** untuk mark as done
6. Notifikasi otomatis akan dikirim via FCM API
7. Notifikasi akan muncul: "✅ Task Completed!"

**Flow Diagram:**
```
User marks todo as done
    ↓
Todo status updated
    ↓
API call ke FCM
    ↓
FCM kirim notification ke device
    ↓
Notification muncul di device
```

### 6. Submit Token ke Backend

**Langkah:**
1. Tap tombol **"Submit Token to Backend"**
2. Token akan dikirim ke backend API
3. Snackbar akan muncul dengan status

**Note:** Perlu konfigurasi backend endpoint di `NotificationService`

**Backend Payload:**
```json
{
  "user_id": "demo_user_123",
  "fcm_token": "eXaMpLe_FcM_ToKeN...",
  "device_name": "Flutter Test Device",
  "user_email": "demo@example.com",
  "platform": "android",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

## 💡 Konsep & Implementasi

### 1. NotificationService Architecture

**Singleton Pattern:**
```dart
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  
  String? _fcmToken;
  String? get fcmToken => _fcmToken;
}
```

**Initialization Flow:**
```dart
Future<void> initialize() async {
  // 1. Request permissions
  await _requestPermissions();
  
  // 2. Initialize local notifications
  await _initializeLocalNotifications();
  
  // 3. Initialize Firebase Messaging
  await _initializeFirebaseMessaging();
}
```

### 2. FCM Token Management

**Get Token:**
```dart
_fcmToken = await _firebaseMessaging.getToken();
debugPrint('FCM Token: $_fcmToken');
```

**Token Refresh:**
```dart
_firebaseMessaging.onTokenRefresh.listen((token) {
  _fcmToken = token;
  debugPrint('FCM Token refreshed: $token');
  // Send updated token to backend
});
```

**Submit to Backend:**
```dart
Future<void> submitTokenToBackend({
  required String userId,
  required String apiEndpoint,
  Map<String, dynamic>? additionalData,
}) async {
  final response = await http.post(
    Uri.parse(apiEndpoint),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'user_id': userId,
      'fcm_token': _fcmToken,
      'platform': Platform.isAndroid ? 'android' : 'ios',
      ...?additionalData,
    }),
  );
}
```

### 3. Notification Handling

**Foreground Messages:**
```dart
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  debugPrint('Foreground message: ${message.notification?.title}');
  
  // Show as local notification
  _showLocalNotification(message);
  
  // Add to stream for UI updates
  _messageStreamController.add(message);
});
```

**Background Messages:**
```dart
// Top-level function (required)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message
) async {
  debugPrint('Background message: ${message.messageId}');
  // Handle background message
}

// Register handler
FirebaseMessaging.onBackgroundMessage(
  firebaseMessagingBackgroundHandler
);
```

**Message Opened App:**
```dart
// App opened from notification tap
FirebaseMessaging.onMessageOpenedApp.listen((message) {
  debugPrint('App opened from notification');
  // Navigate to specific page based on message data
});

// App opened from terminated state
final initialMessage = await _firebaseMessaging.getInitialMessage();
if (initialMessage != null) {
  // Handle initial message
}
```

### 4. Local Notifications

**Android Notification Channel:**
```dart
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

await _localNotifications
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(channel);
```

**Show Notification:**
```dart
Future<void> _showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: true,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  await _localNotifications.show(
    message.hashCode,
    message.notification?.title ?? 'New Notification',
    message.notification?.body ?? 'You have a new message',
    platformDetails,
    payload: message.data.toString(),
  );
}
```

### 5. Send Notification via FCM API

**Implementation:**
```dart
static Future<bool> sendTodoCompletionNotification({
  required Todo todo,
  required String recipientFcmToken,
}) async {
  final notificationPayload = {
    'to': recipientFcmToken,
    'notification': {
      'title': '✅ Task Completed!',
      'body': '${todo.title} has been marked as done',
    },
    'data': {
      'type': 'todo_completed',
      'todo_id': todo.id,
      'todo_title': todo.title,
      'completed_at': todo.completedAt?.toIso8601String() ?? '',
    },
    'android': {
      'priority': 'high',
      'notification': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'sound': 'default',
      },
    },
    'apns': {
      'payload': {
        'aps': {
          'sound': 'default',
          'badge': 1,
        },
      },
    },
  };

  final response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmServerKey',
    },
    body: json.encode(notificationPayload),
  );

  return response.statusCode == 200;
}
```

### 6. Todo Integration

**Toggle Todo Status:**
```dart
Future<void> _toggleTodoStatus(Todo todo) async {
  // Toggle status
  todo.toggleStatus();
  
  // Update backend
  final success = await TodoApiService.updateTodoStatus(todo);
  
  if (success && todo.isDone) {
    // Send notification via FCM API
    final fcmToken = _notificationService.fcmToken;
    if (fcmToken != null) {
      await TodoApiService.sendTodoCompletionNotification(
        todo: todo,
        recipientFcmToken: fcmToken,
      );
    }
  }
  
  setState(() {});
}
```

## 🔧 Konfigurasi Platform

### Android Configuration

**1. AndroidManifest.xml**

File: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest>
    <!-- Internet permission -->
    <uses-permission android:name="android.permission.INTERNET" />
    
    <!-- Notification permission (Android 13+) -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    
    <application>
        <!-- FCM default notification icon -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@mipmap/ic_launcher" />
        
        <!-- FCM default notification color -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_color"
            android:resource="@color/colorAccent" />
    </application>
</manifest>
```

**2. build.gradle (Project Level)**

File: `android/build.gradle`

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**3. build.gradle (App Level)**

File: `android/app/build.gradle`

```gradle
apply plugin: 'com.google.gms.google-services'

android {
    defaultConfig {
        minSdkVersion 21  // Minimum untuk FCM
    }
}
```

**4. google-services.json**

Letakkan di: `android/app/google-services.json`

### iOS Configuration

**1. Info.plist**

File: `ios/Runner/Info.plist`

```xml
<dict>
    <!-- Notification permissions -->
    <key>UIBackgroundModes</key>
    <array>
        <string>remote-notification</string>
    </array>
</dict>
```

**2. Xcode Capabilities**

1. Buka `ios/Runner.xcworkspace` di Xcode
2. Select **Runner** project
3. Tab **Signing & Capabilities**
4. Klik **+ Capability**
5. Add **Push Notifications**
6. Add **Background Modes**
7. Check **Remote notifications**

**3. APNs Certificate**

1. Firebase Console → Project Settings
2. Tab **Cloud Messaging**
3. Scroll ke **Apple app configuration**
4. Upload **APNs Authentication Key** atau **APNs Certificate**

**4. GoogleService-Info.plist**

1. Download dari Firebase Console
2. Drag ke Xcode Runner folder
3. Ensure "Copy items if needed" checked
4. Add to target: Runner

### Web Configuration (Optional)

**1. firebase-messaging-sw.js**

File: `web/firebase-messaging-sw.js`

```javascript
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_STORAGE_BUCKET",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
});

const messaging = firebase.messaging();
```

## 🎯 Notification States & Handling

### App States

| State | Description | Handling |
|-------|-------------|----------|
| **Foreground** | App aktif di layar | `FirebaseMessaging.onMessage` → Show local notification |
| **Background** | App di background | `FirebaseMessaging.onBackgroundMessage` → System notification |
| **Terminated** | App closed completely | `getInitialMessage()` → Handle on app start |
| **Notification Tap** | User tap notification | `onMessageOpenedApp` → Navigate to page |

### Message Types

**1. Notification Message**
```json
{
  "to": "FCM_TOKEN",
  "notification": {
    "title": "Title",
    "body": "Body text"
  }
}
```
- Handled automatically by system
- Shows in notification tray
- Limited customization

**2. Data Message**
```json
{
  "to": "FCM_TOKEN",
  "data": {
    "type": "custom",
    "action": "open_page",
    "page_id": "123"
  }
}
```
- Always delivered to app
- Requires manual handling
- Full customization

**3. Combined Message (Recommended)**
```json
{
  "to": "FCM_TOKEN",
  "notification": {
    "title": "Title",
    "body": "Body"
  },
  "data": {
    "type": "custom",
    "action": "open_page"
  }
}
```
- Best of both worlds
- System notification + custom data
- Most flexible

## 🎨 Best Practices

### 1. Token Management

✅ **DO:**
- Store token di backend dengan user ID
- Update token saat refresh
- Handle token refresh listener
- Remove token saat logout

❌ **DON'T:**
- Hardcode token di app
- Ignore token refresh
- Keep old tokens after logout

### 2. Notification Content

✅ **DO:**
- Clear dan concise title
- Actionable body text
- Include relevant data payload
- Use appropriate priority

❌ **DON'T:**
- Generic titles ("Notification")
- Too long body text
- Missing data for navigation
- Spam users dengan notifications

### 3. Error Handling

```dart
try {
  await _notificationService.initialize();
} catch (e) {
  debugPrint('Failed to initialize: $e');
  // Show error to user
  // Retry logic
}
```

### 4. Testing Strategy

1. **Unit Tests**: Test service methods
2. **Integration Tests**: Test FCM flow
3. **Manual Tests**: Test di different states
4. **Device Tests**: Test di real devices

### 5. Performance

- ✅ Initialize di main() sebelum runApp()
- ✅ Use singleton pattern untuk services
- ✅ Dispose stream controllers
- ✅ Handle errors gracefully
- ✅ Don't block UI thread

## 🐛 Troubleshooting

### Problem: Notifikasi tidak muncul di Android

**Possible Causes:**
1. Notification permission tidak granted (Android 13+)
2. Notification channel tidak dibuat
3. App di battery optimization
4. FCM token tidak valid

**Solutions:**
```dart
// 1. Check permission
final granted = await _localNotifications
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
    ?.areNotificationsEnabled();

if (!granted) {
  // Request permission
  await _localNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

// 2. Verify channel created
await _localNotifications
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(channel);

// 3. Check battery optimization
// Settings → Apps → Your App → Battery → Unrestricted

// 4. Verify FCM token
final token = await FirebaseMessaging.instance.getToken();
debugPrint('FCM Token: $token');
```

### Problem: Notifikasi tidak muncul di iOS

**Possible Causes:**
1. Push Notifications capability tidak enabled
2. APNs certificate tidak configured
3. Testing di simulator (tidak support)
4. Permission tidak granted

**Solutions:**
1. **Enable Push Notifications:**
   - Xcode → Runner → Signing & Capabilities
   - Add "Push Notifications"
   - Add "Background Modes" → "Remote notifications"

2. **Configure APNs:**
   - Firebase Console → Project Settings → Cloud Messaging
   - Upload APNs Authentication Key atau Certificate

3. **Test di Real Device:**
   - iOS Simulator tidak support push notifications
   - Gunakan physical iPhone/iPad

4. **Check Permission:**
```dart
final settings = await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);

if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  debugPrint('Permission granted');
} else {
  debugPrint('Permission denied');
}
```

### Problem: FCM Token null atau undefined

**Possible Causes:**
1. Firebase tidak initialized
2. google-services.json / GoogleService-Info.plist missing
3. No internet connection
4. Firebase configuration error

**Solutions:**
```dart
// 1. Ensure Firebase initialized
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Must be before runApp()
  runApp(MyApp());
}

// 2. Verify configuration files
// Android: android/app/google-services.json
// iOS: ios/Runner/GoogleService-Info.plist

// 3. Check internet
final connectivityResult = await Connectivity().checkConnectivity();

// 4. Debug Firebase
try {
  await Firebase.initializeApp();
  final token = await FirebaseMessaging.instance.getToken();
  debugPrint('Token: $token');
} catch (e) {
  debugPrint('Firebase error: $e');
}
```

### Problem: Background messages tidak handled

**Solution:**
```dart
// Must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message
) async {
  await Firebase.initializeApp();
  debugPrint('Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Register background handler
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler
  );
  
  runApp(MyApp());
}
```

### Problem: Notification tap tidak navigate

**Solution:**
```dart
// Handle notification tap
FirebaseMessaging.onMessageOpenedApp.listen((message) {
  final data = message.data;
  
  if (data['action'] == 'open_page') {
    Navigator.pushNamed(
      context,
      '/page',
      arguments: data['page_id'],
    );
  }
});

// Handle initial message (app terminated)
final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
if (initialMessage != null) {
  // Handle navigation after app fully loaded
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Navigate based on message data
  });
}
```

### Problem: FCM API returns 401 Unauthorized

**Solution:**
1. Verify FCM Server Key correct
2. Check Authorization header format: `key=YOUR_SERVER_KEY`
3. Ensure Server Key dari Firebase Console → Cloud Messaging

```bash
# Correct format
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=AAAA..." \
  -H "Content-Type: application/json" \
  -d '{"to":"TOKEN","notification":{"title":"Test"}}'
```

### Problem: Too many notifications

**Solution:**
```dart
// Implement notification grouping
const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
  'channel_id',
  'Channel Name',
  groupKey: 'com.example.notification.GROUP',
  setAsGroupSummary: true,
);

// Implement notification limits
int _notificationCount = 0;
const int _maxNotifications = 5;

Future<void> showNotification() async {
  if (_notificationCount >= _maxNotifications) {
    debugPrint('Notification limit reached');
    return;
  }
  
  _notificationCount++;
  await _localNotifications.show(...);
}
```

## 🧪 Testing Checklist

### Android Testing

- [ ] App foreground: Notification muncul
- [ ] App background: Notification di tray
- [ ] App terminated: Notification di tray
- [ ] Tap notification: App opens
- [ ] Local notification: Works
- [ ] FCM token: Displayed correctly
- [ ] Token refresh: Handled
- [ ] Permission request: Works (Android 13+)
- [ ] Notification channel: Created
- [ ] Todo completion: Notification sent

### iOS Testing

- [ ] App foreground: Notification muncul
- [ ] App background: Notification di tray
- [ ] App terminated: Notification di tray
- [ ] Tap notification: App opens
- [ ] Local notification: Works
- [ ] FCM token: Displayed correctly
- [ ] Token refresh: Handled
- [ ] Permission request: Works
- [ ] APNs configured: Yes
- [ ] Todo completion: Notification sent

### API Testing

- [ ] Firebase Console: Send test message works
- [ ] cURL: FCM API works
- [ ] Postman: FCM API works
- [ ] Todo API: Notification sent
- [ ] Token submit: Backend receives token
- [ ] Error handling: Proper error messages

## 🎓 Learning Points

### Beginner Level
- ✅ **Firebase Setup** - Configure Firebase project
- ✅ **FCM Token** - Get dan display device token
- ✅ **Local Notifications** - Show basic notifications
- ✅ **Permission Handling** - Request notification permissions
- ✅ **Firebase Console** - Send test notifications

### Intermediate Level
- ✅ **Foreground Handling** - Handle messages saat app active
- ✅ **Background Handling** - Handle messages saat app background
- ✅ **Notification Channels** - Android notification channels
- ✅ **Token Management** - Submit token ke backend
- ✅ **Stream Controllers** - Listen notification events

### Advanced Level
- ✅ **FCM API Integration** - Send notifications via API
- ✅ **Custom Payloads** - Handle custom data
- ✅ **Navigation** - Navigate based on notification data
- ✅ **Singleton Pattern** - Service architecture
- ✅ **Error Handling** - Proper error handling

## 🚀 Next Steps

Setelah memahami project ini, coba:

1. **Add Topic Subscription**
   - Subscribe ke FCM topics
   - Send notification ke topic
   - Unsubscribe dari topics

2. **Implement Notification History**
   - Save received notifications
   - Display notification list
   - Mark as read/unread

3. **Add Rich Notifications**
   - Image notifications
   - Action buttons
   - Custom sounds

4. **Implement Backend**
   - Create REST API untuk token management
   - Store tokens di database
   - Send targeted notifications

5. **Add Analytics**
   - Track notification opens
   - Track user engagement
   - A/B testing notifications

6. **Implement Notification Scheduling**
   - Schedule local notifications
   - Recurring notifications
   - Cancel scheduled notifications

7. **Add User Preferences**
   - Notification settings page
   - Enable/disable notifications
   - Notification categories

8. **Multi-language Support**
   - Localized notification content
   - Language-specific notifications

## 📚 Resources

### Official Documentation
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [Firebase Messaging Plugin](https://pub.dev/packages/firebase_messaging)
- [FCM HTTP v1 API](https://firebase.google.com/docs/cloud-messaging/migrate-v1)

### Tutorials
- [Flutter Push Notifications Guide](https://firebase.flutter.dev/docs/messaging/overview/)
- [FCM Best Practices](https://firebase.google.com/docs/cloud-messaging/concept-options)
- [Android Notification Channels](https://developer.android.com/develop/ui/views/notifications/channels)

### Tools
- [Firebase Console](https://console.firebase.google.com/)
- [Postman](https://www.postman.com/) - For API testing
- [FCM Tester](https://github.com/firebase/quickstart-android/tree/master/messaging) - Testing tool

## 🤝 Contributing

Contributions are welcome! Silakan:
1. Fork repository ini
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

MIT License - Free to use untuk pembelajaran dan development.

## 👨‍💻 Author

Project ini dibuat untuk keperluan pembelajaran Flutter Mobile Programming.

---

**Dibuat dengan ❤️ menggunakan Flutter & Firebase**

Mulai dengan setup Firebase project dan explore berbagai notification scenarios!
