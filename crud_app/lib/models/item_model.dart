class ItemModel {
  final int? id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String? category;
  final String? priority;

  ItemModel({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.category,
    this.priority,
  });

  // Convert to Map for Database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
      'priority': priority,
    };
  }

  // Create from Map (Database)
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      category: map['category'] as String?,
      priority: map['priority'] as String?,
    );
  }

  // Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': description, // JSONPlaceholder uses 'body' instead of 'description'
      'userId': 1, // Required by JSONPlaceholder
    };
  }

  // Create from JSON (API)
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      description: json['body'] as String? ?? '',
      createdAt: DateTime.now(), // API doesn't provide date
      category: null,
      priority: null,
    );
  }

  // Copy with method for updates
  ItemModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
    String? category,
    String? priority,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      priority: priority ?? this.priority,
    );
  }
}
