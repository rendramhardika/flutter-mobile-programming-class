import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_item.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({super.key});

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int _percentage = 0; // Added percentage value
  
  @override
  void initState() {
    super.initState();
    _dueDateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dueDateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tugas Baru'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Due date field
              TextFormField(
                controller: _dueDateController,
                decoration: const InputDecoration(
                  labelText: 'Deadline',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 30),
              
              // Progress percentage slider
              const Text(
                'Progress Pengerjaan:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _percentage.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 20,
                      label: '$_percentage%',
                      onChanged: (double value) {
                        setState(() {
                          _percentage = value.round();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      '$_percentage%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _percentage == 100 ? Colors.green : Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: _percentage / 100,
                backgroundColor: Colors.grey[300],
                color: _percentage == 100 ? Colors.green : Colors.blue,
                minHeight: 8,
              ),
              const SizedBox(height: 30),
              
              // Priority selection
              const Text(
                'Prioritas:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              // Priority radio buttons
              _buildPriorityRadio(),
              const SizedBox(height: 30),
              
              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create new data item
                    final newItem = DataItem(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      dueDate: _selectedDate,
                      priority: _priority,
                      percentage: _percentage, // Include percentage value
                      isCompleted: _percentage == 100, // Set based on percentage
                    );
                    
                    // Return new item to previous page
                    Navigator.pop(context, newItem);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Priority selection widget
  Widget _buildPriorityRadio() {
    return Column(
      children: [
        RadioListTile<String>(
          title: Row(
            children: [
              const Text('Tinggi'),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'TINGGI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          value: 'high',
          groupValue: _priority,
          onChanged: (value) {
            setState(() {
              _priority = value!;
            });
          },
          secondary: const Icon(Icons.priority_high, color: Colors.red),
        ),
        RadioListTile<String>(
          title: Row(
            children: [
              const Text('Sedang'),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'SEDANG',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          value: 'medium',
          groupValue: _priority,
          onChanged: (value) {
            setState(() {
              _priority = value!;
            });
          },
          secondary: const Icon(Icons.remove_circle, color: Colors.orange),
        ),
        RadioListTile<String>(
          title: Row(
            children: [
              const Text('Rendah'),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'RENDAH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          value: 'low',
          groupValue: _priority,
          onChanged: (value) {
            setState(() {
              _priority = value!;
            });
          },
          secondary: const Icon(Icons.arrow_downward, color: Colors.green),
        ),
      ],
    );
  }
  
  String _priority = 'medium'; // Default priority
}
