import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class DropdownRootNote extends StatelessWidget {
  const DropdownRootNote({
    required this.setValue,
    required this.readValue,
    super.key,
  });

  final void Function(int) setValue;
  final int readValue;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<int>> menuItems = List.generate(
      12,
      (index) => DropdownMenuItem<int>(
        value: index,
        child: Text(
          MidiUtils.getNoteName(
            index,
            showOctaveIndex: false,
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<int>(
        value: readValue,
        items: menuItems.toList(),
        onChanged: (value) {
          if (value != null) setValue(value);
        },
      ),
    );
  }
}
