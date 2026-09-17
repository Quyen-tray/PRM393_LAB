// ===========================================================
// Lab 2 - Dart Essentials Practice Lab - Full Solution
// Covers Exercises 1-5. Run with `dart run lab2_solution.dart`
// or paste into DartPad.
// ===========================================================

import 'dart:async';

void main() async {
  print('======== EXERCISE 1: Basic Syntax & Data Types ========');
  exercise1BasicSyntax();

  print('\n======== EXERCISE 2: Collections & Operators ========');
  exercise2Collections();

  print('\n======== EXERCISE 3: Control Flow & Functions ========');
  exercise3ControlFlow();

  print('\n======== EXERCISE 4: Intro to OOP ========');
  exercise4Oop();

  print('\n======== EXERCISE 5: Async, Future, Null Safety & Streams ========');
  await exercise5Async();
}

// ---------------------------------------------------------
// EXERCISE 1 - Basic Syntax & Data Types
// Goal: practice program structure and variable declarations.
// ---------------------------------------------------------
void exercise1BasicSyntax() {
  // Declare variables of the four core types
  int age = 21; // whole numbers
  double height = 1.72; // decimal numbers
  String name = 'Minh'; // text
  bool isStudent = true; // true/false

  // print() + string interpolation: $var and ${expr}
  print('Name: $name');
  print('Age: $age');
  print('Height: ${height.toStringAsFixed(2)} m');
  print('Is student: $isStudent');
  print('Next year $name will be ${age + 1} years old.');
}

// ---------------------------------------------------------
// EXERCISE 2 - Collections & Operators
// Goal: work with List, Set, Map and operators (+, -, ==, &&, ?:).
// ---------------------------------------------------------
void exercise2Collections() {
  // List of integers
  List<int> scores = [80, 92, 75, 60, 88];

  // Arithmetic & comparison operators
  int total = 0;
  for (int s in scores) {
    total += s; // arithmetic: +=
  }
  double average = total / scores.length;
  bool passedAll = scores.every((s) => s >= 60); // comparison inside a lambda
  bool hasPerfectAndPass = passedAll && scores.contains(100); // logical &&
  String verdict = passedAll ? 'All students passed' : 'Some students failed'; // ?:

  print('Scores: $scores');
  print('Total: $total, Average: ${average.toStringAsFixed(1)}');
  print('passedAll && has100 = $hasPerfectAndPass');
  print(verdict);

  // Set: only unique values are kept
  Set<String> fruits = {'apple', 'banana', 'apple', 'mango'};
  fruits.add('banana'); // duplicate, ignored
  fruits.remove('mango');
  print('Fruits (Set, unique): $fruits');

  // Map: key-value pairs
  Map<String, int> ages = {'Lan': 20, 'Huy': 22, 'Mai': 19};
  ages['Tuan'] = 23; // add
  ages.remove('Huy'); // remove
  print('Ages (Map): $ages');

  // Indexing and map access
  print('First score (index 0): ${scores[0]}');
  print("Mai's age (map access): ${ages['Mai']}");
}

// ---------------------------------------------------------
// EXERCISE 3 - Control Flow & Functions
// Goal: apply if/else, switch, loops, and functions.
// ---------------------------------------------------------
void exercise3ControlFlow() {
  // if / else to check a score
  int score = 78;
  if (score >= 90) {
    print('Grade: A');
  } else if (score >= 70) {
    print('Grade: B');
  } else if (score >= 50) {
    print('Grade: C');
  } else {
    print('Grade: F');
  }

  // switch case for day of week
  int day = 3;
  switch (day) {
    case 1:
      print('Monday');
      break;
    case 2:
      print('Tuesday');
      break;
    case 3:
      print('Wednesday');
      break;
    case 4:
      print('Thursday');
      break;
    case 5:
      print('Friday');
      break;
    default:
      print('Weekend');
  }

  // Loop through a collection: for, for-in, forEach()
  List<String> colors = ['red', 'green', 'blue'];

  for (int i = 0; i < colors.length; i++) {
    print('for-loop[$i]: ${colors[i]}');
  }

  for (String c in colors) {
    print('for-in: $c');
  }

  colors.forEach((c) => print('forEach: $c'));

  // Function using normal syntax
  int square(int x) {
    return x * x;
  }

  // Function using arrow syntax
  int cube(int x) => x * x * x;

  print('square(4) = ${square(4)}');
  print('cube(3) = ${cube(3)}');
}

// ---------------------------------------------------------
// EXERCISE 4 - Intro to OOP
// Goal: classes, objects, constructors, inheritance, overriding.
// ---------------------------------------------------------
class Car {
  String brand;

  // Default constructor
  Car(this.brand);

  // Named constructor
  Car.unknown() : brand = 'Unknown brand';

  // Method that can be overridden by subclasses
  void drive() {
    print('$brand is driving using a gasoline engine.');
  }
}

class ElectricCar extends Car {
  ElectricCar(super.brand);

  // Method overriding
  @override
  void drive() {
    print('$brand is driving silently on electric power.');
  }
}

void exercise4Oop() {
  Car car1 = Car('Toyota');
  car1.drive();

  Car car2 = Car.unknown(); // named constructor
  car2.drive();

  ElectricCar tesla = ElectricCar('Tesla'); // inheritance
  tesla.drive(); // overridden method

  // Treat subclass as parent type (polymorphism)
  Car genericRef = tesla;
  genericRef.drive();
}

// ---------------------------------------------------------
// EXERCISE 5 - Async, Future, Null Safety & Streams
// Goal: work with Dart's asynchronous features.
// ---------------------------------------------------------

// Async function using Future + await, with Future.delayed to simulate loading
Future<String> loadData() async {
  print('Loading data...');
  await Future.delayed(Duration(seconds: 1)); // simulate network/IO delay
  return 'Data loaded successfully';
}

// A simple Stream that emits integers 1..5, one per second
Stream<int> countStream() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(Duration(milliseconds: 200));
    yield i;
  }
}

Future<void> exercise5Async() async {
  // await a Future
  String result = await loadData();
  print(result);

  // Null-safety operators: ?, ??, !
  String? nickname; // nullable variable
  print('Nickname length (safe call ?.): ${nickname?.length}');

  String displayName = nickname ?? 'Guest'; // ?? provides a default
  print('Display name: $displayName');

  nickname = 'Kai';
  print('Forced non-null (!): ${nickname!.toUpperCase()}');

  // Listen to a Stream of integers
  await for (int value in countStream()) {
    print('Stream emitted: $value');
  }
  print('Stream finished.');
}