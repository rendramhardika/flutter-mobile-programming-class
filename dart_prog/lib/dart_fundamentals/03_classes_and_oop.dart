// Object-Oriented Programming di Dart

void main() {
  print('=== OBJECT-ORIENTED PROGRAMMING DART ===\n');
  
  // 1. Classes dan Objects
  demonstrateClasses();
  
  // 2. Inheritance
  demonstrateInheritance();
  
  // 3. Abstract Classes dan Interfaces
  demonstrateAbstractClasses();
  
  // 4. Mixins
  demonstrateMixins();
  
  // 5. Enums
  demonstrateEnums();
}

void demonstrateClasses() {
  print('1. CLASSES DAN OBJECTS:');
  
  // Membuat object
  Person person1 = Person('Alice', 25);
  Person person2 = Person.withEmail('Bob', 30, 'bob@email.com');
  
  print('Person 1: ${person1.getInfo()}');
  print('Person 2: ${person2.getInfo()}');
  
  // Menggunakan getter dan setter
  person1.age = 26;
  print('Updated age: ${person1.age}');
  
  // Static members
  print('Total persons created: ${Person.totalPersons}');
  
  // Bank account example
  BankAccount account = BankAccount('12345', 1000.0);
  account.deposit(500.0);
  account.withdraw(200.0);
  print('Account balance: ${account.getBalance()}\n');
}

void demonstrateInheritance() {
  print('2. INHERITANCE:');
  
  Student student = Student('Charlie', 20, 'S001');
  Teacher teacher = Teacher('Dr. Smith', 45, 'Mathematics');
  
  print('Student: ${student.getInfo()}');
  print('Student ID: ${student.studentId}');
  student.study();
  
  print('Teacher: ${teacher.getInfo()}');
  print('Subject: ${teacher.subject}');
  teacher.teach();
  
  print('');
}

void demonstrateAbstractClasses() {
  print('3. ABSTRACT CLASSES DAN INTERFACES:');
  
  List<Shape> shapes = [
    Circle(5.0),
    Rectangle(4.0, 6.0),
    Triangle(3.0, 4.0),
  ];
  
  for (Shape shape in shapes) {
    print('${shape.runtimeType}: Area = ${shape.calculateArea().toStringAsFixed(2)}');
    shape.draw();
  }
  
  print('');
}

void demonstrateMixins() {
  print('4. MIXINS:');
  
  Dog dog = Dog('Buddy');
  Bird bird = Bird('Tweety');
  Fish fish = Fish('Nemo');
  
  dog.eat();
  dog.walk();
  
  bird.eat();
  bird.fly();
  
  fish.eat();
  fish.swim();
  
  print('');
}

void demonstrateEnums() {
  print('5. ENUMS:');
  
  // Basic enum
  Color favoriteColor = Color.blue;
  print('Favorite color: $favoriteColor');
  
  // Enhanced enum (Dart 2.17+)
  Planet earth = Planet.earth;
  print('Planet: ${earth.name}');
  print('Distance from sun: ${earth.distanceFromSun} million km');
  print('Has life: ${earth.hasLife}');
  
  // Enum in switch
  String colorDescription = switch (favoriteColor) {
    Color.red => 'Warna merah seperti api',
    Color.green => 'Warna hijau seperti daun',
    Color.blue => 'Warna biru seperti langit',
  };
  
  print('Color description: $colorDescription\n');
}

// Basic class
class Person {
  String name;
  int _age; // private field
  String? email;
  static int totalPersons = 0;
  
  // Constructor
  Person(this.name, this._age) {
    totalPersons++;
  }
  
  // Named constructor
  Person.withEmail(this.name, this._age, this.email) {
    totalPersons++;
  }
  
  // Getter
  int get age => _age;
  
  // Setter
  set age(int value) {
    if (value >= 0) {
      _age = value;
    }
  }
  
  // Method
  String getInfo() {
    String info = 'Name: $name, Age: $_age';
    if (email != null) {
      info += ', Email: $email';
    }
    return info;
  }
}

// Class with private members
class BankAccount {
  String _accountNumber;
  double _balance;
  
  BankAccount(this._accountNumber, this._balance);
  
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print('Deposited: \$${amount.toStringAsFixed(2)}');
    }
  }
  
  bool withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      print('Withdrawn: \$${amount.toStringAsFixed(2)}');
      return true;
    }
    print('Insufficient funds or invalid amount');
    return false;
  }
  
  double getBalance() => _balance;
}

// Inheritance
class Student extends Person {
  String studentId;
  
  Student(String name, int age, this.studentId) : super(name, age);
  
  void study() {
    print('$name is studying...');
  }
  
  @override
  String getInfo() {
    return '${super.getInfo()}, Student ID: $studentId';
  }
}

class Teacher extends Person {
  String subject;
  
  Teacher(String name, int age, this.subject) : super(name, age);
  
  void teach() {
    print('$name is teaching $subject...');
  }
}

// Abstract class
abstract class Shape {
  double calculateArea();
  void draw() {
    print('Drawing ${runtimeType}...');
  }
}

class Circle extends Shape {
  double radius;
  
  Circle(this.radius);
  
  @override
  double calculateArea() {
    return 3.14159 * radius * radius;
  }
}

class Rectangle extends Shape {
  double width, height;
  
  Rectangle(this.width, this.height);
  
  @override
  double calculateArea() {
    return width * height;
  }
}

class Triangle extends Shape {
  double base, height;
  
  Triangle(this.base, this.height);
  
  @override
  double calculateArea() {
    return 0.5 * base * height;
  }
}

// Mixins
mixin Eater {
  void eat() {
    print('Eating...');
  }
}

mixin Walker {
  void walk() {
    print('Walking...');
  }
}

mixin Flyer {
  void fly() {
    print('Flying...');
  }
}

mixin Swimmer {
  void swim() {
    print('Swimming...');
  }
}

class Animal {
  String name;
  Animal(this.name);
}

class Dog extends Animal with Eater, Walker {
  Dog(String name) : super(name);
}

class Bird extends Animal with Eater, Flyer {
  Bird(String name) : super(name);
}

class Fish extends Animal with Eater, Swimmer {
  Fish(String name) : super(name);
}

// Basic enum
enum Color { red, green, blue }

// Enhanced enum
enum Planet {
  mercury(57.9, false),
  venus(108.2, false),
  earth(149.6, true),
  mars(227.9, false);
  
  const Planet(this.distanceFromSun, this.hasLife);
  
  final double distanceFromSun; // million km
  final bool hasLife;
}
