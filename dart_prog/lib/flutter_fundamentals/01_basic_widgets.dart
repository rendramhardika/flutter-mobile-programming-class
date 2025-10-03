import 'package:flutter/material.dart';

// Widget Dasar Flutter
class BasicWidgetsDemo extends StatelessWidget {
  const BasicWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Dasar Flutter'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text Widgets
            TextWidgetsSection(),
            SizedBox(height: 20),
            
            // Button Widgets
            ButtonWidgetsSection(),
            SizedBox(height: 20),
            
            // Image Widgets
            ImageWidgetsSection(),
            SizedBox(height: 20),
            
            // Input Widgets
            InputWidgetsSection(),
            SizedBox(height: 20),
            
            // Container dan Decoration
            ContainerSection(),
          ],
        ),
      ),
    );
  }
}

// Section untuk Text Widgets
class TextWidgetsSection extends StatelessWidget {
  const TextWidgetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. TEXT WIDGETS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        
        // Basic Text
        const Text('Ini adalah text biasa'),
        
        // Styled Text
        const Text(
          'Text dengan style',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontStyle: FontStyle.italic,
          ),
        ),
        
        // Rich Text
        RichText(
          text: const TextSpan(
            text: 'Text dengan ',
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'berbagai ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              TextSpan(
                text: 'style',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        
        // Selectable Text
        const SelectableText('Text yang bisa diseleksi dan dicopy'),
      ],
    );
  }
}

// Section untuk Button Widgets
class ButtonWidgetsSection extends StatelessWidget {
  const ButtonWidgetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. BUTTON WIDGETS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        
        // ElevatedButton
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ElevatedButton ditekan!')),
            );
          },
          child: const Text('ElevatedButton'),
        ),
        
        // TextButton
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('TextButton ditekan!')),
            );
          },
          child: const Text('TextButton'),
        ),
        
        // OutlinedButton
        OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OutlinedButton ditekan!')),
            );
          },
          child: const Text('OutlinedButton'),
        ),
        
        // IconButton
        Row(
          children: [
            const Text('IconButton: '),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('IconButton ditekan!')),
                );
              },
              icon: const Icon(Icons.favorite),
              color: Colors.red,
            ),
          ],
        ),
        
        // FloatingActionButton
        const Text('FloatingActionButton ada di pojok kanan bawah'),
      ],
    );
  }
}

// Section untuk Image Widgets
class ImageWidgetsSection extends StatelessWidget {
  const ImageWidgetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. IMAGE WIDGETS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        
        // Icon
        const Row(
          children: [
            Text('Icons: '),
            Icon(Icons.star, color: Colors.yellow),
            Icon(Icons.favorite, color: Colors.red),
            Icon(Icons.thumb_up, color: Colors.blue),
          ],
        ),
        
        // Network Image (placeholder)
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'Network\nImage\nPlaceholder',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

// Section untuk Input Widgets
class InputWidgetsSection extends StatefulWidget {
  const InputWidgetsSection({super.key});

  @override
  State<InputWidgetsSection> createState() => _InputWidgetsSectionState();
}

class _InputWidgetsSectionState extends State<InputWidgetsSection> {
  bool _switchValue = false;
  bool _checkboxValue = false;
  double _sliderValue = 50.0;
  String _radioValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4. INPUT WIDGETS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        
        // TextField
        const TextField(
          decoration: InputDecoration(
            labelText: 'Masukkan nama',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 10),
        
        // Switch
        Row(
          children: [
            const Text('Switch: '),
            Switch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
            Text(_switchValue ? 'ON' : 'OFF'),
          ],
        ),
        
        // Checkbox
        Row(
          children: [
            Checkbox(
              value: _checkboxValue,
              onChanged: (value) {
                setState(() {
                  _checkboxValue = value ?? false;
                });
              },
            ),
            const Text('Checkbox'),
          ],
        ),
        
        // Slider
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Slider: ${_sliderValue.round()}'),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
          ],
        ),
        
        // Radio Buttons
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Radio Buttons:'),
            RadioListTile<String>(
              title: const Text('Option 1'),
              value: 'Option 1',
              groupValue: _radioValue,
              onChanged: (value) {
                setState(() {
                  _radioValue = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Option 2'),
              value: 'Option 2',
              groupValue: _radioValue,
              onChanged: (value) {
                setState(() {
                  _radioValue = value!;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Section untuk Container dan Decoration
class ContainerSection extends StatelessWidget {
  const ContainerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5. CONTAINER DAN DECORATION',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        
        // Basic Container
        Container(
          width: 100,
          height: 100,
          color: Colors.blue,
          child: const Center(
            child: Text(
              'Container',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
        
        // Decorated Container
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.blue],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Decorated\nContainer',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 10),
        
        // Card
        Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Card Widget',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Card adalah container dengan elevation dan rounded corners.'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Action'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
