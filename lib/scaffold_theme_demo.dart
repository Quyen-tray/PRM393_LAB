import 'package:flutter/material.dart';

import 'main.dart' show themeModeNotifier;

/// Exercise 4 – Scaffold, AppBar, FloatingActionButton, ThemeData, Dark Mode
/// ThemeData (sáng/tối) được định nghĩa trong MaterialApp (main.dart).
/// Màn hình này chỉ đổi themeMode thông qua themeModeNotifier.
class ScaffoldThemeDemo extends StatefulWidget {
  const ScaffoldThemeDemo({super.key});

  @override
  State<ScaffoldThemeDemo> createState() => _ScaffoldThemeDemoState();
}

class _ScaffoldThemeDemoState extends State<ScaffoldThemeDemo> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = themeModeNotifier.value == ThemeMode.dark;

    return Scaffold(
      // ----- AppBar -----
      appBar: AppBar(
        title: const Text('Exercise 4 – Scaffold & Theme'),
        actions: [
          // Nút đổi theme nhanh trên AppBar
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
            tooltip: 'Toggle theme',
          ),
        ],
      ),

      // ----- Body -----
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Button pressed',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),

              // ----- Dark Mode toggle -----
              Card(
                child: SwitchListTile(
                  title: const Text('Dark Mode'),
                  secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                  value: isDark,
                  onChanged: (_) => _toggleTheme(),
                ),
              ),
            ],
          ),
        ),
      ),

      // ----- FloatingActionButton -----
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _counter++),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Đổi themeMode toàn app, sau đó setState để cập nhật icon/switch.
  void _toggleTheme() {
    themeModeNotifier.value =
    themeModeNotifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setState(() {});
  }
}