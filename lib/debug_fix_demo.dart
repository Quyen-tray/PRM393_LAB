import 'package:flutter/material.dart';

/// Exercise 5 – Debug & Fix Common UI Errors
///
/// Các lỗi thường gặp và cách sửa (đã áp dụng trong file này):
///
/// 1. ListView trong Column  -> lỗi "Vertical viewport was given unbounded height".
///    Sửa: bọc ListView bằng Expanded (cho ListView chiều cao xác định).
///
/// 2. Overflow trên màn hình nhỏ ("RIGHT/BOTTOM OVERFLOWED BY ... PIXELS").
///    Sửa: bọc nội dung dài bằng SingleChildScrollView.
///
/// 3. UI không cập nhật khi đổi dữ liệu.
///    Sửa: gọi setState(() { ... }) khi thay đổi biến state.
///
/// 4. showDatePicker lỗi "No MaterialLocalizations found" / context sai.
///    Sửa: gọi từ context nằm DƯỚI MaterialApp (trong widget tree hợp lệ),
///    ví dụ trong State của widget hoặc dùng Builder.
class DebugFixDemo extends StatefulWidget {
  const DebugFixDemo({super.key});

  @override
  State<DebugFixDemo> createState() => _DebugFixDemoState();
}

class _DebugFixDemoState extends State<DebugFixDemo> {
  int _count = 0;
  DateTime? _date;
  final List<String> _items = List.generate(15, (i) => 'Item ${i + 1}');

  // FIX 4: context hợp lệ vì được gọi từ bên trong widget tree (dưới MaterialApp)
  Future<void> _pickDate(BuildContext ctx) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // FIX 3: phải có setState thì UI mới cập nhật
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 5 – Debug & Fix')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FIX 2: phần trên có thể dài -> cho cuộn được để không bị overflow
            // Bọc trong Flexible để nó co lại khi màn hình thấp.
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Fix 3: setState()',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Counter: $_count',
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          // FIX 3: thêm setState để giao diện build lại
                          onPressed: () => setState(() => _count++),
                          child: const Text('+1'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Fix 4: DatePicker với context hợp lệ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    // Builder cung cấp context nằm trong widget tree
                    Builder(
                      builder: (ctx) => ElevatedButton.icon(
                        onPressed: () => _pickDate(ctx),
                        icon: const Icon(Icons.calendar_today),
                        label: Text(_date == null
                            ? 'Pick a date'
                            : '${_date!.day}/${_date!.month}/${_date!.year}'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Fix 2: SingleChildScrollView chống overflow trên màn hình nhỏ. '
                          'Hãy xoay ngang thiết bị hoặc thu nhỏ cửa sổ để kiểm tra. '
                          'Đoạn văn này đủ dài để gây overflow nếu không có scroll.',
                    ),
                    const SizedBox(height: 16),
                    const Text('Fix 1: ListView trong Column dùng Expanded',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // FIX 1: ListView trong Column PHẢI có Expanded
            // (Sai: Column(children: [ListView(...)]) -> unbounded height)
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, i) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(_items[i]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}