import 'package:flutter/material.dart';

class LayoutTransitionGuide extends StatelessWidget {
  const LayoutTransitionGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout Transition Guide'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('When to Transition Between Layouts'),
            const SizedBox(height: 16),
            
            // Linear to Relative/Constraint
            _buildTransitionCard(
              title: 'From Linear to Relative/Constraint Layout',
              reason: 'When you need more control over widget positioning',
              examples: [
                'Overlapping widgets',
                'Precise positioning requirements',
                'Complex UI with multiple layers',
              ],
              benefits: [
                'Better control over z-index and layering',
                'More precise positioning with Positioned widget',
                'Easier to implement complex designs',
              ],
              codeExample: '''// Linear Layout (Limited)
Column(
  children: [
    Container(width: 100, height: 100, color: Colors.red),
    // Can't easily overlap these widgets
    Container(width: 50, height: 50, color: Colors.blue),
  ],
)

// Relative Layout (Better for overlapping)
Stack(
  children: [
    Positioned(
      top: 0,
      left: 0,
      child: Container(width: 100, height: 100, color: Colors.red),
    ),
    Positioned(
      top: 25,
      left: 25,
      child: Container(width: 50, height: 50, color: Colors.blue),
    ),
  ],
)''',
            ),
            
            const SizedBox(height: 24),
            
            // Relative to Constraint
            _buildTransitionCard(
              title: 'From Relative to Constraint Layout',
              reason: 'When you need better performance and responsiveness',
              examples: [
                'Complex UIs with many widgets',
                'Responsive designs',
                'Dynamic content that changes size',
              ],
              benefits: [
                'Better performance with complex layouts',
                'More responsive to different screen sizes',
                'Easier to maintain and modify',
                'Better support for animation',
              ],
              codeExample: '''// Relative Layout (Less Flexible)
Stack(
  children: [
    Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(height: 100, color: Colors.green),
    ),
  ],
)

// Constraint Layout (More Flexible)
LayoutBuilder(
  builder: (context, constraints) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: constraints.maxWidth,
          minHeight: 100,
        ),
        child: Container(color: Colors.green),
      ),
    );
  },
)''',
            ),
            
            const SizedBox(height: 24),
            
            // General Guidelines
            _buildSectionTitle('General Guidelines'),
            const SizedBox(height: 8),
            _buildGuidelineItem(
              '1. Start with Linear Layout',
              'Use Column/Row for simple, linear arrangements of widgets.'
            ),
            _buildGuidelineItem(
              '2. Move to Relative Layout',
              'When you need overlapping widgets or precise positioning.'
            ),
            _buildGuidelineItem(
              '3. Use Constraint Layout',
              'For complex, responsive UIs that need to work across different screen sizes.'
            ),
            _buildGuidelineItem(
              '4. Consider Performance',
              'For deep widget trees, prefer Constraint Layout for better performance.'
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildTransitionCard({
    required String title,
    required String reason,
    required List<String> examples,
    required List<String> benefits,
    required String codeExample,
  }) {
    // Determine which visual example to show based on title
    Widget visualExample = const SizedBox.shrink();
    
    if (title.contains('Linear to Relative')) {
      visualExample = _buildLinearToRelativeExample();
    } else if (title.contains('Relative to Constraint')) {
      visualExample = _buildRelativeToConstraintExample();
    }
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Alasan: $reason',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            
            // Visual Example Section
            const Text(
              'Contoh Visual:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border.all(color: Colors.grey[300]!), 
                borderRadius: BorderRadius.circular(8),
              ),
              child: visualExample,
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Kapan digunakan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...examples.map((e) => Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4),
              child: Text('• $e'),
            )),
            
            const SizedBox(height: 12),
            const Text(
              'Keuntungan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...benefits.map((e) => Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4),
              child: Text('• $e'),
            )),
            
            const SizedBox(height: 16),
            const Text(
              'Contoh Kode:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  codeExample,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGuidelineItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(description),
        ],
      ),
    );
  }
  
  // Visual example for Linear to Relative transition
  Widget _buildLinearToRelativeExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('1. Linear Layout (Column/Row):', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        // Linear Layout Example
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 40,
                color: Colors.red[300],
                alignment: Alignment.center,
                child: const Text('Item 1', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 8),
              Container(
                width: 150,
                height: 40,
                color: Colors.blue[300],
                alignment: Alignment.center,
                child: const Text('Item 2', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('2. Relative Layout (Stack):', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        // Relative Layout Example
        Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 40,
                color: Colors.red[300],
                alignment: Alignment.center,
                child: const Text('Item 1', style: TextStyle(color: Colors.white)),
              ),
              Positioned(
                top: 20,
                left: 50,
                child: Container(
                  width: 150,
                  height: 40,
                  color: Colors.blue[300],
                  alignment: Alignment.center,
                  child: const Text('Item 2 (Overlapping)', 
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text('→ Overlapping dan posisi yang lebih fleksibel', 
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.green[800]),
        ),
      ],
    );
  }
  
  // Visual example for Relative to Constraint transition
  Widget _buildRelativeToConstraintExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('1. Relative Layout (Stack):', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        // Relative Layout Example
        Container(
          height: 120,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  width: 100,
                  height: 40,
                  color: Colors.purple[300],
                  alignment: Alignment.center,
                  child: const Text('Fixed', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
              Positioned(
                top: 30,
                left: 30,
                child: Container(
                  width: 120,
                  height: 50,
                  color: Colors.orange[300],
                  alignment: Alignment.center,
                  child: const Text('Positioned', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        const Text('2. Constraint Layout:', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        // Constraint Layout Example
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.green[300],
                alignment: Alignment.center,
                child: const Text('Responsive Width', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.only(right: 4),
                      color: Colors.blue[300],
                      alignment: Alignment.center,
                      child: const Text('Flex 2', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 40,
                      color: Colors.red[300],
                      alignment: Alignment.center,
                      child: const Text('Flex 3', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text('→ Lebih responsif dan mudah diatur untuk berbagai ukuran layar', 
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.green[800]),
        ),
      ],
    );
  }
}
