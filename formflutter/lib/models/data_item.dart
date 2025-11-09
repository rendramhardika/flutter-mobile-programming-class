import 'package:intl/intl.dart';

class DataItem {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority;
  int percentage; // Added percentage field for completion progress
  bool isCompleted;

  DataItem({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.percentage = 0, // Default to 0% complete
    this.isCompleted = false,
  }) {
    // Auto-set isCompleted to true if percentage is 100
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
    // Gunakan DateTime yang hanya menyimpan tanggal (tanpa waktu) untuk perbandingan yang lebih akurat
    final todayDate = DateTime(now.year, now.month, now.day);
    final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);
    
    // Hitung selisih dalam hari
    final difference = dueDateOnly.difference(todayDate).inDays;
    
    // Jika tugas belum selesai dan deadline kurang dari atau sama dengan 2 hari
    return !isCompleted && difference <= 2 && difference >= 0;
  }
  
  // Cek apakah tugas sudah melewati deadline
  bool get isOverdue {
    final now = DateTime.now();
    // Gunakan DateTime yang hanya menyimpan tanggal (tanpa waktu) untuk perbandingan yang lebih akurat
    final todayDate = DateTime(now.year, now.month, now.day);
    final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);
    
    // Tugas dianggap overdue jika tanggal deadline sudah lewat dari hari ini
    return !isCompleted && dueDateOnly.isBefore(todayDate);
  }
}
