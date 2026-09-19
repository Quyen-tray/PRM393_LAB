// ===========================================================
// Lab 3 - Advanced Dart Practice Exercises - Full Solution
// Covers Exercises 1-5. Run with `dart run lab3_solution.dart`
// or paste into DartPad. Pure Dart - no Flutter dependency needed.
// ===========================================================

import 'dart:async';
import 'dart:convert';

void main() async {
  print('======== EXERCISE 1: Product Model & Repository ========');
  await exercise1ProductRepository();

  print('\n======== EXERCISE 2: User Repository with JSON ========');
  await exercise2UserRepositoryJson();

  print('\n======== EXERCISE 3: Async + Microtask Debugging ========');
  exercise3MicrotaskDebugging();
  // Give the event loop a moment so the queued callbacks above finish
  // printing before we move on to Exercise 4's output.
  await Future.delayed(const Duration(milliseconds: 50));

  print('\n======== EXERCISE 4: Stream Transformation ========');
  await exercise4StreamTransformation();

  print('\n======== EXERCISE 5: Factory Constructors & Cache ========');
  exercise5FactoryCache();
}

// ---------------------------------------------------------
// EXERCISE 1 - Product Model & Repository
// Goal: understand Futures and Streams.
// ---------------------------------------------------------
class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$${price.toStringAsFixed(2)})';
}

class ProductRepository {
  // In-memory "database" of products.
  final List<Product> _products = [
    Product(id: 'p1', name: 'Keyboard', price: 25.0),
    Product(id: 'p2', name: 'Mouse', price: 12.5),
    Product(id: 'p3', name: 'Monitor', price: 150.0),
  ];

  // Broadcast controller lets multiple listeners subscribe to live updates.
  final StreamController<Product> _liveController = StreamController<Product>.broadcast();

  // Future-based read: fetch the whole catalog once.
  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 100)); // simulate I/O
    return List.unmodifiable(_products);
  }

  // Stream-based read: notifies listeners whenever a new product is added.
  Stream<Product> liveAdded() => _liveController.stream;

  // Simulates a new product arriving (e.g. pushed from a server).
  void addProduct(Product product) {
    _products.add(product);
    _liveController.add(product); // emit on the broadcast stream
  }

  void dispose() => _liveController.close();
}

Future<void> exercise1ProductRepository() async {
  final repo = ProductRepository();

  // Listen to live additions before they happen.
  final subscription = repo.liveAdded().listen((product) {
    print('Live update received: $product');
  });

  final all = await repo.getAll();
  print('All products (Future):');
  for (final p in all) {
    print('  $p');
  }

  // Trigger a couple of live additions.
  repo.addProduct(Product(id: 'p4', name: 'Webcam', price: 45.0));
  repo.addProduct(Product(id: 'p5', name: 'Headset', price: 30.0));

  // Give the stream events time to fire before cleaning up.
  await Future.delayed(const Duration(milliseconds: 50));
  await subscription.cancel();
  repo.dispose();
}

// ---------------------------------------------------------
// EXERCISE 2 - User Repository with JSON
// Goal: practice JSON serialization / deserialization.
// ---------------------------------------------------------
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Factory constructor that builds a User from a decoded JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  @override
  String toString() => 'User(name: $name, email: $email)';
}

class UserRepository {
  // Simulates a raw JSON response coming from an API.
  Future<String> _fetchRawJson() async {
    await Future.delayed(const Duration(milliseconds: 100)); // simulate network
    return jsonEncode([
      {'name': 'Lan Nguyen', 'email': 'lan.nguyen@example.com'},
      {'name': 'Huy Tran', 'email': 'huy.tran@example.com'},
      {'name': 'Mai Pham', 'email': 'mai.pham@example.com'},
    ]);
  }

  // Fetches and parses the JSON into a list of typed User objects.
  Future<List<User>> fetchUsers() async {
    final rawJson = await _fetchRawJson();
    final List<dynamic> decoded = jsonDecode(rawJson) as List<dynamic>;
    return decoded
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

Future<void> exercise2UserRepositoryJson() async {
  final repo = UserRepository();
  final users = await repo.fetchUsers();

  print('Users parsed from JSON:');
  for (final u in users) {
    print('  $u');
  }
}

// ---------------------------------------------------------
// EXERCISE 3 - Async + Microtask Debugging
// Goal: differentiate microtask and event queues.
// ---------------------------------------------------------
void exercise3MicrotaskDebugging() {
  print('1: synchronous code (main body) - runs first, immediately');

  // Future(() {...}) schedules work on the EVENT queue.
  Future(() {
    print('4: Future(() {...}) callback - runs from the EVENT queue');
  });

  // scheduleMicrotask schedules work on the MICROTASK queue.
  scheduleMicrotask(() {
    print('3: scheduleMicrotask callback - runs from the MICROTASK queue');
  });

  print('2: synchronous code (main body) - runs second, immediately');

  // Expected order: 1, 2, 3, 4
  //
  // Why: Dart's event loop always drains the entire MICROTASK queue
  // before it processes the next task in the EVENT queue. All
  // synchronous code in the current call stack finishes first (1, 2).
  // Then, before the loop moves on to any event-queue task (like the
  // Future() callback), it fully empties the microtask queue - so the
  // scheduleMicrotask callback (3) always runs before the Future
  // callback (4), even though Future() was scheduled first in the code.
  print('   (explanation: microtasks fully drain before the event queue advances)');
}

// ---------------------------------------------------------
// EXERCISE 4 - Stream Transformation
// Goal: use functional stream operators.
// ---------------------------------------------------------
Stream<int> numberStream() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(const Duration(milliseconds: 20));
    yield i;
  }
}

Future<void> exercise4StreamTransformation() async {
  print('Numbers 1-5, squared, then filtered to even results only:');

  final transformed = numberStream()
      .map((n) => n * n) // transform each value to its square
      .where((n) => n % 2 == 0); // keep only even squares

  await for (final value in transformed) {
    print('  Emitted: $value');
  }
  print('Stream transformation complete.');
}

// ---------------------------------------------------------
// EXERCISE 5 - Factory Constructors & Cache
// Goal: show how factory constructors implement caching (singleton).
// ---------------------------------------------------------
class Settings {
  final String theme;

  // Private named constructor - only this class can build a real instance.
  Settings._internal(this.theme);

  // The single cached instance, created once and reused afterwards.
  static Settings? _instance;

  // Public factory constructor: returns the cached instance if it
  // already exists, otherwise creates it exactly once.
  factory Settings() {
    _instance ??= Settings._internal('dark');
    return _instance!;
  }
}

void exercise5FactoryCache() {
  final a = Settings();
  final b = Settings();

  print('Settings A theme: ${a.theme}');
  print('Settings B theme: ${b.theme}');
  print('identical(a, b) => ${identical(a, b)}'); // true: same cached instance
}