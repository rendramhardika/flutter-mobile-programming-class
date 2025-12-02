import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_integration_demo/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('OpenStreetMap Demo'), findsOneWidget);
  });
}
