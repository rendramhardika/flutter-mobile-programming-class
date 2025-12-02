import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class TodoApiService {
  // Ganti dengan backend URL Anda
  static const String baseUrl = 'https://your-backend.com/api';
  
  // FCM Server Key (seharusnya di backend, ini hanya untuk demo)
  // Ganti dengan actual server key dari Firebase Console → Project Settings → Cloud Messaging
  static const String fcmServerKey = 'YOUR_ACTUAL_FCM_SERVER_KEY';

  /// Send notification when todo is completed
  static Future<bool> sendTodoCompletionNotification({
    required Todo todo,
    required String recipientFcmToken,
  }) async {
    try {
      // Create notification payload
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
          'action': 'view_todo',
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

      // Send to FCM API
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmServerKey',
        },
        body: json.encode(notificationPayload),
      );

      if (response.statusCode == 200) {
        print('Todo completion notification sent successfully');
        return true;
      } else {
        print('Failed to send notification: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error sending todo notification: $e');
      return false;
    }
  }

  /// Update todo status di backend (simulasi)
  static Future<bool> updateTodoStatus(Todo todo) async {
    try {
      // Simulasi API call ke backend
      // Di production, ini应该是真正的 HTTP request ke server Anda
      
      print('Updating todo ${todo.id} status to: ${todo.isDone ? 'done' : 'pending'}');
      
      // Simulasi network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulasi success response
      print('Todo status updated successfully in backend');
      return true;
      
      // Contoh implementasi sebenarnya:
      /*
      final response = await http.put(
        Uri.parse('$baseUrl/todos/${todo.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(todo.toJson()),
      );
      
      return response.statusCode == 200;
      */
    } catch (e) {
      print('Error updating todo status: $e');
      return false;
    }
  }

  /// Get todos dari backend (simulasi)
  static Future<List<Todo>> getTodos(String userId) async {
    try {
      // Simulasi API call
      print('Fetching todos for user: $userId');
      
      // Simulasi network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return sample todos untuk demo
      return [
        Todo.create(
          title: 'Complete Flutter project',
          description: 'Finish push notification implementation',
          assignedTo: userId,
        ),
        Todo.create(
          title: 'Review code changes',
          description: 'Check pull requests and provide feedback',
          assignedTo: userId,
        ),
        Todo.create(
          title: 'Update documentation',
          description: 'Add API documentation for new features',
          assignedTo: userId,
        ),
      ];
      
      // Contoh implementasi sebenarnya:
      /*
      final response = await http.get(
        Uri.parse('$baseUrl/todos?userId=$userId'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Todo.fromJson(json)).toList();
      }
      return [];
      */
    } catch (e) {
      print('Error fetching todos: $e');
      return [];
    }
  }

  /// Send custom notification untuk testing
  static Future<bool> sendCustomNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final payload = {
        'to': fcmToken,
        'notification': {'title': title, 'body': body},
        'data': data ?? {},
      };

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmServerKey',
        },
        body: json.encode(payload),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending custom notification: $e');
      return false;
    }
  }
}
