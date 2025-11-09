import 'package:intl/intl.dart';

class Assignment {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority;
  int percentage; // Persentase penyelesaian tugas
  bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.percentage = 0, // Default ke 0% complete
    this.isCompleted = false,
  }) {
    // Auto-set isCompleted ke true jika percentage adalah 100
    if (percentage == 100) {
      isCompleted = true;
    }
  }

  String get formattedDueDate {
    return DateFormat('dd MMM yyyy').format(dueDate);
  }
  
  // Cek status deadline
  bool get isNearDeadline {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    // Jika tugas belum selesai dan deadline kurang dari atau sama dengan 2 hari
    return !isCompleted && difference <= 2 && difference >= 0;
  }
  
  // Cek apakah tugas sudah melewati deadline
  bool get isOverdue {
    final now = DateTime.now();
    return !isCompleted && dueDate.isBefore(now);
  }
}
