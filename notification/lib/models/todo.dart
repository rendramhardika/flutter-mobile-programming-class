class Todo {
  final String id;
  String title;
  String description;
  bool isDone;
  DateTime createdAt;
  DateTime? completedAt;
  String assignedTo; // User ID untuk notifikasi

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    required this.createdAt,
    this.completedAt,
    required this.assignedTo,
  });

  // Factory constructor untuk create todo baru
  factory Todo.create({
    required String title,
    required String description,
    required String assignedTo,
  }) {
    return Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      assignedTo: assignedTo,
    );
  }

  // Mark as done
  void markAsDone() {
    if (!isDone) {
      isDone = true;
      completedAt = DateTime.now();
    }
  }

  // Toggle status
  void toggleStatus() {
    if (isDone) {
      isDone = false;
      completedAt = null;
    } else {
      markAsDone();
    }
  }

  // Convert to JSON untuk API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'assignedTo': assignedTo,
    };
  }

  // Create from JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isDone: json['isDone'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      assignedTo: json['assignedTo'],
    );
  }

  // Copy with untuk updates
  Todo copyWith({
    String? title,
    String? description,
    bool? isDone,
    DateTime? completedAt,
    String? assignedTo,
  }) {
    return Todo(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdAt: this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}
