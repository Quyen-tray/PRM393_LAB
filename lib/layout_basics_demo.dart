import 'package:flutter/material.dart';

/// Exercise 3 – Layout Basics: Column, Row, Padding, SizedBox, ListView.builder
/// Giao diện giống một màn hình Home đơn giản.
class LayoutBasicsDemo extends StatelessWidget {
  const LayoutBasicsDemo({super.key});

  // Dữ liệu mẫu
  static const List<String> _movies = [
    'Inception',
    'Interstellar',
    'The Dark Knight',
    'Parasite',
    'Spirited Away',
    'The Matrix',
    'Avengers: Endgame',
    'Your Name',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 3 – Layout Basics')),
      // Padding 16 bao quanh toàn bộ nội dung
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Column: chia màn hình thành các section theo chiều dọc
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Section 1: lời chào -----
            Text('Hello, Movie Lover 👋',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Find your next favorite movie'),
            const SizedBox(height: 16),

            // ----- Section 2: Row các nút thể loại -----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _CategoryChip(icon: Icons.local_fire_department, label: 'Hot'),
                _CategoryChip(icon: Icons.new_releases, label: 'New'),
                _CategoryChip(icon: Icons.favorite, label: 'Liked'),
              ],
            ),
            const SizedBox(height: 16),

            // ----- Section 3: tiêu đề danh sách -----
            Text('Popular Movies',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),

            // ----- Section 4: ListView.builder -----
            // Phải bọc trong Expanded vì ListView nằm trong Column
            Expanded(
              child: ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(_movies[index]),
                        subtitle: const Text('Rating: 8.5'),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget nhỏ tái sử dụng: Icon + nhãn, dùng trong Row.
class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CategoryChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}