import 'package:flutter/material.dart';

class LayoutExamplesScreen extends StatelessWidget {
  const LayoutExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Layout Examples'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Linear'),
              Tab(text: 'Relative'),
              Tab(text: 'Constraint'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LinearLayoutExample(),
            RelativeLayoutExample(),
            ConstraintLayoutExample(),
          ],
        ),
      ),
    );
  }
}

class LinearLayoutExample extends StatelessWidget {
  const LinearLayoutExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Linear Layout (Column/Row)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Vertical Layout (Column):',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.grey[200],
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Item 1'),
              Divider(),
              Text('Item 2'),
              Divider(),
              Text('Item 3'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Horizontal Layout (Row):',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.grey[200],
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star_border),
              Icon(Icons.star_border),
            ],
          ),
        ),
      ],
    );
  }
}

class RelativeLayoutExample extends StatelessWidget {
  const RelativeLayoutExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Relative Layout (Stack)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Stack allows widgets to be positioned relative to the edges of the Stack:',
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          color: Colors.grey[200],
          child: Stack(
            children: [
              // Background
              Container(
                color: Colors.blue[50],
              ),
              // Top left
              const Positioned(
                top: 16,
                left: 16,
                child: Icon(Icons.star, color: Colors.amber, size: 40),
              ),
              // Top right
              const Positioned(
                top: 16,
                right: 16,
                child: Icon(Icons.favorite, color: Colors.red, size: 40),
              ),
              // Center
              const Center(
                child: Text(
                  'Center',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Bottom center
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.black54,
                  child: const Text(
                    'Bottom Bar',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Text(
          'This demonstrates how to position widgets relative to each other using Stack and Positioned widgets.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

class ConstraintLayoutExample extends StatelessWidget {
  const ConstraintLayoutExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Constraint Layout',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'In Flutter, we use LayoutBuilder, Expanded, Flexible, and ConstrainedBox to create responsive layouts that adapt to different screen sizes.',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.grey[200],
          child: Column(
            children: [
              // Responsive row with flexible widgets
              const Text('Responsive Row:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 60,
                      color: Colors.blue,
                      alignment: Alignment.center,
                      child: const Text('Flex 2', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 60,
                      color: Colors.green,
                      alignment: Alignment.center,
                      child: const Text('Flex 3', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Aspect ratio example
              const Text('Aspect Ratio:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.orange,
                  alignment: Alignment.center,
                  child: const Text('16:9 Aspect Ratio', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              
              // Constrained box example
              const Text('Constrained Box:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: double.infinity,
                  minHeight: 50,
                  maxHeight: 100,
                ),
                child: Container(
                  color: Colors.purple,
                  alignment: Alignment.center,
                  child: const Text('Min Height: 50, Max Height: 100', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
