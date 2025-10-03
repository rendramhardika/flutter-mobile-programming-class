// Fungsi dan Kontrol Alur di Dart

void main() {
  print('=== FUNGSI DAN KONTROL ALUR DART ===\n');
  
  // 1. Fungsi Dasar
  demonstrateFunctions();
  
  // 2. Kontrol Alur
  demonstrateControlFlow();
  
  // 3. Loops
  demonstrateLoops();
  
  // 4. Exception Handling
  demonstrateExceptionHandling();
}

void demonstrateFunctions() {
  print('1. FUNGSI:');
  
  // Fungsi sederhana
  String greet(String name) {
    return 'Halo, $name!';
  }
  
  // Fungsi dengan parameter opsional
  String introduce(String name, [int? age]) {
    if (age != null) {
      return 'Saya $name, umur $age tahun';
    }
    return 'Saya $name';
  }
  
  // Fungsi dengan named parameters
  String createProfile({required String name, int age = 0, String? city}) {
    String profile = 'Nama: $name, Umur: $age';
    if (city != null) {
      profile += ', Kota: $city';
    }
    return profile;
  }
  
  // Arrow function
  int square(int x) => x * x;
  
  // Higher-order function
  int calculate(int a, int b, int Function(int, int) operation) {
    return operation(a, b);
  }
  
  print(greet('Developer'));
  print(introduce('Alice'));
  print(introduce('Bob', 25));
  print(createProfile(name: 'Charlie', age: 30, city: 'Jakarta'));
  print('Square of 5: ${square(5)}');
  print('Addition: ${calculate(10, 5, (a, b) => a + b)}');
  print('Multiplication: ${calculate(10, 5, (a, b) => a * b)}\n');
}

void demonstrateControlFlow() {
  print('2. KONTROL ALUR:');
  
  // If-else
  int score = 85;
  String grade;
  
  if (score >= 90) {
    grade = 'A';
  } else if (score >= 80) {
    grade = 'B';
  } else if (score >= 70) {
    grade = 'C';
  } else {
    grade = 'D';
  }
  
  print('Score $score = Grade $grade');
  
  // Ternary operator
  String status = score >= 75 ? 'Lulus' : 'Tidak Lulus';
  print('Status: $status');
  
  // Switch statement
  String day = 'Monday';
  String dayType = switch (day) {
    'Monday' || 'Tuesday' || 'Wednesday' || 'Thursday' || 'Friday' => 'Weekday',
    'Saturday' || 'Sunday' => 'Weekend',
    _ => 'Unknown'
  };
  
  print('$day is a $dayType');
  
  // Switch expression (Dart 3.0+)
  int dayNumber = 1;
  String dayName = switch (dayNumber) {
    1 => 'Senin',
    2 => 'Selasa',
    3 => 'Rabu',
    4 => 'Kamis',
    5 => 'Jumat',
    6 => 'Sabtu',
    7 => 'Minggu',
    _ => 'Tidak valid'
  };
  
  print('Hari ke-$dayNumber: $dayName\n');
}

void demonstrateLoops() {
  print('3. LOOPS:');
  
  // For loop
  print('For loop (1-5):');
  for (int i = 1; i <= 5; i++) {
    print('  $i');
  }
  
  // For-in loop
  List<String> colors = ['merah', 'hijau', 'biru'];
  print('For-in loop (colors):');
  for (String color in colors) {
    print('  $color');
  }
  
  // While loop
  print('While loop (countdown):');
  int countdown = 3;
  while (countdown > 0) {
    print('  $countdown');
    countdown--;
  }
  print('  Selesai!');
  
  // Do-while loop
  print('Do-while loop:');
  int number = 1;
  do {
    print('  Number: $number');
    number++;
  } while (number <= 3);
  
  // Break and continue
  print('Break and continue:');
  for (int i = 1; i <= 10; i++) {
    if (i == 5) continue; // skip 5
    if (i == 8) break;    // stop at 8
    print('  $i');
  }
  print('');
}

void demonstrateExceptionHandling() {
  print('4. EXCEPTION HANDLING:');
  
  // Try-catch
  try {
    int result = 10 ~/ 0; // Integer division by zero
    print('Result: $result');
  } catch (e) {
    print('Error caught: $e');
  }
  
  // Try-catch with specific exception type
  try {
    List<int> numbers = [1, 2, 3];
    print('Element at index 5: ${numbers[5]}');
  } on RangeError catch (e) {
    print('Range error: ${e.message}');
  } catch (e) {
    print('Other error: $e');
  }
  
  // Try-catch-finally
  try {
    String? nullString;
    print('Length: ${nullString!.length}'); // Force unwrap null
  } catch (e) {
    print('Null error caught: $e');
  } finally {
    print('Finally block always executes');
  }
  
  // Custom exception
  try {
    validateAge(-5);
  } on InvalidAgeException catch (e) {
    print('Custom exception: ${e.message}');
  }
  
  print('');
}

// Custom exception class
class InvalidAgeException implements Exception {
  final String message;
  InvalidAgeException(this.message);
}

void validateAge(int age) {
  if (age < 0) {
    throw InvalidAgeException('Umur tidak boleh negatif: $age');
  }
}
