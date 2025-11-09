import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_item.dart';

class EditTaskPage extends StatefulWidget {
  final DataItem task;

  const EditTaskPage({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late int _percentage;
  late bool _isCompleted;
  late DateTime _dueDate;
  late String _priority; // Tambahkan variabel untuk menyimpan prioritas
  final TextEditingController _dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _percentage = widget.task.percentage;
    _isCompleted = widget.task.isCompleted;
    _dueDate = widget.task.dueDate;
    _priority = widget.task.priority; // Inisialisasi nilai prioritas
    _dueDateController.text = DateFormat('dd/MM/yyyy').format(_dueDate);
  }

  @override
  void dispose() {
    _dueDateController.dispose();
    super.dispose();
  }

  // Pilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)), // Memungkinkan set tanggal mundur 30 hari
      lastDate: DateTime.now().add(const Duration(days: 365)), // Maksimal 1 tahun ke depan
    );
    
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('dd/MM/yyyy').format(_dueDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tugas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan judul tugas
            Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Tugas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.task.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.task.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            
            // Prioritas Tugas
            Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prioritas Tugas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tampilkan prioritas saat ini
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(_priority),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _getPriorityText(_priority),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Radio buttons untuk memilih prioritas
                    _buildPriorityRadio(),
                  ],
                ),
              ),
            ),

            // Status Tugas
            Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status Tugas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Selesai'),
                      subtitle: const Text('Tandai tugas sebagai selesai'),
                      value: _isCompleted,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        setState(() {
                          _isCompleted = value;
                          if (_isCompleted) {
                            _percentage = 100;
                          } else if (_percentage == 100) {
                            _percentage = 90;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Progress Tugas
            Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress Tugas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Progress: $_percentage%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _percentage == 100 ? Colors.green : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _percentage / 100,
                      backgroundColor: Colors.grey[300],
                      color: _percentage == 100 ? Colors.green : Colors.blue,
                      minHeight: 10,
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: _percentage.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 20,
                      label: '$_percentage%',
                      onChanged: (double value) {
                        setState(() {
                          _percentage = value.round();
                          _isCompleted = _percentage == 100;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Deadline Tugas
            Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Deadline Tugas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dueDateController,
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Deadline',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    if (_isDeadlineWarning())
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isDeadlineOverdue() ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _isDeadlineOverdue() ? Colors.red : Colors.orange,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isDeadlineOverdue() ? Icons.warning_amber_rounded : Icons.access_time,
                              color: _isDeadlineOverdue() ? Colors.red : Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _getDeadlineWarningText(),
                                style: TextStyle(
                                  color: _isDeadlineOverdue() ? Colors.red : Colors.orange,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('BATAL'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Buat objek DataItem baru dengan data yang diperbarui
                  final updatedTask = DataItem(
                    id: widget.task.id,
                    title: widget.task.title,
                    description: widget.task.description,
                    dueDate: _dueDate,
                    priority: _priority, // Gunakan nilai prioritas yang diperbarui
                    percentage: _percentage,
                    isCompleted: _isCompleted,
                  );
                  
                  // Kembalikan objek yang diperbarui ke halaman sebelumnya
                  Navigator.pop(context, updatedTask);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('SIMPAN'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method untuk mendapatkan warna prioritas
  Color _getPriorityColor(String priority) {
    switch (priority) {
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

  // Helper method untuk mendapatkan teks prioritas
  String _getPriorityText(String priority) {
    switch (priority) {
      case 'high':
        return 'PRIORITAS TINGGI';
      case 'medium':
        return 'PRIORITAS SEDANG';
      case 'low':
        return 'PRIORITAS RENDAH';
      default:
        return 'NORMAL';
    }
  }

  // Helper method untuk mengecek apakah perlu menampilkan peringatan deadline
  bool _isDeadlineWarning() {
    final now = DateTime.now();
    final difference = _dueDate.difference(now).inDays;
    return (!_isCompleted && difference <= 2) || _dueDate.isBefore(now);
  }

  // Helper method untuk mengecek apakah deadline sudah lewat
  bool _isDeadlineOverdue() {
    final now = DateTime.now();
    return !_isCompleted && _dueDate.isBefore(now);
  }

  // Helper method untuk mendapatkan teks peringatan deadline
  String _getDeadlineWarningText() {
    final now = DateTime.now();
    if (_dueDate.isBefore(now)) {
      return 'Tugas ini sudah melewati deadline!';
    } else {
      final difference = _dueDate.difference(now).inDays;
      if (difference == 0) {
        return 'Deadline tugas ini adalah hari ini!';
      } else {
        return 'Deadline tugas ini dalam $difference hari lagi!';
      }
    }
  }
  
  // Widget untuk memilih prioritas tugas
  Widget _buildPriorityRadio() {
    return Column(
      children: [
        // Prioritas Tinggi
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
          activeColor: Colors.red,
        ),
        
        // Prioritas Sedang
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
          activeColor: Colors.orange,
        ),
        
        // Prioritas Rendah
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
          activeColor: Colors.green,
        ),
      ],
    );
  }
}
