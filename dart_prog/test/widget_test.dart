// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dart_prog/main.dart';

void main() {
  testWidgets('Dart Flutter Learning App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DartFlutterLearningApp());

    // Verify that the app title is displayed.
    expect(find.text('Dart & Flutter Learning'), findsOneWidget);
    
    // Verify that the welcome message is displayed.
    expect(find.text('Selamat Datang di Pembelajaran Dart & Flutter'), findsOneWidget);
    
    // Verify that the main sections are displayed.
    expect(find.text('DASAR-DASAR DART'), findsOneWidget);
    expect(find.text('DASAR-DASAR FLUTTER'), findsOneWidget);
    expect(find.text('CONTOH APLIKASI PRAKTIS'), findsOneWidget);
  });
}
