// Dasar-dasar Variabel dan Tipe Data di Dart

void main() {
  print('=== VARIABEL DAN TIPE DATA DART ===\n');
  
  // 1. Deklarasi Variabel
  demonstrateVariableDeclaration();
  
  // 2. Tipe Data Primitif
  demonstratePrimitiveTypes();
  
  // 3. Collections
  demonstrateCollections();
  
  // 4. Null Safety
  demonstrateNullSafety();
}

void demonstrateVariableDeclaration() {
  print('1. DEKLARASI VARIABEL:');
  
  // var - tipe otomatis
  var name = 'Flutter Developer';
  var age = 25;
  
  // Tipe eksplisit
  String language = 'Dart';
  int version = 3;
  double rating = 4.8;
  bool isAwesome = true;
  
  // final - nilai tidak bisa diubah setelah inisialisasi
  final String framework = 'Flutter';
  
  // const - konstanta compile-time
  const double pi = 3.14159;
  
  print('Nama: $name');
  print('Umur: $age');
  print('Bahasa: $language v$version');
  print('Rating: $rating');
  print('Awesome? $isAwesome');
  print('Framework: $framework');
  print('Pi: $pi\n');
}

void demonstratePrimitiveTypes() {
  print('2. TIPE DATA PRIMITIF:');
  
  // Numbers
  int integer = 42;
  double decimal = 3.14;
  num number = 100; // bisa int atau double
  
  // Strings
  String singleQuote = 'Hello';
  String doubleQuote = "World";
  String multiline = '''
  Ini adalah string
  multi-baris
  ''';
  
  // String interpolation
  String greeting = '$singleQuote $doubleQuote!';
  String calculation = '2 + 2 = ${2 + 2}';
  
  // Booleans
  bool isTrue = true;
  bool isFalse = false;
  
  print('Integer: $integer');
  print('Decimal: $decimal');
  print('Number: $number');
  print('Greeting: $greeting');
  print('Calculation: $calculation');
  print('Boolean: $isTrue, $isFalse\n');
}

void demonstrateCollections() {
  print('3. COLLECTIONS:');
  
  // List (Array)
  List<String> fruits = ['apel', 'jeruk', 'pisang'];
  List<int> numbers = [1, 2, 3, 4, 5];
  
  // Set (unique values)
  Set<String> uniqueColors = {'merah', 'hijau', 'biru', 'merah'}; // duplikat dihapus
  
  // Map (key-value pairs)
  Map<String, int> scores = {
    'Alice': 95,
    'Bob': 87,
    'Charlie': 92,
  };
  
  // Operasi List
  fruits.add('mangga');
  fruits.removeAt(0);
  
  print('Fruits: $fruits');
  print('Numbers: $numbers');
  print('Unique Colors: $uniqueColors');
  print('Scores: $scores');
  print('First fruit: ${fruits.first}');
  print('Last number: ${numbers.last}');
  print('Alice score: ${scores['Alice']}\n');
}

void demonstrateNullSafety() {
  print('4. NULL SAFETY:');
  
  // Non-nullable
  String name = 'Dart';
  // name = null; // Error! Tidak bisa null
  
  // Nullable
  String? nullableName;
  nullableName = 'Flutter';
  nullableName = null; // OK
  
  // Null-aware operators
  String? maybeNull;
  String result1 = maybeNull ?? 'Default Value'; // null coalescing
  int? length = maybeNull?.length; // null-aware access
  
  // Late variables
  late String lateVariable;
  lateVariable = 'Initialized later';
  
  print('Name: $name');
  print('Nullable name: $nullableName');
  print('Result with ??: $result1');
  print('Length: $length');
  print('Late variable: $lateVariable\n');
}
