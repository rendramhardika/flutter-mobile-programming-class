import 'package:flutter/material.dart';

class MaterialGuidelinesScreen extends StatefulWidget {
  const MaterialGuidelinesScreen({super.key});

  @override
  State<MaterialGuidelinesScreen> createState() => _MaterialGuidelinesScreenState();
}

class _MaterialGuidelinesScreenState extends State<MaterialGuidelinesScreen> {
  bool _switchValue = false;
  bool _checkboxValue = false;
  double _sliderValue = 0.5;
  final TextEditingController _textController = TextEditingController();
  final List<String> _items = List.generate(5, (index) => 'Item ${index + 1}');

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Design Guidelines'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSwitch(),
            _buildCheckbox(),
            _buildSlider(),
            _buildTextField(),
            _buildList(),
            const SizedBox(height: 24),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch() {
    return SwitchListTile(
      title: const Text('Switch'),
      value: _switchValue,
      onChanged: (value) => setState(() => _switchValue = value),
      secondary: const Icon(Icons.toggle_on),
    );
  }

  Widget _buildCheckbox() {
    return CheckboxListTile(
      title: const Text('Checkbox'),
      value: _checkboxValue,
      onChanged: (value) => setState(() => _checkboxValue = value ?? false),
      secondary: const Icon(Icons.check_box),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildSlider() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Slider', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Slider(
            value: _sliderValue,
            onChanged: (value) => setState(() => _sliderValue = value),
            label: '${(_sliderValue * 100).toInt()}%',
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          labelText: 'Text Field',
          hintText: 'Type something...',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.text_fields),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => _textController.clear(),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('List Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(_items[index]),
              subtitle: Text('Description for ${_items[index]}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            );
          },
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('Elevated Button'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Outlined Button'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: const Text('Text Button'),
          ),
        ],
      ),
    );
  }
}
