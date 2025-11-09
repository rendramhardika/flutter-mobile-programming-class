import 'package:flutter/material.dart';
import '../models/data_item.dart';

class DismissibleAssignmentItem extends StatelessWidget {
  final DataItem item;
  final int index;
  final Function(DataItem, int) onEdit;
  final Function(int) onDelete;
  final Function(DataItem, int) onToggleComplete;

  const DismissibleAssignmentItem({
    super.key,
    required this.item,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('assignment-${item.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        // Tampilkan dialog konfirmasi
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Konfirmasi Hapus'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Apakah Anda yakin ingin menghapus tugas ini?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text('Judul: ${item.title}'),
                  const SizedBox(height: 4),
                  if (item.isCompleted)
                    const Text(
                      'Status: Selesai',
                      style: TextStyle(color: Colors.green),
                    )
                  else
                    Text(
                      'Progress: ${item.percentage}%',
                      style: TextStyle(
                        color: item.percentage > 50 ? Colors.blue : Colors.orange,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text('Deadline: ${item.formattedDueDate}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('BATAL'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('HAPUS'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        // Panggil callback onDelete
        onDelete(index);
        
        // Tampilkan snackbar dengan opsi undo
        final deletedItem = item;
        final deletedIndex = index;
        
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tugas "${item.title}" telah dihapus'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'BATALKAN',
              onPressed: () {
                // Kembalikan item yang dihapus melalui callback
                if (context.mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  // Implementasi undo di parent widget
                }
              },
            ),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(height: 4),
            Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
          // Implementasi ListTile sesuai dengan desain yang ada
          // ...
          onTap: () => onEdit(item, index),
        ),
      ),
    );
  }
}
