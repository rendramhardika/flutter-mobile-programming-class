import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Helper method to show accessibility dialog
    void showAccessibilityDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Aksesibilitas Aktif'),
          content: const Text(
            'Fitur aksesibilitas telah diaktifkan. Aplikasi ini mendukung screen reader, navigasi keyboard, dan ukuran teks yang dapat disesuaikan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Mengerti'),
            ),
          ],
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility & Inclusive Design'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Accessibility Overview
            _buildSectionTitle('1. Aksesibilitas untuk Semua Pengguna'),
            const SizedBox(height: 16),
            _buildAccessibilityCard(
              icon: Icons.visibility_off,
              title: 'Dukungan untuk Penglihatan Terbatas',
              content: 'Ukuran teks yang dapat disesuaikan dan rasio kontras yang memadai.',
              color: Colors.blue[100]!,
            ),
            const SizedBox(height: 12),
            _buildAccessibilityCard(
              icon: Icons.hearing_disabled,
              title: 'Dukungan untuk Pendengaran Terbatas',
              content: 'Alternatif teks untuk konten audio dan notifikasi visual.',
              color: Colors.green[100]!,
            ),
            const SizedBox(height: 32),

            // Section 2: Contrast Ratio Examples
            _buildSectionTitle('2. Contoh Rasio Kontras (WCAG)'),
            const SizedBox(height: 16),
            _buildContrastExample(
              'Kontras Tinggi (AAA)', 
              Colors.black, 
              Colors.white,
              '21:1',
            ),
            const SizedBox(height: 12),
            _buildContrastExample(
              'Kontras Baik (AA)', 
              const Color(0xFF0056B3), 
              Colors.white,
              '4.5:1',
            ),
            const SizedBox(height: 12),
            _buildContrastExample(
              'Kontras Buruk', 
              Colors.grey, 
              Colors.white,
              '2.3:1',
              isPoorContrast: true,
            ),
            const SizedBox(height: 32),

            // Section 3: Screen Reader Demo
            _buildSectionTitle('3. Demo Screen Reader'),
            const SizedBox(height: 16),
            Semantics(
              label: 'Tombol dengan deskripsi untuk screen reader',
              button: true,
              child: ElevatedButton(
                onPressed: () {
                  // Provide haptic feedback
                  HapticFeedback.lightImpact();
                  // Show dialog
                  showAccessibilityDialog();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.accessible_forward),
                    SizedBox(width: 8),
                    Text('Coba Screen Reader'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aktifkan screen reader (TalkBack/VoiceOver) dan sentuh tombol di atas untuk mendengar deskripsinya.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Section 4: Alternative Navigation
            _buildSectionTitle('4. Navigasi Alternatif'),
            const SizedBox(height: 16),
            _buildNavigationOption(
              'Navigasi Gestur',
              'Navigasi menggunakan gerakan khusus',
              Icons.touch_app,
              context,
            ),
            const SizedBox(height: 12),
            _buildNavigationOption(
              'Navigasi Keyboard',
              'Dukungan navigasi menggunakan tombol tab dan panah',
              Icons.keyboard,
              context,
            ),
            const SizedBox(height: 12),
            _buildNavigationOption(
              'Navigasi Suara',
              'Kontrol aplikasi menggunakan perintah suara',
              Icons.mic,
              context,
            ),
            const SizedBox(height: 32),

            // Section 5: WCAG Guidelines
            _buildSectionTitle('5. Panduan WCAG'),
            const SizedBox(height: 16),
            _buildWcagPrinciple(
              'Perceivable',
              'Dapat Dilihat',
              'Sediakan alternatif teks untuk konten non-teks',
              Icons.visibility,
            ),
            const SizedBox(height: 12),
            _buildWcagPrinciple(
              'Operable',
              'Dapat Dioperasikan',
              'Semua fungsi dapat diakses melalui keyboard',
              Icons.touch_app,
            ),
            const SizedBox(height: 12),
            _buildWcagPrinciple(
              'Understandable',
              'Dapat Dipahami',
              'Buat teks mudah dibaca dan dipahami',
              Icons.lightbulb_outline,
            ),
            const SizedBox(height: 12),
            _buildWcagPrinciple(
              'Robust',
              'Kompitibel',
              'Kompatibel dengan berbagai perangkat dan asisten',
              Icons.devices,
            ),
            const SizedBox(height: 40), // Extra space at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildAccessibilityCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue[800]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContrastExample(
    String label,
    Color textColor,
    Color backgroundColor, 
    String ratio, {
    bool isPoorContrast = false,
  }) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Contoh Teks - $label',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                ratio,
                style: TextStyle(
                  color: isPoorContrast ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationOption(String title, String description, IconData icon, BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Provide haptic feedback
          HapticFeedback.lightImpact();
          // Show dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Tips $title'),
              content: Text(
                'Untuk $title yang lebih baik, pastikan untuk:\n\n'
                '1. Gunakan ukuran teks yang cukup besar\n'
                '2. Sediakan label yang deskriptif\n'
                '3. Uji dengan perangkat asisten yang sesuai',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Mengerti'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWcagPrinciple(
    String enName,
    String idName,
    String description,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue[700]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$enName ($idName)',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
