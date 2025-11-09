import 'package:flutter/material.dart';

class DesignPrinciplesScreen extends StatelessWidget {
  const DesignPrinciplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendefinisikan skema warna kustom
    final ColorScheme colorScheme = ColorScheme(
      primary: const Color(0xFF6200EE), // Warna primer ungu
      primaryContainer: const Color(0xFF3700B3), // Varian warna primer yang lebih gelap
      secondary: const Color(0xFF03DAC6), // Warna sekunder teal
      secondaryContainer: const Color(0xFF018786), // Varian warna sekunder yang lebih gelap
      surface: Colors.white, // Warna permukaan
      background: Colors.grey[100]!, // Warna latar belakang
      error: const Color(0xFFB00020), // Warna error
      onPrimary: Colors.white, // Warna teks di atas warna primer
      onSecondary: Colors.black, // Warna teks di atas warna sekunder
      onSurface: Colors.black87, // Warna teks di atas permukaan
      onBackground: Colors.black87, // Warna teks di atas latar belakang
      onError: Colors.white, // Warna teks di atas warna error
      brightness: Brightness.light, // Tema terang
      surfaceVariant: Colors.grey[200]!, // Variasi warna permukaan
      onSurfaceVariant: Colors.grey[800]!, // Warna teks di atas variasi permukaan
    );

    // Mendefinisikan teks tema
    final TextTheme textTheme = Theme.of(context).textTheme.copyWith(
          headlineLarge: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
          headlineMedium: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[800],
            height: 1.5,
          ),
          labelLarge: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        );

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: colorScheme,
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          clipBehavior: Clip.antiAlias,
          surfaceTintColor: Colors.white,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prinsip Desain Visual'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Warna
              _buildSection(
                context,
                title: 'Palet Warna',
                icon: Icons.palette,
                child: Column(
                  children: [
                    _buildColorCard(context, 'Primary', colorScheme.primary),
                    _buildColorCard(context, 'Primary Container', colorScheme.primaryContainer),
                    _buildColorCard(context, 'Secondary', colorScheme.secondary),
                    _buildColorCard(context, 'Secondary Container', colorScheme.secondaryContainer),
                  ],
                ),
              ),
              
              const SizedBox(height: 24.0),
              
              // Bagian Tipografi
              _buildSection(
                context,
                title: 'Tipografi',
                icon: Icons.text_fields,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Judul Besar', style: textTheme.headlineLarge),
                    const SizedBox(height: 8.0),
                    Text('Judul Sedang', style: textTheme.headlineMedium),
                    const SizedBox(height: 8.0),
                    Text(
                      'Ini adalah contoh teks paragraf yang menunjukkan gaya tipografi untuk konten utama. Tipografi yang baik meningkatkan keterbacaan dan pengalaman pengguna secara keseluruhan.',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Tombol Aksi'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24.0),
              
              // Bagian Ikonografi
              _buildSection(
                context,
                title: 'Ikonografi',
                icon: Icons.emoji_objects,
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: const [
                    Icon(Icons.home, size: 32.0),
                    Icon(Icons.search, size: 32.0),
                    Icon(Icons.favorite, size: 32.0, color: Colors.red),
                    Icon(Icons.settings, size: 32.0),
                    Icon(Icons.person, size: 32.0),
                    Icon(Icons.notifications, size: 32.0),
                    Icon(Icons.email, size: 32.0),
                    Icon(Icons.share, size: 32.0),
                    Icon(Icons.download, size: 32.0),
                    Icon(Icons.help, size: 32.0),
                  ],
                ),
              ),
              
              const SizedBox(height: 24.0),
              
              // Contoh Penggunaan Komponen
              _buildSection(
                context,
                title: 'Contoh Kartu',
                icon: Icons.card_giftcard,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber),
                            SizedBox(width: 8.0),
                            Text('Fitur Unggulan', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          'Ini adalah contoh kartu yang menunjukkan bagaimana warna, tipografi, dan ikonografi dapat digabungkan untuk menciptakan antarmuka yang konsisten dan menarik secara visual.',
                          style: textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Pelajari Lebih Lanjut'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required IconData icon, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8.0),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        child,
      ],
    );
  }

  Widget _buildColorCard(BuildContext context, String label, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: Colors.grey[300]!),
          ),
        ),
        title: Text(label),
        subtitle: Text(
          '#${color.value.toRadixString(16).substring(2).toUpperCase()}\n'
          'R: ${color.red} G: ${color.green} B: ${color.blue}',
        ),
      ),
    );
  }
}
