import 'package:flutter/material.dart';

/// Exercise 1 – Core Widgets: Text, Icon, Image, Card, ListTile
class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 1 – Core Widgets')),
      // SingleChildScrollView tránh bị tràn màn hình nhỏ
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Text tiêu đề
            Text(
              'Welcome to Flutter!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // 2. Icon (Material Icons)
            Row(
              children: const [
                Icon(Icons.favorite, color: Colors.red, size: 32),
                SizedBox(width: 8),
                Icon(Icons.star, color: Colors.amber, size: 32),
                SizedBox(width: 8),
                Icon(Icons.flutter_dash, color: Colors.blue, size: 32),
              ],
            ),
            const SizedBox(height: 16),

            // 3. Image.network (bo góc bằng ClipRRect)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://picsum.photos/600/300',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                // Hiển thị vòng tròn loading khi ảnh đang tải
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                // Hiển thị icon lỗi nếu không có mạng
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 180,
                  child: Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 4. Card chứa ListTile
            Card(
              elevation: 3,
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('Nguyen Van A'),
                subtitle: const Text('Flutter Developer'),
                trailing: const Icon(Icons.more_vert),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bạn vừa bấm vào ListTile')),
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