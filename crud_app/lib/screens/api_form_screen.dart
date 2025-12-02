import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/item_model.dart';
import '../services/api_service.dart';

class ApiFormScreen extends StatefulWidget {
  final ItemModel? item;

  const ApiFormScreen({super.key, this.item});

  @override
  State<ApiFormScreen> createState() => _ApiFormScreenState();
}

class _ApiFormScreenState extends State<ApiFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ApiService _apiService = ApiService();

  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  String _selectedPriority = 'Medium';
  bool _isLoading = false;
  int _currentStep = 0;

  final List<String> _categories = ['Work', 'Personal', 'Shopping', 'Health', 'Other'];
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _titleController.text = widget.item!.title;
      _descriptionController.text = widget.item!.description;
      _selectedDate = widget.item!.createdAt;
      _selectedCategory = widget.item!.category;
      _selectedPriority = widget.item!.priority ?? 'Medium';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final item = ItemModel(
        id: widget.item?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        createdAt: _selectedDate,
        category: _selectedCategory,
        priority: _selectedPriority,
      );

      ItemModel savedItem;
      if (widget.item == null) {
        savedItem = await _apiService.create(item);
      } else {
        savedItem = await _apiService.update(item);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.item == null
                ? 'Item created successfully'
                : 'Item updated successfully'),
          ),
        );
        Navigator.of(context).pop(savedItem);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving item: $e'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _saveItem,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Create Item' : 'Edit Item'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: _onStepContinue,
                onStepCancel: _onStepCancel,
                onStepTapped: (step) => setState(() => _currentStep = step),
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        if (_currentStep < 2)
                          ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: const Text('Next'),
                          ),
                        if (_currentStep == 2)
                          ElevatedButton(
                            onPressed: _saveItem,
                            child: Text(widget.item == null ? 'Create' : 'Update'),
                          ),
                        const SizedBox(width: 8),
                        if (_currentStep > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Back'),
                          ),
                        if (_currentStep == 0)
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                      ],
                    ),
                  );
                },
                steps: [
                  // Step 1: Basic Information
                  Step(
                    title: const Text('Basic Info'),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                    content: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title *',
                            hintText: 'Enter item title',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.title),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'Enter item description',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.description),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  // Step 2: Details
                  Step(
                    title: const Text('Details'),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Created Date'),
                            subtitle: Text(DateFormat('dd MMMM yyyy').format(_selectedDate)),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: _selectDate,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.category),
                          ),
                          hint: const Text('Select a category'),
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Priority',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          child: Column(
                            children: _priorities.map((priority) {
                              return RadioListTile<String>(
                                title: Text(priority),
                                value: priority,
                                groupValue: _selectedPriority,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPriority = value!;
                                  });
                                },
                                secondary: Icon(
                                  Icons.flag,
                                  color: _getPriorityColor(priority),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Step 3: Review
                  Step(
                    title: const Text('Review'),
                    isActive: _currentStep >= 2,
                    state: StepState.indexed,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Review Your Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildReviewItem('Title', _titleController.text),
                        _buildReviewItem('Description', _descriptionController.text),
                        _buildReviewItem('Date', DateFormat('dd MMMM yyyy').format(_selectedDate)),
                        _buildReviewItem('Category', _selectedCategory ?? 'Not selected'),
                        _buildReviewItem('Priority', _selectedPriority),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          subtitle: Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      // Validate step 1
      if (_titleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a title')),
        );
        return;
      }
      if (_descriptionController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a description')),
        );
        return;
      }
    }
    
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
