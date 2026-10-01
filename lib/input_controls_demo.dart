import 'package:flutter/material.dart';

/// Exercise 2 – Input Widgets: Slider, Switch, RadioListTile, DatePicker
/// Dùng StatefulWidget vì giá trị thay đổi theo thao tác của người dùng.
class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderValue = 50;
  bool _switchValue = false;
  String _gender = 'Male';
  DateTime? _selectedDate;

  // Mở DatePicker. Hàm nằm trong State nên `context` hợp lệ
  // (nằm dưới MaterialApp).
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 2 – Input Widgets')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ----- Slider -----
          Text('Slider: ${_sliderValue.round()}',
              style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _sliderValue,
            min: 0,
            max: 100,
            divisions: 100,
            label: _sliderValue.round().toString(),
            onChanged: (v) => setState(() => _sliderValue = v),
          ),
          const Divider(),

          // ----- Switch -----
          SwitchListTile(
            title: const Text('Enable notifications'),
            value: _switchValue,
            onChanged: (v) => setState(() => _switchValue = v),
          ),
          const Divider(),

          // ----- RadioListTile -----
          Text('Gender', style: Theme.of(context).textTheme.titleMedium),
          RadioListTile<String>(
            title: const Text('Male'),
            value: 'Male',
            groupValue: _gender,
            onChanged: (v) => setState(() => _gender = v!),
          ),
          RadioListTile<String>(
            title: const Text('Female'),
            value: 'Female',
            groupValue: _gender,
            onChanged: (v) => setState(() => _gender = v!),
          ),
          RadioListTile<String>(
            title: const Text('Other'),
            value: 'Other',
            groupValue: _gender,
            onChanged: (v) => setState(() => _gender = v!),
          ),
          const Divider(),

          // ----- DatePicker -----
          ElevatedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today),
            label: const Text('Pick a date'),
          ),
          const SizedBox(height: 16),

          // ----- Hiển thị giá trị hiện tại -----
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current values',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Slider: ${_sliderValue.round()}'),
                  Text('Switch: ${_switchValue ? "ON" : "OFF"}'),
                  Text('Gender: $_gender'),
                  Text(
                    'Date: ${_selectedDate == null ? "Not selected" : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}