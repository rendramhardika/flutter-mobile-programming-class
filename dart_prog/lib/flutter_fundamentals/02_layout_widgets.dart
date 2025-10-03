import 'package:flutter/material.dart';

// Layout Widgets Flutter
class LayoutWidgetsDemo extends StatelessWidget {
  const LayoutWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout Widgets'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row dan Column
            RowColumnSection(),
            SizedBox(height: 20),
            
            // Stack dan Positioned
            StackSection(),
            SizedBox(height: 20),
            
            // Flex dan Expanded
            FlexSection(),
            SizedBox(height: 20),
            
            // Wrap
            WrapSection(),
            SizedBox(height: 20),
            
            // ListView
            ListViewSection(),
            SizedBox(height: 20),
            
            // GridView
            GridViewSection(),
          ],
        ),
      ),
    );
  }
}

// Section untuk Row dan Column
class RowColumnSection extends StatelessWidget {
  const RowColumnSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. ROW DAN COLUMN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        
        // Row Example
        const Text('Row (horizontal):'),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 50,
                height: 50,
                color: Colors.red,
                child: const Center(child: Text('1')),
              ),
              Container(
                width: 50,
                height: 50,
                color: Colors.green,
                child: const Center(child: Text('2')),
              ),
              Container(
                width: 50,
                height: 50,
                color: Colors.blue,
                child: const Center(child: Text('3')),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 10),
        
        // Column Example
        const Text('Column (vertical):'),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 30,
                color: Colors.orange,
                child: const Center(child: Text('Item 1')),
              ),
              const SizedBox(height: 5),
              Container(
                width: 100,
                height: 30,
                color: Colors.purple,
                child: const Center(child: Text('Item 2')),
              ),
              const SizedBox(height: 5),
              Container(
                width: 100,
                height: 30,
                color: Colors.teal,
                child: const Center(child: Text('Item 3')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Section untuk Stack
class StackSection extends StatelessWidget {
  const StackSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. STACK DAN POSITIONED',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        
        const Text('Stack (overlay widgets):'),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Background
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.blue.withOpacity(0.3),
                child: const Center(
                  child: Text(
                    'Background',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              
              // Positioned widgets
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red,
                  child: const Text(
                    'Top Left',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.green,
                  child: const Text(
                    'Top Right',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange,
                  child: const Text(
                    'Bottom Left',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              
              const Positioned(
                bottom: 10,
                right: 10,
                child: Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Section untuk Flex dan Expanded
class FlexSection extends StatelessWidget {
  const FlexSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. FLEX DAN EXPANDED',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        
        const Text('Expanded dalam Row:'),
        Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                color: Colors.red,
                child: const Center(
                  child: Text(
                    'Fixed\n80px',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.green,
                  child: const Center(
                    child: Text(
                      'Expanded\nflex: 2',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'Expanded\nflex: 1',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 10),
        
        const Text('Flexible vs Expanded:'),
        Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  color: Colors.orange,
                  child: const Center(
                    child: Text(
                      'Flexible',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.purple,
                  child: const Center(
                    child: Text(
                      'Expanded',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Section untuk Wrap
class WrapSection extends StatelessWidget {
  const WrapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4. WRAP',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        
        const Text('Wrap (auto line break):'),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(10, (index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.primaries[index % Colors.primaries.length],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Item ${index + 1}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// Section untuk ListView
class ListViewSection extends StatelessWidget {
  const ListViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5. LISTVIEW',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        
        const Text('ListView (scrollable list):'),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.primaries[index % Colors.primaries.length],
                  child: Text('${index + 1}'),
                ),
                title: Text('Item ${index + 1}'),
                subtitle: Text('Subtitle untuk item ${index + 1}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tapped item ${index + 1}')),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Section untuk GridView
class GridViewSection extends StatelessWidget {
  const GridViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '6. GRIDVIEW',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        
        const Text('GridView (grid layout):'),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            padding: const EdgeInsets.all(8),
            itemCount: 12,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.primaries[index % Colors.primaries.length],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
