import 'package:flutter/material.dart';
import '../models/data_item.dart';
import 'edit_task_page.dart';
import 'add_data_page.dart';
import '../widgets/sweet_alert_dialog.dart';
import '../widgets/sweet_toast.dart';

class DataListPage extends StatefulWidget {
  final String nama;
  final String nim;

  const DataListPage({
    super.key,
    required this.nama,
    required this.nim,
  });

  @override
  State<DataListPage> createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
  // Dummy data
  List<DataItem> dataItems = [
    DataItem(
      id: 1,
      title: 'Tugas Mobile Programming',
      description: 'Membuat aplikasi Flutter dengan form',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      priority: 'high',
      percentage: 30, // 30% complete
      isCompleted: false,
    ),
    DataItem(
      id: 2,
      title: 'Tugas Web Programming',
      description: 'Membuat website dengan React',
      dueDate: DateTime.now().add(const Duration(days: 14)),
      priority: 'medium',
      percentage: 100, // 100% complete
      isCompleted: true,
    ),
    DataItem(
      id: 3,
      title: 'Tugas Basis Data',
      description: 'Membuat ERD dan implementasi database',
      dueDate: DateTime.now().add(const Duration(days: 2)), // Mendekati deadline (H-2)
      priority: 'high',
      percentage: 65, // 65% complete
      isCompleted: false,
    ),
    DataItem(
      id: 4,
      title: 'Tugas Algoritma',
      description: 'Implementasi algoritma sorting dan searching',
      dueDate: DateTime.now().subtract(const Duration(days: 1)), // Sudah lewat deadline
      priority: 'medium',
      percentage: 80, // 80% complete
      isCompleted: false,
    ),
    DataItem(
      id: 5,
      title: 'Tugas UI/UX',
      description: 'Membuat wireframe dan prototype aplikasi',
      dueDate: DateTime.now().add(const Duration(days: 1)), // Deadline besok
      priority: 'high',
      percentage: 40, // 40% complete
      isCompleted: false,
    ),
  ];

  // Helper method to get priority color
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

  // Helper method to get priority text
  String _getPriorityText(String priority) {
    switch (priority) {
      case 'high':
        return 'TINGGI';
      case 'medium':
        return 'SEDANG';
      case 'low':
        return 'RENDAH';
      default:
        return 'NORMAL';
    }
  }
  
  // Helper method untuk mendapatkan warna deadline berdasarkan status
  Color _getDeadlineColor(DataItem item) {
    if (item.isOverdue) {
      return Colors.red; // Melewati deadline
    } else if (item.isNearDeadline) {
      return Colors.orange; // Mendekati deadline (H-2)
    } else {
      return Colors.grey.shade700; // Normal
    }
  }
  
  // Helper method untuk membuat teks deadline dengan peringatan jika perlu
  String _buildDeadlineText(DataItem item) {
    final now = DateTime.now();
    // Gunakan DateTime yang hanya menyimpan tanggal (tanpa waktu) untuk perbandingan yang lebih akurat
    final todayDate = DateTime(now.year, now.month, now.day);
    final dueDateOnly = DateTime(item.dueDate.year, item.dueDate.month, item.dueDate.day);
    
    // Hitung selisih dalam hari
    final difference = dueDateOnly.difference(todayDate).inDays;
    
    if (item.isOverdue) {
      return 'TERLAMBAT! Deadline: ${item.formattedDueDate}';
    } else if (item.isNearDeadline) {
      if (difference == 0) {
        return 'DEADLINE HARI INI! ${item.formattedDueDate}';
      } else {
        return 'SEGERA! Deadline dalam $difference hari: ${item.formattedDueDate}';
      }
    } else {
      return 'Deadline: ${item.formattedDueDate}';
    }
  }
  
  // Helper method untuk mendapatkan teks peringatan deadline untuk banner
  String _getDeadlineWarningText(DataItem item) {
    final now = DateTime.now();
    // Gunakan DateTime yang hanya menyimpan tanggal (tanpa waktu) untuk perbandingan yang lebih akurat
    final todayDate = DateTime(now.year, now.month, now.day);
    final dueDateOnly = DateTime(item.dueDate.year, item.dueDate.month, item.dueDate.day);
    
    // Hitung selisih dalam hari
    final difference = dueDateOnly.difference(todayDate).inDays;
    
    if (difference == 0) {
      return 'Deadline hari ini!';
    } else {
      return 'Deadline dalam $difference hari lagi!';
    }
  }
  
  // Helper method untuk membuat ikon leading berdasarkan status tugas
  Widget _buildLeadingIcon(DataItem item) {
    if (item.isCompleted) {
      // Tugas sudah selesai
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 28,
      );
    } else if (item.isOverdue) {
      // Tugas sudah melewati deadline
      return Stack(
        children: [
          const Icon(
            Icons.pending_actions,
            color: Colors.red,
            size: 28,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 16,
              ),
            ),
          ),
        ],
      );
    } else if (item.isNearDeadline) {
      // Tugas mendekati deadline
      return Stack(
        children: [
          const Icon(
            Icons.pending_actions,
            color: Colors.orange,
            size: 28,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.access_time,
                color: Colors.orange,
                size: 16,
              ),
            ),
          ),
        ],
      );
    } else {
      // Tugas normal
      return const Icon(
        Icons.pending_actions,
        color: Colors.blue,
        size: 28,
      );
    }
  }
  
  // Navigasi ke halaman edit tugas
  Future<void> _navigateToEditTask(DataItem item, int index) async {
    // Navigasi ke halaman edit tugas
    final result = await Navigator.push<DataItem>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskPage(task: item),
      ),
    );
    
    // Update item jika hasil tidak null (pengguna menekan tombol Simpan)
    if (result != null) {
      setState(() {
        dataItems[index] = result;
      });
    }
  }

  // Metode untuk menghapus tugas dengan konfirmasi dan notifikasi yang menarik
  void _deleteTask(DataItem item, int index) {
    // Tampilkan dialog konfirmasi dengan SweetAlertDialog
    SweetAlertDialog.show(
      context: context,
      title: 'Hapus Tugas',
      content: 'Apakah Anda yakin ingin menghapus tugas "${item.title}"?',
      alertType: AlertType.warning,
      confirmText: 'HAPUS',
      cancelText: 'BATAL',
      onConfirm: () {
        // Simpan referensi ke item yang akan dihapus
        final deletedItem = item;
        final deletedIndex = index;
        
        // Hapus item dari daftar
        setState(() {
          dataItems.removeAt(index);
        });
        
        // Tampilkan notifikasi sukses dengan opsi undo
        SweetToast.showSuccess(
          context: context,
          message: 'Tugas "${item.title}" berhasil dihapus',
          duration: const Duration(seconds: 5),
          actionLabel: 'BATALKAN',
          onAction: () {
            // Kembalikan item yang dihapus
            setState(() {
              if (deletedIndex <= dataItems.length) {
                dataItems.insert(deletedIndex, deletedItem);
              } else {
                dataItems.add(deletedItem);
              }
            });
            
            // Tampilkan notifikasi item dikembalikan
            SweetToast.showInfo(
              context: context,
              message: 'Tugas "${deletedItem.title}" telah dikembalikan',
              duration: const Duration(seconds: 2),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // User info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama: ${widget.nama}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'NIM: ${widget.nim}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          
          // List title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.list_alt),
                SizedBox(width: 8),
                Text(
                  'Daftar Tugas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          // Data list
          Expanded(
            child: ListView.builder(
              itemCount: dataItems.length,
              itemBuilder: (context, index) {
                final item = dataItems[index];
                // Gunakan AnimatedContainer untuk animasi saat item dihapus
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    // Tambahkan warna card khusus untuk tugas yang mendekati deadline atau sudah melewati deadline
                    color: item.isOverdue
                        ? Colors.red.shade50 // Warna merah muda untuk tugas yang melewati deadline
                        : item.isNearDeadline
                            ? Colors.orange.shade50 // Warna oranye muda untuk tugas yang mendekati deadline
                            : null, // Warna default untuk tugas normal
                    // Tambahkan border khusus untuk tugas yang mendekati deadline atau sudah melewati deadline
                    shape: item.isOverdue || item.isNearDeadline
                        ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: item.isOverdue ? Colors.red : Colors.orange,
                              width: 1.5,
                            ),
                          )
                        : null,
                    child: ListTile(
                      leading: _buildLeadingIcon(item),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner peringatan untuk tugas yang mendekati deadline atau sudah melewati deadline
                          if (item.isOverdue || item.isNearDeadline)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: item.isOverdue ? Colors.red.withOpacity(0.8) : Colors.orange.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item.isOverdue ? Icons.warning_amber_rounded : Icons.access_time,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      item.isOverdue
                                          ? 'Tugas ini sudah melewati deadline!'
                                          : _getDeadlineWarningText(item),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Text(item.description),
                          const SizedBox(height: 4),
                          // Progress bar
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Progress: ${item.percentage}%',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            _navigateToEditTask(item, index);
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            size: 16,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: item.percentage / 100,
                                        backgroundColor: Colors.grey[300],
                                        color: item.percentage == 100 ? Colors.green : Colors.blue,
                                        minHeight: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              // Priority indicator
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(item.priority),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _getPriorityText(item.priority),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Due date
                              Expanded(
                                child: Text(
                                  _buildDeadlineText(item),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: _getDeadlineColor(item),
                                    fontWeight: item.isOverdue || item.isNearDeadline ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tombol untuk menandai tugas sebagai selesai/belum selesai
                          IconButton(
                            icon: Icon(
                              item.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                              color: item.isCompleted ? Colors.green : Colors.grey,
                            ),
                            tooltip: item.isCompleted ? 'Tandai belum selesai' : 'Tandai selesai',
                            onPressed: () {
                              setState(() {
                                item.isCompleted = !item.isCompleted;
                                if (item.isCompleted) {
                                  item.percentage = 100;
                                } else if (item.percentage == 100) {
                                  item.percentage = 90;
                                }
                              });
                              
                              // Tampilkan notifikasi dengan SweetToast
                              if (item.isCompleted) {
                                SweetToast.showSuccess(
                                  context: context,
                                  message: 'Tugas "${item.title}" ditandai sebagai selesai',
                                  duration: const Duration(seconds: 2),
                                );
                              } else {
                                SweetToast.showInfo(
                                  context: context,
                                  message: 'Tugas "${item.title}" ditandai sebagai belum selesai',
                                  duration: const Duration(seconds: 2),
                                );
                              }
                            },
                          ),
                          // Tombol untuk menghapus tugas
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'Hapus tugas',
                            onPressed: () => _deleteTask(item, index),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigasi ke halaman edit tugas saat item diklik
                        _navigateToEditTask(item, index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add data page
          final result = await Navigator.push<DataItem>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDataPage(),
            ),
          );
          
          // Add new data if result is not null
          if (result != null) {
            setState(() {
              dataItems.add(result);
            });
            
            // Tampilkan notifikasi dengan SweetToast
            SweetToast.showSuccess(
              context: context,
              message: 'Tugas "${result.title}" berhasil ditambahkan',
              duration: const Duration(seconds: 2),
            );
          }
        },
        tooltip: 'Tambah Tugas',
        child: const Icon(Icons.add),
      ),
    );
  }
}
