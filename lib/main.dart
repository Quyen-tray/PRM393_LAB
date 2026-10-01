import 'package:flutter/material.dart';

import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_basics_demo.dart';
import 'scaffold_theme_demo.dart';
import 'debug_fix_demo.dart';

/// Notifier toàn cục lưu chế độ sáng/tối.
/// Exercise 4 sẽ thay đổi giá trị này để bật/tắt Dark Mode.
final ValueNotifier<ThemeMode> themeModeNotifier =
ValueNotifier<ThemeMode>(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lắng nghe themeModeNotifier: khi đổi giá trị, MaterialApp build lại.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Lab 4 - Flutter UI Fundamentals',
          debugShowCheckedModeBanner: false,
          // Theme sáng
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.light,
            ),
          ),
          // Theme tối
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: mode,
          home: const HomeMenu(),
        );
      },
    );
  }
}

/// Màn hình menu để chọn từng bài tập.
class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = <_Exercise>[
      _Exercise('Exercise 1 – Core Widgets', Icons.widgets,
          const CoreWidgetsDemo()),
      _Exercise('Exercise 2 – Input Widgets', Icons.tune,
          const InputControlsDemo()),
      _Exercise('Exercise 3 – Layout Basics', Icons.view_agenda,
          const LayoutBasicsDemo()),
      _Exercise('Exercise 4 – Scaffold & Theme', Icons.palette,
          const ScaffoldThemeDemo()),
      _Exercise('Exercise 5 – Debug & Fix UI', Icons.bug_report,
          const DebugFixDemo()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Lab 4 – Flutter UI')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final e = exercises[i];
          return Card(
            child: ListTile(
              leading: Icon(e.icon),
              title: Text(e.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => e.page),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Exercise {
  final String title;
  final IconData icon;
  final Widget page;
  _Exercise(this.title, this.icon, this.page);
}