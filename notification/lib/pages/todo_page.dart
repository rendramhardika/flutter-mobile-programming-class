import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_api_service.dart';
import '../services/notification_service.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> _todos = [];
  bool _isLoading = false;
  final NotificationService _notificationService = NotificationService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Demo user ID - di production ini dari authentication
      const userId = 'demo_user_123';
      final todos = await TodoApiService.getTodos(userId);
      setState(() {
        _todos = todos;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to load todos: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleTodoStatus(Todo todo) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Toggle status
      todo.toggleStatus();
      
      // Update di backend
      final success = await TodoApiService.updateTodoStatus(todo);
      
      if (success && todo.isDone) {
        // Kirim notifikasi via API jika task selesai
        final fcmToken = _notificationService.fcmToken;
        if (fcmToken != null) {
          await TodoApiService.sendTodoCompletionNotification(
            todo: todo,
            recipientFcmToken: fcmToken,
          );
        }
      }

      setState(() {
        // Update UI dengan status baru
      });

      _showSuccessSnackBar(
        todo.isDone 
          ? '✅ Task completed! Notification sent.'
          : '↩️ Task marked as pending'
      );
    } catch (e) {
      // Revert status jika error
      todo.toggleStatus();
      _showErrorSnackBar('Failed to update todo: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addTodo() async {
    if (_titleController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter a title');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newTodo = Todo.create(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        assignedTo: 'demo_user_123',
      );

      setState(() {
        _todos.add(newTodo);
      });

      // Clear controllers
      _titleController.clear();
      _descriptionController.clear();
      
      // Close dialog
      Navigator.of(context).pop();
      
      _showSuccessSnackBar('✅ Todo added successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to add todo: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter todo title',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter todo description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _titleController.clear();
              _descriptionController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _addTodo,
            child: _isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add Todo'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Todo List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadTodos,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading && _todos.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : _todos.isEmpty
          ? _buildEmptyState()
          : _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _showAddTodoDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add Todo',
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No todos yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first todo',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        return _buildTodoItem(todo, index);
      },
    );
  }

  Widget _buildTodoItem(Todo todo, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Checkbox(
          value: todo.isDone,
          onChanged: _isLoading ? null : (value) {
            _toggleTodoStatus(todo);
          },
          activeColor: Colors.green,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            color: todo.isDone ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                todo.description,
                style: TextStyle(
                  fontSize: 14,
                  color: todo.isDone ? Colors.grey[500] : Colors.grey[700],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  'Created: ${_formatDate(todo.createdAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                if (todo.completedAt != null) ...[
                  const SizedBox(width: 16),
                  Icon(
                    Icons.check_circle,
                    size: 14,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Done: ${_formatDate(todo.completedAt!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: todo.isDone
          ? const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            )
          : Icon(
              Icons.radio_button_unchecked,
              color: Colors.grey[400],
              size: 24,
            ),
        onTap: _isLoading ? null : () => _toggleTodoStatus(todo),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
