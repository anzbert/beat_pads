import 'package:flutter/material.dart';

class DropdownInt extends StatelessWidget {
  const DropdownInt({
    required this.setValue,
    required this.readValue,
    required this.size,
    this.start = 0,
    super.key,
  });

  final void Function(int) setValue;
  final int readValue;
  final int size;
  final int start;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<int>> menuItems = List.generate(
      size,
      (index) => DropdownMenuItem<int>(
        value: index + start,
        child: Text(
          (index + start).toString(),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<int>(
        value: readValue,
        items: menuItems.toList(),
        onChanged: (int? value) {
          if (value != null) setValue(value);
        },
      ),
    );
  }
}
