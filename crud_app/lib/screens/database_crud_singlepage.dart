import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/database_service.dart';
import '../widgets/item_card.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/simple_form_dialog.dart';

class DatabaseCrudSinglePage extends StatefulWidget {
  const DatabaseCrudSinglePage({super.key});

  @override
  State<DatabaseCrudSinglePage> createState() => _DatabaseCrudSinglePageState();
}

class _DatabaseCrudSinglePageState extends State<DatabaseCrudSinglePage> {
  final DatabaseService _dbService = DatabaseService.instance;
  List<ItemModel> _items = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await _dbService.readAll();
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading items: $e')),
        );
      }
    }
  }

  Future<void> _saveItem(ItemModel item) async {
    try {
      if (item.id == null) {
        await _dbService.create(item);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item created successfully')),
          );
        }
      } else {
        await _dbService.update(item);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item updated successfully')),
          );
        }
      }
      _loadItems();
    } catch (e) {
      throw Exception('Failed to save item: $e');
    }
  }

  Future<void> _deleteItem(int id) async {
    try {
      await _dbService.delete(id);
      _loadItems();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting item: $e')),
        );
      }
    }
  }

  void _showFormDialog({ItemModel? item}) {
    showDialog(
      context: context,
      builder: (context) => SimpleFormDialog(
        item: item,
        onSave: _saveItem,
      ),
    );
  }

  void _showDeleteConfirmation(ItemModel item) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: 'Delete Item',
        content: 'Are you sure you want to delete "${item.title}"?',
        onConfirm: () => _deleteItem(item.id!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database CRUD - Single Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadItems,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadItems,
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return ItemCard(
                        item: item,
                        onTap: () => _showFormDialog(item: item),
                        onDelete: () => _showDeleteConfirmation(item),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFormDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No items yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first item',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
